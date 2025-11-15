# @markdown ### Model.py - MLP Model
import torch.nn as nn


class ModelMLPV2(nn.Module):
    def __init__(
        self,
        num_features=44,
        num_classes=4,
        hidden_dims=[256, 512, 256, 128],
        dropout_rate=0.3,
        use_residual=True,
    ):
        super().__init__()
        self.use_residual = use_residual

        # Input normalization
        self.input_bn = nn.BatchNorm1d(num_features)

        # Build dynamic layer structure
        layers = []
        prev_dim = num_features

        for i, hidden_dim in enumerate(hidden_dims):
            # Main path
            block = nn.Sequential(
                nn.Linear(prev_dim, hidden_dim),
                nn.BatchNorm1d(hidden_dim),
                nn.ReLU(inplace=True),
                nn.Dropout(dropout_rate * (0.5**i)),  # Decreasing dropout
            )
            layers.append(block)

            # Residual connection if dimensions match
            if use_residual and prev_dim == hidden_dim:
                layers.append(ResidualBlock(hidden_dim, dropout_rate * (0.5**i)))

            prev_dim = hidden_dim

        self.features = nn.Sequential(*layers)

        # Classification head with label smoothing support
        self.classifier = nn.Linear(prev_dim, num_classes)

        # Initialize weights
        self._initialize_weights()

    def _initialize_weights(self):
        for m in self.modules():
            if isinstance(m, nn.Linear):
                nn.init.kaiming_normal_(m.weight, mode="fan_out", nonlinearity="relu")
                if m.bias is not None:
                    nn.init.constant_(m.bias, 0)
            elif isinstance(m, nn.BatchNorm1d):
                nn.init.constant_(m.weight, 1)
                nn.init.constant_(m.bias, 0)

    def forward(self, x):
        x = self.input_bn(x)
        x = self.features(x)
        x = self.classifier(x)
        return x


class ResidualBlock(nn.Module):
    """Residual block for skip connections"""

    def __init__(self, dim, dropout_rate):
        super().__init__()
        self.block = nn.Sequential(
            nn.Linear(dim, dim),
            nn.BatchNorm1d(dim),
            nn.ReLU(inplace=True),
            nn.Dropout(dropout_rate),
            nn.Linear(dim, dim),
            nn.BatchNorm1d(dim),
        )
        self.relu = nn.ReLU(inplace=True)

    def forward(self, x):
        residual = x
        out = self.block(x)
        out += residual  # Skip connection
        out = self.relu(out)
        return out


# Alternative: Attention-based MLP
class AttentionMLP(nn.Module):
    def __init__(
        self,
        num_features=44,
        num_classes=4,
        hidden_dim=256,
        dropout_rate=0.3,
    ):
        super().__init__()

        self.input_bn = nn.BatchNorm1d(num_features)

        # Feature
        self.encoder = nn.Sequential(
            nn.Linear(num_features, hidden_dim),
            nn.BatchNorm1d(hidden_dim),
            nn.ReLU(inplace=True),
            nn.Dropout(dropout_rate),
        )

        # Self-attention mechanism
        self.attention = nn.Sequential(
            nn.Linear(hidden_dim, hidden_dim // 4),
            nn.Tanh(),
            nn.Linear(hidden_dim // 4, 1),
            nn.Softmax(dim=1),
        )

        # Classification layers
        self.classifier = nn.Sequential(
            nn.Linear(hidden_dim, hidden_dim // 2),
            nn.BatchNorm1d(hidden_dim // 2),
            nn.ReLU(inplace=True),
            nn.Dropout(dropout_rate * 0.5),
            nn.Linear(hidden_dim // 2, num_classes),
        )

        self._initialize_weights()

    def _initialize_weights(self):
        for m in self.modules():
            if isinstance(m, nn.Linear):
                nn.init.kaiming_normal_(m.weight, mode="fan_out", nonlinearity="relu")
                if m.bias is not None:
                    nn.init.constant_(m.bias, 0)

    def forward(self, x):
        x = self.input_bn(x)
        features = self.encoder(x)

        # Apply attention (if batch processing multiple features)
        attn_weights = self.attention(features)
        weighted_features = features * attn_weights

        out = self.classifier(weighted_features)
        return out
