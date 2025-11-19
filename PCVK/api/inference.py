"""
Inference logic for vegetable classification
"""

import cv2
import numpy as np
import torch
from PIL import Image
import sys
import os
from typing import Tuple, Dict

# Add lib directory to path
lib_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'lib')
if lib_path not in sys.path:
    sys.path.append(lib_path)

from lib.extract_features import extract_all_features
from lib.segment import auto_segment
from api.config import CLASS_NAMES, DEVICE


def preprocess_image(image: Image.Image, target_size: Tuple[int, int] = (224, 224)) -> np.ndarray:
    """
    Preprocess image for inference
    
    Args:
        image: PIL Image
        target_size: Target size for resizing
    
    Returns:
        Preprocessed image as BGR numpy array
    """
    # Convert PIL Image to numpy array (RGB)
    image_np = np.array(image.convert('RGB'))
    
    # Convert RGB to BGR for OpenCV
    image_bgr = cv2.cvtColor(image_np, cv2.COLOR_RGB2BGR)
    
    # Resize to target size
    image_bgr = cv2.resize(image_bgr, target_size)
    
    return image_bgr


def apply_segmentation(image: np.ndarray, method: str = "hsv", apply_brightness_contrast: bool = True) -> np.ndarray:
    """
    Apply segmentation to image
    
    Args:
        image: Input image (BGR)
        method: Segmentation method
        apply_brightness_contrast: Whether to apply brightness and contrast enhancement
    
    Returns:
        Segmented image
    """
    if method == "none":
        return image.copy()
    
    return auto_segment(image.copy(), method=method, applyBrightContClahe=apply_brightness_contrast)


def extract_features_from_image(image: np.ndarray) -> np.ndarray:
    """
    Extract features from image
    
    Args:
        image: Input image (BGR)
    
    Returns:
        Feature vector as numpy array
    """
    features = extract_all_features(
        image,
        use_segmentation=False,  # Already segmented if needed
        seg_method="none"
    )
    return features


def predict_from_features(
    model: torch.nn.Module,
    features: np.ndarray
) -> Tuple[str, float, Dict[str, float]]:
    """
    Perform prediction from features
    
    Args:
        model: PyTorch model
        features: Feature vector
    
    Returns:
        Tuple of (predicted_class, confidence, all_confidences)
    """
    # Convert to tensor
    features_tensor = torch.tensor(features, dtype=torch.float32).unsqueeze(0)
    features_tensor = features_tensor.to(DEVICE)
    
    # Predict
    with torch.no_grad():
        outputs = model(features_tensor)
        probabilities = torch.softmax(outputs, dim=1)
        confidence, predicted = torch.max(probabilities, 1)
        
        # Get all class probabilities
        probs = probabilities[0].cpu().numpy()
    
    # Prepare results
    predicted_class = CLASS_NAMES[predicted.item()]
    confidence_value = float(confidence.item())
    
    # Create confidence dictionary for all classes
    all_confidences = {CLASS_NAMES[i]: float(probs[i]) for i in range(len(CLASS_NAMES))}
    
    return predicted_class, confidence_value, all_confidences


def predict_image(
    model: torch.nn.Module,
    image: Image.Image,
    use_segmentation: bool = True,
    seg_method: str = "hsv",
    apply_brightness_contrast: bool = True
) -> Tuple[str, float, Dict[str, float]]:
    """
    Complete prediction pipeline
    
    Args:
        model: PyTorch model
        image: PIL Image
        use_segmentation: Whether to apply segmentation
        seg_method: Segmentation method
        apply_brightness_contrast: Whether to apply brightness and contrast enhancement
    
    Returns:
        Tuple of (predicted_class, confidence, all_confidences)
    """
    # Preprocess image
    image_bgr = preprocess_image(image)
    
    # Apply segmentation if enabled
    if use_segmentation and seg_method != "none":
        segmented_img = apply_segmentation(image_bgr, method=seg_method, apply_brightness_contrast=apply_brightness_contrast)
    else:
        segmented_img = image_bgr
    
    # Extract features
    features = extract_features_from_image(segmented_img)
    
    # Predict
    predicted_class, confidence, all_confidences = predict_from_features(model, features)
    
    return predicted_class, confidence, all_confidences
