"""
API route handlers
"""

import os
from fastapi import APIRouter, File, UploadFile, HTTPException, Query
from PIL import Image
import io
from typing import List

from api.models import (
    PredictionResponse,
    HealthResponse,
    ClassesResponse,
    ModelsInfoResponse,
    ModelInfo,
    BatchPredictionResponse,
    BatchPredictionResult
)
from api.config import (
    CLASS_NAMES,
    DEVICE,
    MODEL_PATHS,
    VALID_SEGMENTATION_METHODS
)
from api.model_loader import model_manager
from api.inference import predict_image


# Create router
router = APIRouter()


@router.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Vegetable Classification API",
        "docs": "/docs",
        "health": "/health"
    }


@router.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    models_status = model_manager.get_models_status()
    available_models = model_manager.get_loaded_models()
    
    return HealthResponse(
        status="healthy" if len(available_models) > 0 else "unhealthy",
        models_loaded=models_status,
        device=str(DEVICE),
        num_classes=len(CLASS_NAMES),
        class_names=CLASS_NAMES,
        available_models=available_models
    )


@router.get("/classes", response_model=ClassesResponse)
async def get_classes():
    """Get list of available classes"""
    return ClassesResponse(classes=CLASS_NAMES)


@router.get("/models", response_model=ModelsInfoResponse)
async def get_models_info():
    """Get information about available models"""
    models_info = {}
    
    for model_type in MODEL_PATHS.keys():
        model_loaded = model_manager.is_loaded(model_type)
        model_path = MODEL_PATHS[model_type]
        
        info_dict = {
            "loaded": model_loaded,
            "path": model_path,
            "exists": os.path.exists(model_path)
        }
        
        if model_type == "mlp":
            info_dict["architecture"] = "Simple MLP"
            info_dict["hidden_layers"] = "512 -> 256"
            info_dict["dropout"] = 0.5
        elif model_type == "mlpv2":
            info_dict["architecture"] = "MLP with Residual Connections"
            info_dict["hidden_layers"] = "256 -> 512 -> 256 -> 128"
            info_dict["dropout"] = "Progressive (0.3 -> 0.15 -> 0.075 -> 0.0375)"
            info_dict["features"] = ["Residual Blocks", "BatchNorm", "Kaiming Init"]
        
        models_info[model_type] = ModelInfo(**info_dict)
    
    return ModelsInfoResponse(
        available_models=model_manager.get_loaded_models(),
        total_models=len(MODEL_PATHS),
        models=models_info
    )


@router.post("/predict", response_model=PredictionResponse)
async def predict(
    file: UploadFile = File(..., description="Image file to classify"),
    use_segmentation: bool = Query(True, description="Whether to use segmentation"),
    seg_method: str = Query("u2netp", description="Segmentation method: hsv, grabcut, adaptive, u2netp, none"),
    model_type: str = Query("mlpv2", description="Model type to use: mlp, mlpv2")
):
    """
    Predict vegetable class from image
    
    Args:
        file: Image file (JPG, PNG, etc.)
        use_segmentation: Whether to apply segmentation
        seg_method: Segmentation method (hsv, grabcut, adaptive, u2netp, none)
        model_type: Type of model to use for prediction (mlp or mlpv2)
    
    Returns:
        Prediction results with confidence scores
    """
    # Check if any models are loaded
    if len(model_manager.get_loaded_models()) == 0:
        raise HTTPException(status_code=503, detail="No models loaded")
    
    # Validate model type
    if not model_manager.is_loaded(model_type):
        available = model_manager.get_loaded_models()
        raise HTTPException(
            status_code=400,
            detail=f"Model type '{model_type}' not available. Available models: {available}"
        )
    
    # Validate file type
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")
    
    # Validate segmentation method
    if seg_method not in VALID_SEGMENTATION_METHODS:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid segmentation method. Must be one of: {VALID_SEGMENTATION_METHODS}"
        )
    
    try:
        # Read image
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes))
        
        # Get model
        model = model_manager.get_model(model_type)
        
        # Perform prediction
        predicted_class, confidence_value, all_confidences = predict_image(
            model=model,
            image=image,
            use_segmentation=use_segmentation,
            seg_method=seg_method
        )
        
        return PredictionResponse(
            predicted_class=predicted_class,
            confidence=confidence_value,
            all_confidences=all_confidences,
            device=str(DEVICE),
            model_type=model_type,
            segmentation_used=use_segmentation,
            segmentation_method=seg_method if use_segmentation else None
        )
    
    except Exception as e:
        print(f"Error during prediction: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Error during prediction: {str(e)}")


@router.post("/batch-predict", response_model=BatchPredictionResponse)
async def batch_predict(
    files: List[UploadFile] = File(..., description="Multiple image files to classify"),
    use_segmentation: bool = Query(True, description="Whether to use segmentation"),
    seg_method: str = Query("hsv", description="Segmentation method: hsv, grabcut, adaptive, u2netp, none"),
    model_type: str = Query("mlp", description="Model type to use: mlp, mlpv2")
):
    """
    Predict multiple images at once
    
    Args:
        files: List of image files
        use_segmentation: Whether to apply segmentation
        seg_method: Segmentation method
        model_type: Type of model to use for prediction (mlp or mlpv2)
    
    Returns:
        List of prediction results
    """
    # Check if any models are loaded
    if len(model_manager.get_loaded_models()) == 0:
        raise HTTPException(status_code=503, detail="No models loaded")
    
    # Validate model type
    if not model_manager.is_loaded(model_type):
        available = model_manager.get_loaded_models()
        raise HTTPException(
            status_code=400,
            detail=f"Model type '{model_type}' not available. Available models: {available}"
        )
    
    # Get model
    model = model_manager.get_model(model_type)
    
    results = []
    
    for file in files:
        try:
            # Validate file type
            if not file.content_type.startswith("image/"):
                results.append(BatchPredictionResult(
                    filename=file.filename,
                    error="File must be an image"
                ))
                continue
            
            # Read and process image
            image_bytes = await file.read()
            image = Image.open(io.BytesIO(image_bytes))
            
            # Perform prediction
            predicted_class, confidence_value, all_confidences = predict_image(
                model=model,
                image=image,
                use_segmentation=use_segmentation,
                seg_method=seg_method
            )
            
            results.append(BatchPredictionResult(
                filename=file.filename,
                predicted_class=predicted_class,
                confidence=confidence_value,
                all_confidences=all_confidences,
                model_type=model_type
            ))
        
        except Exception as e:
            results.append(BatchPredictionResult(
                filename=file.filename,
                error=str(e)
            ))
    
    return BatchPredictionResponse(results=results)
