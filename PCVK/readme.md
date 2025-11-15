# Setup

```python
pip install -r requirements.txt
```

#### Tested: Python 3.12

# Dataset

Kaggle: [misrakahmed/vegetable-image-dataset](https://www.kaggle.com/datasets/misrakahmed/vegetable-image-dataset)

#### Segment dataset

```python
dataset_u2netp.py
```

#### Del 'just black images'

```python
remove_blackimages.py
```

## Models

### `lib/model.py` - ModelMLP

Simple MLP classifier for vegetable classification.

**Architecture:**

- Input: 44 features (fused/extracted features)
- Hidden layers: 44 → 512 → 256 → num_classes
- BatchNorm + ReLU + Dropout after each layer

**Usage:**

```python
from lib.model import ModelMLP

model = ModelMLP(num_classes=4, dropout_rate=0.5)
logits = model(features)  # features shape: (batch, 44)
```

### `lib/model_v2.py` - Advanced Models

Improved architectures with better flexibility and performance.

#### ModelMLPV2

Configurable MLP with residual connections and better initialization.

**Features:**

- Input batch normalization for stability
- Configurable hidden dimensions (default: [256, 512, 256, 128])
- Optional residual blocks when layer dims match
- Decreasing dropout per layer (0.3 → 0.15 → 0.075...)
- Kaiming weight initialization

**Usage:**

```python
from lib.model_v2 import ModelMLPV2

model = ModelMLPV2(
    num_features=44,
    num_classes=4,
    hidden_dims=[256, 512, 256, 128],
    dropout_rate=0.3,
    use_residual=True
)
logits = model(features)
```

#### AttentionMLP

Experimental attention-based classifier.

**Features:**

- Self-attention mechanism for feature weighting
- Lighter architecture (single hidden layer)
- Good for smaller datasets

**Usage:**

```python
from lib.model_v2 import AttentionMLP

model = AttentionMLP(
    num_features=44,
    num_classes=4,
    hidden_dim=256,
    dropout_rate=0.3
)
logits = model(features)
```

## Applications

### Gradio

```python
app_gradio.py
```

### API

```python
app.py
```
