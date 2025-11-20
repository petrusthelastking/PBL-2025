/// Mock responses for PCVK service tests
class PcvkMockResponses {
  static final Map<String, dynamic> healthSuccess = {
    "status": "healthy",
    "device": "cpu",
    "num_classes": 4,
    "class_names": ["Sayur Akar", "Sayur Buah", "Sayur Daun", "Sayur Polong"],
    "available_models": ["mlp", "mlpv2", "mlpv2_auto-clahe"],
  };

  static final Map<String, dynamic> classesSuccess = {
    "classes": ["Sayur Akar", "Sayur Buah", "Sayur Daun", "Sayur Polong"],
  };

  static final List<dynamic> classesEmpty = [];

  static final Map<String, dynamic> modelsSuccess = {
    "available_models": ["mlp", "mlpv2", "mlpv2_auto-clahe"],
    "total_models": 4,
    "models": {
      "mlp": {
        "loaded": true,
        "architecture": "Simple MLP",
        "hidden_layers": "512 -> 256",
        "dropout": 0.5,
        "features": ["Simple Linear Layers"],
      },
      "mlpv2": {
        "loaded": true,
        "architecture": "MLP with Residual Connections",
        "hidden_layers": "256 -> 512 -> 256 -> 128",
        "dropout": "Progressive (0.3 -> 0.15 -> 0.075 -> 0.0375)",
        "features": ["Residual Blocks", "BatchNorm", "Kaiming Init"],
      },
      "mlpv2_auto-clahe": {
        "loaded": true,
        "architecture": "MLP with Residual Connections + Auto-CLAHE",
        "hidden_layers": "256 -> 512 -> 256 -> 128",
        "dropout": "Progressive (0.3 -> 0.15 -> 0.075 -> 0.0375)",
        "features": [
          "Residual Blocks",
          "BatchNorm",
          "Kaiming Init",
          "Auto Brightness/Contrast",
          "CLAHE Enhancement",
        ],
      },
      "u2netp": {
        "loaded": false,
        "architecture": null,
        "hidden_layers": null,
        "dropout": null,
        "features": null,
      },
    },
  };

  static final Map<String, dynamic> modelsNullFields = {
    'available_models': ['u2netp'],
    'total_models': 1,
    'models': {
      'u2netp': {
        'loaded': false,
        'architecture': null,
        'hidden_layers': null,
        'dropout': 0.0,
        'features': null,
      },
    },
  };

  static final Map<String, dynamic> predictSuccess = {
    "filename": "test_image.jpg",
    "predicted_class": "Sayur Akar",
    "confidence": 0.9371846914291382,
    "all_confidences": {
      "Sayur Akar": 0.9371846914291382,
      "Sayur Buah": 0.031748250126838684,
      "Sayur Daun": 0.024870024994015694,
      "Sayur Polong": 0.006197091657668352,
    },
    "device": "cpu",
    "model_type": "mlpv2_auto-clahe",
    "segmentation_used": true,
    "segmentation_method": "u2netp",
    "apply_brightness_contrast": true,
  };

  static final Map<String, dynamic> batchPredictSuccess = {
    "results": [
      {
        "filename": "lobak-putih-3.jpg",
        "predicted_class": "Sayur Akar",
        "confidence": 0.9439828395843506,
        "all_confidences": {
          "Sayur Akar": 0.9439828395843506,
          "Sayur Buah": 0.004500778391957283,
          "Sayur Daun": 0.04260743781924248,
          "Sayur Polong": 0.008908855728805065,
        },
        "device": "cpu",
        "model_type": "mlpv2_auto-clahe",
        "segmentation_used": true,
        "segmentation_method": "u2netp",
        "apply_brightness_contrast": true,
        "error": null,
      },
      {
        "filename": "12313clipboard.png",
        "predicted_class": "Sayur Buah",
        "confidence": 0.7061872482299805,
        "all_confidences": {
          "Sayur Akar": 0.028465289622545242,
          "Sayur Buah": 0.7061872482299805,
          "Sayur Daun": 0.1888069361448288,
          "Sayur Polong": 0.07654041051864624,
        },
        "device": "cpu",
        "model_type": "mlpv2_auto-clahe",
        "segmentation_used": true,
        "segmentation_method": "u2netp",
        "apply_brightness_contrast": true,
        "error": null,
      },
    ],
  };

  static final Map<String, dynamic> batchPredictError = {
    "results": [
      {
        "filename": "lobak-putih-3.jpg",
        "predicted_class": "Sayur Akar",
        "confidence": 0.9439828395843506,
        "all_confidences": {
          "Sayur Akar": 0.9439828395843506,
          "Sayur Buah": 0.004500778391957283,
          "Sayur Daun": 0.04260743781924248,
          "Sayur Polong": 0.008908855728805065,
        },
        "device": "cpu",
        "model_type": "mlpv2_auto-clahe",
        "segmentation_used": true,
        "segmentation_method": "u2netp",
        "apply_brightness_contrast": true,
        "error": null,
      },
      {"filename": "12313clipboard.png", "error": "Fail"},
    ],
  };
}
