"""
Model loading and management
"""

import os
import sys
import torch
from typing import Dict, Optional

# Add lib directory to path
lib_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'lib')
if lib_path not in sys.path:
    sys.path.append(lib_path)

from lib.model import ModelMLP
from lib.model_v2 import ModelMLPV2
from api.config import MODEL_PATHS, CLASS_NAMES, DEVICE, NUM_FEATURES


class ModelManager:
    """Manages loading and accessing ML models"""
    
    def __init__(self):
        self.models: Dict[str, torch.nn.Module] = {}
    
    def load_model(self, model_type: str) -> bool:
        """
        Load a specific model
        
        Args:
            model_type: Type of model to load ('mlp' or 'mlpv2')
        
        Returns:
            True if successful, False otherwise
        """
        try:
            print(f"Loading {model_type} model...")
            
            if model_type not in MODEL_PATHS:
                raise ValueError(f"Unknown model type: {model_type}")
            
            model_path = MODEL_PATHS[model_type]
            
            if not os.path.exists(model_path):
                print(f"Warning: Model file not found at {model_path}")
                return False
            
            # Create model instance based on type
            if model_type == "mlp":
                model = ModelMLP(num_classes=len(CLASS_NAMES), dropout_rate=0.5)
            elif model_type == "mlpv2":
                model = ModelMLPV2(
                    num_features=NUM_FEATURES,
                    num_classes=len(CLASS_NAMES),
                    hidden_dims=[256, 512, 256, 128],
                    dropout_rate=0.3,
                    use_residual=True
                )
            else:
                raise ValueError(f"Unknown model type: {model_type}")
            
            # Load checkpoint
            checkpoint = torch.load(model_path, map_location=DEVICE)
            
            # Handle different checkpoint formats
            if isinstance(checkpoint, dict) and 'model_state_dict' in checkpoint:
                model.load_state_dict(checkpoint['model_state_dict'])
            else:
                model.load_state_dict(checkpoint)
            
            model = model.to(DEVICE)
            model.eval()
            self.models[model_type] = model
            print(f"Model {model_type} loaded successfully on {DEVICE}")
            return True
        
        except Exception as e:
            print(f"Error loading model {model_type}: {e}")
            import traceback
            traceback.print_exc()
            return False
    
    def load_all_models(self) -> bool:
        """
        Load all available models
        
        Returns:
            True if at least one model loaded successfully
        """
        success_count = 0
        for model_type in MODEL_PATHS.keys():
            if self.load_model(model_type):
                success_count += 1
        return success_count > 0
    
    def get_model(self, model_type: str) -> Optional[torch.nn.Module]:
        """
        Get a loaded model
        
        Args:
            model_type: Type of model to retrieve
        
        Returns:
            Model instance or None if not loaded
        """
        return self.models.get(model_type)
    
    def is_loaded(self, model_type: str) -> bool:
        """Check if a model is loaded"""
        return model_type in self.models
    
    def get_loaded_models(self) -> list:
        """Get list of loaded model types"""
        return list(self.models.keys())
    
    def get_models_status(self) -> Dict[str, bool]:
        """Get loading status of all models"""
        return {model_type: self.is_loaded(model_type) for model_type in MODEL_PATHS.keys()}


# Global model manager instance
model_manager = ModelManager()
