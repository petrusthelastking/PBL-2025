import torch.nn as nn


class ModelMLP(nn.Module):
    def __init__(
        self,
        num_classes=4,
        dropout_rate=0.5,
    ):
        super().__init__()

        fusion_input_size = 44

        self.fusion = nn.Sequential(
            nn.Linear(fusion_input_size, 512),
            nn.BatchNorm1d(512),
            nn.ReLU(inplace=True),
            nn.Dropout(dropout_rate),
            nn.Linear(512, 256),
            nn.BatchNorm1d(256),
            nn.ReLU(inplace=True),
            nn.Dropout(dropout_rate * 0.5),
            nn.Linear(256, num_classes),
        )

    def forward(self, features):
        return self.fusion(features)
