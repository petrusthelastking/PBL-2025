# @markdown ### Preprocess.py - Preprocess, Feature Extraction untuk model

from torch.utils.data import Dataset
import torchvision.transforms as T
import cv2
import torch
from extract_features import extract_all_features
from segment import auto_segment
from concurrent.futures import ThreadPoolExecutor
from multiprocessing import cpu_count


class FeatureDataset(Dataset):
    def __init__(
        self,
        img_paths,
        labels,
        img_size,
        use_segmentation=False,
        seg_method="hsv",
        cache_features=True,
        num_workers=None,
    ):
        self.img_paths = img_paths
        self.labels = labels
        self.img_size = img_size
        self.use_segmentation = use_segmentation
        self.seg_method = seg_method
        self.cache_features = cache_features
        self.feature_cache = {}

        # Auto-detect number of workers if not specified
        if num_workers is None:
            num_workers = max(1, cpu_count() - 1)  # Leave 1 CPU free
        self.num_workers = num_workers

        # Image transformation
        self.transform = T.Compose(
            [
                T.ToTensor(),
                T.Resize((img_size, img_size), antialias=True),
                T.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
            ]
        )

        # Preprocess all features if caching is enabled (done once at init)
        if self.cache_features:
            seg_status = (
                f"with {seg_method} segmentation"
                if use_segmentation
                else "without segmentation"
            )
            print(
                f"Preprocessing {len(img_paths)} images ({seg_status}, ALL 44 features)"
            )
            print(f"Using {self.num_workers} parallel workers")

            self._parallel_preprocess()
            print(f"✅ All features cached!")

    def _parallel_preprocess(self):
        """Preprocess all images in parallel using threading (Windows-compatible)"""
        from tqdm import tqdm
        from concurrent.futures import as_completed

        def process_image(idx):
            """Worker function for thread processing"""
            try:
                # Read image
                img = cv2.imread(self.img_paths[idx])

                # Apply segmentation if enabled
                if self.use_segmentation and self.seg_method != "none":
                    img_processed = auto_segment(img.copy(), method=self.seg_method)
                else:
                    img_processed = img

                combined_feat = extract_all_features(
                    img_processed,
                    use_segmentation=False,
                    seg_method="none",
                )

                img_rgb = cv2.cvtColor(img_processed, cv2.COLOR_BGR2RGB)

                return idx, (img_rgb, combined_feat)
            except Exception as e:
                print(f"Error processing image {idx}: {e}")
                return idx, None

        # Use ThreadPoolExecutor for parallel execution (works well on Windows)
        with ThreadPoolExecutor(max_workers=self.num_workers) as executor:
            # Submit all tasks
            futures = {executor.submit(process_image, idx): idx for idx in range(len(self.img_paths))}
            
            # Collect results as they complete (prevents slowdown at the end)
            for future in tqdm(as_completed(futures), total=len(futures), desc="Caching features"):
                idx, result = future.result()
                if result is not None:
                    self.feature_cache[idx] = result

    def _preprocess_and_cache(self, idx):
        """Preprocess and cache features to avoid repeated CPU work"""
        if idx in self.feature_cache:
            return self.feature_cache[idx]

        # Read image
        img = cv2.imread(self.img_paths[idx])

        # Apply segmentation if enabled
        if self.use_segmentation and self.seg_method != "none":
            img_processed = auto_segment(img.copy(), method=self.seg_method)
        else:
            img_processed = img

        combined_feat = extract_all_features(
            img_processed,
            use_segmentation=False,
            seg_method="none",
        )

        img_rgb = cv2.cvtColor(img_processed, cv2.COLOR_BGR2RGB)

        # Cache the preprocessed data
        self.feature_cache[idx] = (img_rgb, combined_feat)

        return img_rgb, combined_feat

    def __len__(self):
        return len(self.img_paths)

    def __getitem__(self, idx):
        if self.cache_features:
            if idx not in self.feature_cache:
                img_rgb, combined_feat = self._preprocess_and_cache(idx)
            else:
                img_rgb, combined_feat = self.feature_cache[idx]
        else:
            img = cv2.imread(self.img_paths[idx])

            combined_feat = extract_all_features(
                img, use_segmentation=self.use_segmentation, seg_method=self.seg_method
            )

            img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

        img_tensor = self.transform(img_rgb)

        # Convert to tensors
        features_tensor = torch.tensor(combined_feat, dtype=torch.float32)
        label_tensor = torch.tensor(self.labels[idx], dtype=torch.long)

        return img_tensor, features_tensor, label_tensor
