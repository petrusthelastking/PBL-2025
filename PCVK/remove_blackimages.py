"""
Script untuk mendeteksi dan membuang gambar yang kebanyakan hitam
(biasanya hasil segmentasi yang gagal)
"""

import os
import cv2
import numpy as np
from pathlib import Path
from tqdm import tqdm
import shutil


def is_mostly_black(image_path, black_threshold=10, black_percentage=0.8):
    """
    Check if image is mostly black
    
    Args:
        image_path: Path to image file
        black_threshold: Pixel value threshold to consider as black (0-255)
        black_percentage: Minimum percentage of black pixels to consider image as mostly black (0-1)
    
    Returns:
        Tuple (is_black, black_ratio, mean_brightness)
    """
    try:
        # Read image
        img = cv2.imread(str(image_path))
        if img is None:
            return True, 1.0, 0.0  # Consider unreadable images as black
        
        # Convert to grayscale
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        # Count black pixels
        black_pixels = np.sum(gray <= black_threshold)
        total_pixels = gray.size
        black_ratio = black_pixels / total_pixels
        
        # Calculate mean brightness
        mean_brightness = np.mean(gray)
        
        # Image is mostly black if black_ratio exceeds threshold
        is_black = black_ratio >= black_percentage
        
        return is_black, black_ratio, mean_brightness
    
    except Exception as e:
        print(f"\nError processing {image_path}: {e}")
        return True, 1.0, 0.0


def analyze_dataset(base_dir, black_threshold=10, black_percentage=0.8):
    """
    Analyze dataset to find mostly black images
    
    Args:
        base_dir: Base directory to analyze
        black_threshold: Pixel value threshold for black
        black_percentage: Minimum percentage to consider as mostly black
    
    Returns:
        List of (image_path, black_ratio, mean_brightness) for black images
    """
    base_path = Path(base_dir)
    if not base_path.exists():
        print(f"Error: Folder {base_dir} tidak ditemukan!")
        return []
    
    # Find all image files
    image_extensions = {'.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.webp'}
    image_files = []
    for ext in image_extensions:
        image_files.extend(list(base_path.rglob(f'*{ext}')))
        # image_files.extend(list(base_path.rglob(f'*{ext.upper()}')))
    
    if len(image_files) == 0:
        print(f"Tidak ada gambar ditemukan di {base_dir}")
        return []
    
    print(f"\nMenganalisis {len(image_files)} gambar...")
    print(f"Threshold hitam: {black_threshold}/255")
    print(f"Persentase hitam minimum: {black_percentage*100}%\n")
    
    # Analyze each image
    black_images = []
    
    for img_path in tqdm(image_files, desc="Menganalisis gambar", unit="img"):
        is_black, black_ratio, mean_brightness = is_mostly_black(
            img_path, black_threshold, black_percentage
        )
        
        if is_black:
            black_images.append((img_path, black_ratio, mean_brightness))
    
    return black_images


def remove_black_images(base_dir, black_threshold=10, black_percentage=0.8, 
                       backup=True, dry_run=False):
    """
    Remove mostly black images from dataset
    
    Args:
        base_dir: Base directory to process
        black_threshold: Pixel value threshold for black
        black_percentage: Minimum percentage to consider as mostly black
        backup: Create backup before deletion
        dry_run: Only show what would be deleted without actually deleting
    """
    
    print("="*70)
    print(" REMOVE BLACK IMAGES")
    print("="*70)
    
    # Analyze dataset
    black_images = analyze_dataset(base_dir, black_threshold, black_percentage)
    
    if len(black_images) == 0:
        print("\n✓ Tidak ada gambar hitam yang ditemukan!")
        return
    
    # Show statistics
    print("\n" + "="*70)
    print(f"DITEMUKAN {len(black_images)} GAMBAR HITAM")
    print("="*70)
    
    # Group by folder
    folder_stats = {}
    for img_path, black_ratio, mean_brightness in black_images:
        folder = str(img_path.parent.relative_to(Path(base_dir)))
        if folder not in folder_stats:
            folder_stats[folder] = []
        folder_stats[folder].append((img_path.name, black_ratio, mean_brightness))
    
    # Show per folder
    print("\nStatistik per folder:")
    for folder, images in sorted(folder_stats.items()):
        print(f"\n  {folder}/ ({len(images)} gambar hitam)")
        # Show first 5 examples
        for name, ratio, brightness in images[:5]:
            print(f"    - {name} (hitam: {ratio*100:.1f}%, brightness: {brightness:.1f})")
        if len(images) > 5:
            print(f"    ... dan {len(images)-5} gambar lainnya")
    
    # Show some examples
    print("\n" + "="*70)
    print("Contoh gambar yang akan dihapus (5 terburuk):")
    print("="*70)
    sorted_black = sorted(black_images, key=lambda x: x[1], reverse=True)[:5]
    for img_path, black_ratio, mean_brightness in sorted_black:
        rel_path = img_path.relative_to(Path(base_dir))
        print(f"  {rel_path}")
        print(f"    Hitam: {black_ratio*100:.1f}% | Brightness: {mean_brightness:.1f}")
    
    if dry_run:
        print("\n" + "="*70)
        print("DRY RUN MODE - Tidak ada file yang dihapus")
        print("="*70)
        return
    
    # Confirm deletion
    print("\n" + "="*70)
    response = input(f"\nHapus {len(black_images)} gambar hitam? (y/n): ").lower().strip()
    if response != 'y':
        print("Dibatalkan.")
        return
    
    # Create backup if requested
    if backup:
        backup_dir = f"{base_dir}_backup_black_images"
        print(f"\nMembuat backup ke {backup_dir}/...")
        for img_path, _, _ in tqdm(black_images, desc="Backup gambar", unit="img"):
            rel_path = img_path.relative_to(Path(base_dir))
            backup_path = Path(backup_dir) / rel_path
            backup_path.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(img_path, backup_path)
        print(f"✓ Backup selesai di {backup_dir}/")
    
    # Delete images
    print("\nMenghapus gambar hitam...")
    deleted_count = 0
    error_count = 0
    
    for img_path, _, _ in tqdm(black_images, desc="Menghapus gambar", unit="img"):
        try:
            img_path.unlink()
            deleted_count += 1
        except Exception as e:
            print(f"\nError menghapus {img_path}: {e}")
            error_count += 1
    
    # Remove empty directories
    print("\nMembersihkan folder kosong...")
    remove_empty_dirs(Path(base_dir))
    
    # Summary
    print("\n" + "="*70)
    print("RINGKASAN")
    print("="*70)
    print(f"Gambar dihapus:   {deleted_count}")
    print(f"Error:            {error_count}")
    if backup:
        print(f"Backup disimpan:  {backup_dir}/")
    print("="*70)
    print("\n✓ Selesai!")


def remove_empty_dirs(directory):
    """
    Remove empty directories recursively
    
    Args:
        directory: Base directory to clean
    """
    for dirpath, dirnames, filenames in os.walk(str(directory), topdown=False):
        if not dirnames and not filenames:
            try:
                Path(dirpath).rmdir()
                print(f"  Dihapus folder kosong: {dirpath}")
            except Exception as e:
                pass


def show_dataset_stats(base_dir):
    """
    Show statistics about the dataset
    
    Args:
        base_dir: Base directory to analyze
    """
    base_path = Path(base_dir)
    if not base_path.exists():
        print(f"Folder {base_dir} tidak ditemukan!")
        return
    
    print("\n" + "="*70)
    print(" STATISTIK DATASET")
    print("="*70)
    
    # Count images per folder
    image_extensions = {'.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.webp'}
    
    for split in ['train', 'val']:
        split_path = base_path / split
        if not split_path.exists():
            continue
        
        print(f"\n{split.upper()}/")
        
        total_images = 0
        for class_dir in sorted(split_path.iterdir()):
            if class_dir.is_dir():
                images = []
                for ext in image_extensions:
                    images.extend(list(class_dir.glob(f'*{ext}')))
                    images.extend(list(class_dir.glob(f'*{ext.upper()}')))
                
                num_images = len(images)
                total_images += num_images
                print(f"  {class_dir.name}: {num_images} gambar")
        
        print(f"  Total: {total_images} gambar")
    
    print("="*70)


def main():
    """Main function"""
    
    print("="*70)
    print(" REMOVE BLACK IMAGES - Dataset Cleaner")
    print("="*70)
    
    # Configuration
    BASE_DIR = "dataset_prepared_u2netp"  # Change this to your dataset folder
    BLACK_THRESHOLD = 10  # Pixel value threshold (0-255)
    BLACK_PERCENTAGE = 0.80  # 80% black pixels
    BACKUP = False  # Create backup before deletion
    DRY_RUN = False  # Set to True to see what would be deleted without deleting
    
    # Check if directory exists
    if not os.path.exists(BASE_DIR):
        print(f"\n✗ Error: Folder '{BASE_DIR}' tidak ditemukan!")
        print(f"\nFolder yang tersedia:")
        possible_dirs = [
            "dataset_prepared",
            "dataset_prepared_u2netp",
            "dataset_grouped"
        ]
        for d in possible_dirs:
            if os.path.exists(d):
                print(f"  ✓ {d}/")
        
        print(f"\nEdit BASE_DIR di script jika ingin menggunakan folder lain.")
        return
    
    # Show current dataset stats
    show_dataset_stats(BASE_DIR)
    
    print(f"\nKonfigurasi:")
    print(f"  Folder:              {BASE_DIR}")
    print(f"  Black threshold:     {BLACK_THRESHOLD}/255")
    print(f"  Black percentage:    {BLACK_PERCENTAGE*100}%")
    print(f"  Backup:              {'Ya' if BACKUP else 'Tidak'}")
    print(f"  Dry run:             {'Ya' if DRY_RUN else 'Tidak'}")
    
    if DRY_RUN:
        print(f"\n⚠ DRY RUN MODE - Tidak ada file yang akan dihapus")
    
    # Process
    remove_black_images(
        BASE_DIR,
        black_threshold=BLACK_THRESHOLD,
        black_percentage=BLACK_PERCENTAGE,
        backup=BACKUP,
        dry_run=DRY_RUN
    )
    
    # Show updated stats
    if not DRY_RUN:
        print("\nStatistik setelah pembersihan:")
        show_dataset_stats(BASE_DIR)


if __name__ == "__main__":
    main()
