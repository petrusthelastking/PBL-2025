"""
Script untuk menerapkan Histogram Equalization pada semua gambar dalam folder r2_prepared_70
"""

import cv2
import os
import numpy as np
from pathlib import Path
from tqdm import tqdm

import cv2
import numpy as np
from typing import Tuple, Optional


def apply_clahe(img, clip_limit=2.0, tile_grid_size=(8, 8)):
    """
    Apply CLAHE (Contrast Limited Adaptive Histogram Equalization)
    State-of-the-art adaptive contrast enhancement method

    Args:
        img: Input image (BGR)
        clip_limit: Threshold for contrast limiting (higher = more contrast)
        tile_grid_size: Size of grid for histogram equalization

    Returns:
        Enhanced image with improved contrast
    """
    # Convert to LAB color space for better color preservation
    lab = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
    l, a, b = cv2.split(lab)

    # Apply CLAHE to L-channel only
    clahe = cv2.createCLAHE(clipLimit=clip_limit, tileGridSize=tile_grid_size)
    cl = clahe.apply(l)

    # Merge channels and convert back to BGR
    enhanced_lab = cv2.merge((cl, a, b))
    enhanced = cv2.cvtColor(enhanced_lab, cv2.COLOR_LAB2BGR)

    return enhanced


def apply_gamma_correction(img, gamma=1.2):
    """
    Apply gamma correction for brightness adjustment
    Gamma < 1: Brighten image
    Gamma > 1: Darken image
    Gamma = 1: No change

    Args:
        img: Input image (BGR)
        gamma: Gamma value for correction

    Returns:
        Gamma corrected image
    """
    # Build lookup table for gamma correction
    inv_gamma = 1.0 / gamma
    table = np.array(
        [((i / 255.0) ** inv_gamma) * 255 for i in np.arange(0, 256)]
    ).astype("uint8")

    # Apply gamma correction using LUT
    return cv2.LUT(img, table)


def apply_histogram_stretching(img, percentile_low=2, percentile_high=98):
    """
    Apply histogram stretching for dynamic range enhancement
    Also known as contrast stretching or normalization

    Args:
        img: Input image (BGR)
        percentile_low: Lower percentile for clipping (default 2%)
        percentile_high: Upper percentile for clipping (default 98%)

    Returns:
        Contrast stretched image
    """
    # Convert to float for processing
    img_float = img.astype(np.float32)

    # Calculate percentiles for each channel
    enhanced = np.zeros_like(img_float)
    for i in range(3):  # Process each BGR channel
        channel = img_float[:, :, i]
        # Calculate percentile values
        p_low = np.percentile(channel, percentile_low)
        p_high = np.percentile(channel, percentile_high)

        # Stretch histogram
        if p_high > p_low:  # Avoid division by zero
            channel_stretched = (channel - p_low) * (255.0 / (p_high - p_low))
            channel_stretched = np.clip(channel_stretched, 0, 255)
            enhanced[:, :, i] = channel_stretched
        else:
            enhanced[:, :, i] = channel

    return enhanced.astype(np.uint8)


def apply_agcwd(img, alpha=0.5):
    """
    Adaptive Gamma Correction with Weighting Distribution (AGCWD)
    State-of-the-art automatic brightness and contrast enhancement

    Reference: "Adaptive Gamma Correction Based on Cumulative Histogram"

    Args:
        img: Input image (BGR)
        alpha: Weight parameter (0-1), controls enhancement strength

    Returns:
        Enhanced image using AGCWD
    """
    # Convert to grayscale for intensity analysis
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Calculate histogram and CDF
    hist, _ = np.histogram(gray.flatten(), 256, [0, 256])
    hist = hist.astype(np.float32)

    # Normalize histogram
    hist_norm = hist / hist.sum()

    # Calculate PDF max and min
    pdf_max = hist_norm.max()
    pdf_min = hist_norm[hist_norm > 0].min() if np.any(hist_norm > 0) else 0

    # Calculate weighted distribution
    pdf_w = pdf_max * ((hist_norm - pdf_min) / (pdf_max - pdf_min + 1e-7)) ** alpha

    # Calculate CDF of weighted distribution
    cdf_w = pdf_w.cumsum()
    cdf_w = cdf_w / cdf_w[-1]  # Normalize

    # Calculate adaptive gamma
    # Gamma is inversely proportional to cumulative intensity
    cdf_i = hist_norm.cumsum()

    # Avoid division by zero
    gamma_values = 1 - cdf_w
    gamma = np.mean(gamma_values[gray.flatten()])

    # Apply calculated gamma correction
    return apply_gamma_correction(img, max(0.5, min(2.5, gamma)))


def apply_automatic_brightness_contrast(img, clip_hist_percent=1):
    """
    Automatic brightness and contrast optimization

    Args:
        img: Input image (BGR)
        clip_hist_percent: Percentage of histogram to clip

    Returns:
        Optimized image
    """
    # Convert to YUV color space
    yuv = cv2.cvtColor(img, cv2.COLOR_BGR2YUV)

    # Calculate grayscale histogram
    gray = yuv[:, :, 0]
    hist = cv2.calcHist([gray], [0], None, [256], [0, 256])
    hist_size = len(hist)

    # Calculate cumulative distribution
    accumulator = []
    accumulator.append(float(hist[0]))
    for index in range(1, hist_size):
        accumulator.append(accumulator[index - 1] + float(hist[index]))

    # Locate points to clip
    maximum = accumulator[-1]
    clip_hist_percent *= maximum / 100.0
    clip_hist_percent /= 2.0

    # Locate left cut
    minimum_gray = 0
    while accumulator[minimum_gray] < clip_hist_percent:
        minimum_gray += 1

    # Locate right cut
    maximum_gray = hist_size - 1
    while accumulator[maximum_gray] >= (maximum - clip_hist_percent):
        maximum_gray -= 1

    # Calculate alpha and beta values
    alpha = 255 / (maximum_gray - minimum_gray)
    beta = -minimum_gray * alpha

    # Apply brightness and contrast
    yuv[:, :, 0] = cv2.convertScaleAbs(yuv[:, :, 0], alpha=alpha, beta=beta)

    # Convert back to BGR
    enhanced = cv2.cvtColor(yuv, cv2.COLOR_YUV2BGR)

    return enhanced


def enhance_after_segmentation(img, method="clahe", **kwargs):
    """
    Apply enhancement after segmentation

    Args:
        img: Segmented image (BGR)
        method: Enhancement method
            - 'clahe': CLAHE (best for contrast)
            - 'gamma': Gamma correction (best for brightness)
            - 'histogram': Histogram stretching (best for dynamic range)
            - 'agcwd': Adaptive gamma correction (automatic, state-of-the-art)
            - 'auto': Automatic brightness/contrast
            - 'combined': Apply multiple methods in sequence
            - 'none': No enhancement
        **kwargs: Method-specific parameters

    Returns:
        Enhanced image
    """
    if method == "clahe":
        clip_limit = kwargs.get("clip_limit", 2.0)
        tile_grid_size = kwargs.get("tile_grid_size", (8, 8))
        return apply_clahe(img, clip_limit, tile_grid_size)

    elif method == "gamma":
        gamma = kwargs.get("gamma", 1.2)
        return apply_gamma_correction(img, gamma)

    elif method == "histogram":
        percentile_low = kwargs.get("percentile_low", 2)
        percentile_high = kwargs.get("percentile_high", 98)
        return apply_histogram_stretching(img, percentile_low, percentile_high)

    elif method == "agcwd":
        alpha = kwargs.get("alpha", 0.5)
        return apply_agcwd(img, alpha)

    elif method == "auto":
        clip_hist_percent = kwargs.get("clip_hist_percent", 1)
        return apply_automatic_brightness_contrast(img, clip_hist_percent)

    elif method == "combined":
        # Apply multiple enhancements in optimal sequence
        # 1. Histogram stretching for dynamic range
        enhanced = apply_histogram_stretching(img)
        # 2. AGCWD for adaptive brightness
        enhanced = apply_agcwd(enhanced)
        # 3. CLAHE for final contrast boost
        enhanced = apply_clahe(enhanced, clip_limit=1.5)
        return enhanced

    else:  # 'none' or invalid
        return img


def apply_enhance(input_dir, output_dir):
    """
    Args:
        input_dir (str): Path ke direktori input
        output_dir (str): Path ke direktori output
    """
    input_path = Path(input_dir)
    output_path = Path(output_dir)

    if not input_path.exists():
        print(f"Error: Direktori input '{input_dir}' tidak ditemukan!")
        return

    # Ekstensi file gambar yang didukung
    image_extensions = {".jpg", ".jpeg", ".png", ".bmp", ".tiff", ".tif"}

    # Cari semua file gambar
    image_files = []
    for ext in image_extensions:
        image_files.extend(input_path.rglob(f"*{ext}"))
        # image_files.extend(input_path.rglob(f'*{ext.upper()}'))

    print(f"Ditemukan {len(image_files)} gambar")

    if len(image_files) == 0:
        print("Tidak ada gambar yang ditemukan!")
        return

    # Proses setiap gambar
    processed = 0
    errors = 0

    for img_file in tqdm(image_files, desc="Memproses gambar"):
        try:
            # Baca gambar
            img = cv2.imread(str(img_file))

            if img is None:
                print(f"\nWarning: Gagal membaca {img_file}")
                errors += 1
                continue

            # Terapkan Histogram Equalization
            # Konversi ke YUV
            # img_yuv = cv2.cvtColor(img, cv2.COLOR_BGR2YUV)

            # # Equalize histogram pada channel Y (luminance)
            # img_yuv[:, :, 0] = cv2.equalizeHist(img_yuv[:, :, 0])

            # Konversi kembali ke BGR
            result = apply_clahe(apply_automatic_brightness_contrast(img))

            # Tentukan path output dengan mempertahankan struktur direktori
            relative_path = img_file.relative_to(input_path)
            output_file = output_path / relative_path

            # Buat direktori output jika belum ada
            output_file.parent.mkdir(parents=True, exist_ok=True)

            # Simpan gambar hasil histogram equalization
            cv2.imwrite(str(output_file), result)
            processed += 1

        except Exception as e:
            print(f"\nError memproses {img_file}: {str(e)}")
            errors += 1

    print(f"\n{'='*60}")
    print(f"Selesai!")
    print(f"Berhasil diproses: {processed} gambar")
    print(f"Error: {errors} gambar")
    print(f"Output disimpan di: {output_dir}")
    print(f"{'='*60}")


def main():
    # Konfigurasi
    input_directory = r"ForPCVK\notebook\r2_prepared_70"
    output_directory = r"ForPCVK\notebook\dataset_prepared_train"

    print("=" * 60)
    print("Histogram Equalization Image Processor")
    print("=" * 60)
    print(f"Input directory : {input_directory}")
    print(f"Output directory: {output_directory}")
    print("=" * 60)
    print()
    apply_enhance(input_dir=input_directory, output_dir=output_directory)


if __name__ == "__main__":
    main()
