import numpy as np
from skimage.feature import hog, local_binary_pattern
import cv2
from scipy.stats import entropy
from segment import auto_segment


def extract_hog_features(
    img, resize_shape=(128, 128), use_segmentation=False, seg_method="hsv"
):
    """
    Extract HOG (Histogram of Oriented Gradients) features

    Args:
        img: Input image (BGR)
        resize_shape: Target size for HOG computation
        use_segmentation: Whether to apply segmentation before feature extraction
        seg_method: Segmentation method ('grabcut', 'adaptive', 'hsv', 'none')
    """
    # Apply segmentation if enabled
    if use_segmentation and seg_method != "none":
        img = auto_segment(img, method=seg_method)

    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img_resized = cv2.resize(img_gray, resize_shape)

    # HOG parameters
    hog_features = hog(
        img_resized,
        orientations=9,  # Number of orientation bins
        pixels_per_cell=(8, 8),  # Cell size
        cells_per_block=(2, 2),  # Block size
        block_norm="L2-Hys",  # Block normalization method
        visualize=False,
        feature_vector=True,
    )

    # Reduce dimensionality by taking statistics
    # Original HOG vector is too large, we summarize it
    hog_mean = np.mean(hog_features)
    hog_std = np.std(hog_features)
    hog_max = np.max(hog_features)
    hog_min = np.min(hog_features)
    hog_median = np.median(hog_features)

    return np.array([hog_mean, hog_std, hog_max, hog_min, hog_median], dtype=np.float32)


def extract_lbp_features(
    img,
    radius=1,
    n_points=8,
    resize_shape=(128, 128),
    use_segmentation=False,
    seg_method="hsv",
):
    """
    Extract LBP (Local Binary Pattern) features

    Args:
        img: Input image (BGR)
        radius: Radius of circle (default=1)
        n_points: Number of circularly symmetric neighbor points (default=8)
        resize_shape: Target size for LBP computation
        use_segmentation: Whether to apply segmentation before feature extraction
        seg_method: Segmentation method ('grabcut', 'adaptive', 'hsv', 'none')
    """
    # Apply segmentation if enabled
    if use_segmentation and seg_method != "none":
        img = auto_segment(img, method=seg_method)

    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img_resized = cv2.resize(img_gray, resize_shape)

    # Compute LBP
    lbp = local_binary_pattern(img_resized, n_points, radius, method="uniform")

    # Extract statistical features from LBP
    lbp_mean = np.mean(lbp)
    lbp_std = np.std(lbp)
    lbp_max = np.max(lbp)
    lbp_min = np.min(lbp)
    lbp_median = np.median(lbp)

    # Calculate entropy (measure of randomness/complexity)
    hist, _ = np.histogram(
        lbp.ravel(), bins=n_points + 2, range=(0, n_points + 2), density=True
    )
    lbp_entropy = entropy(hist + 1e-7)  # Add small value to avoid log(0)

    return np.array(
        [lbp_mean, lbp_std, lbp_max, lbp_min, lbp_median, lbp_entropy], dtype=np.float32
    )


def extract_sift_features(
    img, n_keypoints=100, use_segmentation=False, seg_method="hsv"
):
    """
    Extract SIFT (Scale-Invariant Feature Transform) features

    Args:
        img: Input image (BGR)
        n_keypoints: Number of top keypoints to consider
        use_segmentation: Whether to apply segmentation before feature extraction
        seg_method: Segmentation method ('grabcut', 'adaptive', 'hsv', 'none')

    Returns:
        Statistical features from SIFT descriptors (8 features)
    """
    # Apply segmentation if enabled
    if use_segmentation and seg_method != "none":
        img = auto_segment(img, method=seg_method)

    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Initialize SIFT detector
    sift = cv2.SIFT_create()

    # Detect keypoints and compute descriptors
    keypoints, descriptors = sift.detectAndCompute(img_gray, None)

    if descriptors is None or len(descriptors) == 0:
        # Return zeros if no keypoints found
        return np.zeros(8, dtype=np.float32)

    # Sort keypoints by response strength and take top N
    if len(keypoints) > n_keypoints:
        # Sort by response (strength)
        sorted_indices = np.argsort([kp.response for kp in keypoints])[::-1]
        descriptors = descriptors[sorted_indices[:n_keypoints]]

    # Extract statistical features from SIFT descriptors
    sift_mean = np.mean(descriptors)
    sift_std = np.std(descriptors)
    sift_max = np.max(descriptors)
    sift_min = np.min(descriptors)
    sift_median = np.median(descriptors)
    sift_q25 = np.percentile(descriptors, 25)
    sift_q75 = np.percentile(descriptors, 75)
    sift_num_keypoints = len(keypoints)

    return np.array(
        [
            sift_mean,
            sift_std,
            sift_max,
            sift_min,
            sift_median,
            sift_q25,
            sift_q75,
            sift_num_keypoints,
        ],
        dtype=np.float32,
    )


def extract_color_histogram_features(img, use_segmentation=False, seg_method="hsv"):
    """
    Extract Color Histogram features from RGB channels

    Args:
        img: Input image (BGR)
        use_segmentation: Whether to apply segmentation before feature extraction
        seg_method: Segmentation method ('grabcut', 'adaptive', 'hsv', 'none')

    Returns:
        Color statistics features (12 features)
    """
    # Apply segmentation if enabled
    if use_segmentation and seg_method != "none":
        img = auto_segment(img, method=seg_method)

    # Convert BGR to RGB
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

    # Create mask to ignore black pixels (background from segmentation)
    mask = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) > 10

    # Extract color statistics for each channel
    features = []

    for channel_idx, channel_name in enumerate(["R", "G", "B"]):
        channel = img_rgb[:, :, channel_idx]

        # Get valid pixels (non-background)
        valid_pixels = channel[mask]

        if len(valid_pixels) > 0:
            # Statistical features
            mean_val = np.mean(valid_pixels)
            std_val = np.std(valid_pixels)
            max_val = np.max(valid_pixels)
            min_val = np.min(valid_pixels)
        else:
            mean_val = std_val = max_val = min_val = 0

        features.extend([mean_val, std_val, max_val, min_val])

    return np.array(features, dtype=np.float32)


def extract_haralick_features(img, use_segmentation=False, seg_method="hsv"):
    """
    Extract Haralick texture features

    Args:
        img: Input image (BGR)
        use_segmentation: Whether to apply segmentation before feature extraction
        seg_method: Segmentation method ('grabcut', 'adaptive', 'hsv', 'none')

    Returns:
        Haralick texture features (13 features)
    """
    # Fallback: Use enhanced texture features if mahotas not available

    # Apply segmentation if enabled
    if use_segmentation and seg_method != "none":
        img = auto_segment(img, method=seg_method)

    img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Compute texture features using multiple angles and distances
    from skimage.feature import graycomatrix, graycoprops

    distances = [1, 2]
    angles = [0, np.pi / 4, np.pi / 2, 3 * np.pi / 4]

    glcm = graycomatrix(
        img_gray,
        distances=distances,
        angles=angles,
        levels=256,
        symmetric=True,
        normed=True,
    )

    # Extract properties
    contrast = graycoprops(glcm, "contrast").mean()
    dissimilarity = graycoprops(glcm, "dissimilarity").mean()
    homogeneity = graycoprops(glcm, "homogeneity").mean()
    energy = graycoprops(glcm, "energy").mean()
    correlation = graycoprops(glcm, "correlation").mean()
    asm = graycoprops(glcm, "ASM").mean()

    # Additional texture measures
    contrast_std = graycoprops(glcm, "contrast").std()
    dissimilarity_std = graycoprops(glcm, "dissimilarity").std()
    homogeneity_std = graycoprops(glcm, "homogeneity").std()
    energy_std = graycoprops(glcm, "energy").std()
    correlation_std = graycoprops(glcm, "correlation").std()
    asm_std = graycoprops(glcm, "ASM").std()

    # Edge density
    edges = cv2.Canny(img_gray, 50, 150)
    edge_density = np.sum(edges > 0) / edges.size

    return np.array(
        [
            contrast,
            dissimilarity,
            homogeneity,
            energy,
            correlation,
            asm,
            contrast_std,
            dissimilarity_std,
            homogeneity_std,
            energy_std,
            correlation_std,
            asm_std,
            edge_density,
        ],
        dtype=np.float32,
    )


def extract_all_features(img, use_segmentation=False, seg_method="hsv"):
    hog_feat = extract_hog_features(
        img, use_segmentation=use_segmentation, seg_method=seg_method
    )
    lbp_feat = extract_lbp_features(
        img, use_segmentation=use_segmentation, seg_method=seg_method
    )
    sift_feat = extract_sift_features(
        img, use_segmentation=use_segmentation, seg_method=seg_method
    )
    color_feat = extract_color_histogram_features(
        img, use_segmentation=use_segmentation, seg_method=seg_method
    )
    haralick_feat = extract_haralick_features(
        img, use_segmentation=use_segmentation, seg_method=seg_method
    )

    # Concatenate all features: 5 + 6 + 8 + 12 + 13 = 44 features
    combined = np.concatenate(
        [
            hog_feat,  # 5 features
            lbp_feat,  # 6 features
            sift_feat,  # 8 features
            color_feat,  # 12 features
            haralick_feat,  # 13 features
        ]
    )

    return combined
