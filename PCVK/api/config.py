"""
Configuration settings for the FastAPI application
"""

import os
import torch

# Model configuration
MODEL_PATHS = {
    "mlp": os.path.join(
        os.path.dirname(os.path.dirname(__file__)), "api", "models", "mlp.pth"
    ),
    "mlpv2": os.path.join(
        os.path.dirname(os.path.dirname(__file__)), "api", "models", "mlpv2.pth"
    ),
    "mlpv2_auto-clahe": os.path.join(
        os.path.dirname(os.path.dirname(__file__)),
        "api",
        "models",
        "mlpv2_auto-clahe.pth",
    ),
    "u2netp": os.path.join(
        os.path.dirname(os.path.dirname(__file__)),
        "api",
        "models",
        "u2netp.onnx",
    ),
}

CLASS_NAMES = ["Sayur Akar", "Sayur Buah", "Sayur Daun", "Sayur Polong"]

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# API configuration
API_TITLE = "Vegetable Classification API"
API_DESCRIPTION = "API untuk klasifikasi sayuran menggunakan MLP dengan ekstraksi fitur"
API_VERSION = "1.0.0"

# Server configuration
SERVER_HOST = "0.0.0.0"
SERVER_PORT = 8000

# CORS configuration
CORS_ORIGINS = ["*"]  # Adjust this in production
CORS_CREDENTIALS = True
CORS_METHODS = ["*"]
CORS_HEADERS = ["*"]

# Validation
VALID_SEGMENTATION_METHODS = ["hsv", "grabcut", "adaptive", "u2netp", "none"]
VALID_MODEL_TYPES = list(MODEL_PATHS.keys())

# Feature extraction
NUM_FEATURES = 44  # Total features extracted
