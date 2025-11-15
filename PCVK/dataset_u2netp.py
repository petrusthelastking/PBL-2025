"""
Script untuk mensegmentasi semua gambar di dataset_prepared menggunakan U2Net-P
dan menyimpannya ke folder baru dengan struktur yang sama
"""

import os
import cv2
import numpy as np
from pathlib import Path
from tqdm import tqdm
import sys

# Add lib directory to path
sys.path.append(os.path.join(os.path.dirname(__file__), 'lib'))

try:
    from rembg import remove, new_session
    REMBG_AVAILABLE = True
    print("✓ rembg library tersedia")
except ImportError:
    REMBG_AVAILABLE = False
    print("✗ rembg tidak tersedia. Install dengan: pip install rembg")
    print("  Mencoba menggunakan metode alternatif...")

from PIL import Image


def segment_with_u2netp_rembg(img_bgr, session):
    """
    Segment image using U2Net-P via rembg library
    
    Args:
        img_bgr: Input image in BGR format (OpenCV)
        session: rembg session
    
    Returns:
        Segmented image in BGR format
    """
    try:
        # Convert BGR to RGB for PIL
        img_rgb = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2RGB)
        img_pil = Image.fromarray(img_rgb)
        
        # Remove background using U2Net-P
        output = remove(img_pil, session=session)
        
        # Convert back to numpy array
        output_np = np.array(output)
        
        # If output has alpha channel, apply it as mask
        if output_np.shape[2] == 4:
            # Extract RGB and alpha
            rgb = output_np[:, :, :3]
            alpha = output_np[:, :, 3]
            
            # Apply alpha channel as mask to get foreground
            mask = alpha.astype(float) / 255.0
            segmented = (rgb * mask[:, :, np.newaxis]).astype(np.uint8)
            
            # Convert back to BGR for OpenCV
            segmented_bgr = cv2.cvtColor(segmented, cv2.COLOR_RGB2BGR)
        else:
            segmented_bgr = cv2.cvtColor(output_np, cv2.COLOR_RGB2BGR)
        
        return segmented_bgr
    
    except Exception as e:
        print(f"Error in U2Net-P segmentation: {e}")
        return img_bgr


def process_dataset(input_base_dir, output_base_dir, model_name="u2netp"):
    """
    Process all images in dataset with U2Net-P segmentation
    
    Args:
        input_base_dir: Base directory of input dataset (e.g., 'dataset_prepared')
        output_base_dir: Base directory for output (e.g., 'dataset_prepared_u2netp')
        model_name: Model to use ('u2netp', 'u2net', etc.)
    """
    
    if not REMBG_AVAILABLE:
        print("\n" + "="*70)
        print("ERROR: rembg library tidak tersedia!")
        print("Install dengan perintah:")
        print("  pip install rembg")
        print("="*70)
        return
    
    # Initialize U2Net-P session
    print(f"\nInisialisasi model {model_name}...")
    try:
        session = new_session(model_name)
        print(f"✓ Model {model_name} berhasil dimuat")
    except Exception as e:
        print(f"✗ Error loading model: {e}")
        return
    
    # Find all image files
    input_path = Path(input_base_dir)
    if not input_path.exists():
        print(f"✗ Error: Folder {input_base_dir} tidak ditemukan!")
        return
    
    # Supported image extensions
    image_extensions = {'.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.webp'}
    
    # Collect all image files
    image_files = []
    for ext in image_extensions:
        image_files.extend(list(input_path.rglob(f'*{ext}')))
        # image_files.extend(list(input_path.rglob(f'*{ext.upper()}')))
    
    if len(image_files) == 0:
        print(f"✗ Tidak ada gambar ditemukan di {input_base_dir}")
        return
    
    print(f"\n✓ Ditemukan {len(image_files)} gambar")
    print(f"Input:  {input_base_dir}")
    print(f"Output: {output_base_dir}")
    print(f"Model:  {model_name}")
    print("\nMemulai proses segmentasi...\n")
    
    # Process each image
    success_count = 0
    error_count = 0
    
    for img_path in tqdm(image_files, desc="Segmentasi gambar", unit="img"):
        try:
            # Read image
            img = cv2.imread(str(img_path))
            if img is None:
                print(f"\n✗ Gagal membaca: {img_path}")
                error_count += 1
                continue
            
            # Segment image
            segmented = segment_with_u2netp_rembg(img, session)
            
            # Create output path with same structure
            relative_path = img_path.relative_to(input_path)
            output_path = Path(output_base_dir) / relative_path
            
            # Create output directory if not exists
            output_path.parent.mkdir(parents=True, exist_ok=True)
            
            # Save segmented image
            cv2.imwrite(str(output_path), segmented)
            success_count += 1
            
        except Exception as e:
            print(f"\n✗ Error processing {img_path}: {e}")
            error_count += 1
    
    # Summary
    print("\n" + "="*70)
    print("RINGKASAN PROSES")
    print("="*70)
    print(f"Total gambar:     {len(image_files)}")
    print(f"Berhasil:         {success_count} ({success_count/len(image_files)*100:.1f}%)")
    print(f"Gagal:            {error_count}")
    print(f"Output folder:    {output_base_dir}")
    print("="*70)


def preview_results(output_base_dir, num_samples=5):
    """
    Show preview of segmented images
    
    Args:
        output_base_dir: Directory containing segmented images
        num_samples: Number of samples to preview
    """
    output_path = Path(output_base_dir)
    if not output_path.exists():
        print(f"Output folder {output_base_dir} belum ada")
        return
    
    # Find some sample images
    image_files = list(output_path.rglob('*.jpg'))[:num_samples]
    
    if len(image_files) == 0:
        print("Tidak ada gambar untuk preview")
        return
    
    print(f"\nPreview {len(image_files)} gambar hasil segmentasi:")
    for img_path in image_files:
        print(f"  - {img_path}")


def main():
    """Main function"""
    
    print("="*70)
    print(" DATASET SEGMENTATION - U2Net-P")
    print("="*70)
    
    # Configuration
    INPUT_DIR = "dataset_prepared"
    OUTPUT_DIR = "dataset_prepared_u2netp"
    MODEL_NAME = "u2netp"  # Options: 'u2netp', 'u2net', 'isnet-general-use', etc.
    
    # Check if input directory exists
    if not os.path.exists(INPUT_DIR):
        print(f"\n✗ Error: Folder '{INPUT_DIR}' tidak ditemukan!")
        print(f"   Pastikan Anda menjalankan script ini dari folder ForPCVK")
        print(f"   Struktur yang diharapkan:")
        print(f"     ForPCVK/")
        print(f"       ├── dataset_prepared/")
        print(f"       │   ├── train/")
        print(f"       │   └── val/")
        print(f"       └── dataset_u2netp.py (script ini)")
        return
    
    # Show structure
    print(f"\nStruktur folder input:")
    train_dir = os.path.join(INPUT_DIR, "train")
    val_dir = os.path.join(INPUT_DIR, "val")
    
    if os.path.exists(train_dir):
        train_classes = [d for d in os.listdir(train_dir) if os.path.isdir(os.path.join(train_dir, d))]
        print(f"  {INPUT_DIR}/train/")
        for cls in train_classes:
            cls_path = os.path.join(train_dir, cls)
            num_images = len([f for f in os.listdir(cls_path) if f.lower().endswith(('.jpg', '.jpeg', '.png'))])
            print(f"    ├── {cls}/ ({num_images} gambar)")
    
    if os.path.exists(val_dir):
        val_classes = [d for d in os.listdir(val_dir) if os.path.isdir(os.path.join(val_dir, d))]
        print(f"  {INPUT_DIR}/val/")
        for cls in val_classes:
            cls_path = os.path.join(val_dir, cls)
            num_images = len([f for f in os.listdir(cls_path) if f.lower().endswith(('.jpg', '.jpeg', '.png'))])
            print(f"    ├── {cls}/ ({num_images} gambar)")
    
    # Confirm
    print(f"\nOutput akan disimpan ke: {OUTPUT_DIR}/")
    print(f"Dengan struktur folder yang sama.\n")
    
    response = input("Lanjutkan? (y/n): ").lower().strip()
    if response != 'y':
        print("Dibatalkan.")
        return
    
    # Process dataset
    process_dataset(INPUT_DIR, OUTPUT_DIR, MODEL_NAME)
    
    # Preview results
    preview_results(OUTPUT_DIR, num_samples=5)
    
    print("\n✓ Selesai!")
    print(f"\nAnda sekarang dapat menggunakan dataset yang sudah disegmentasi:")
    print(f"  - Training: {OUTPUT_DIR}/train/")
    print(f"  - Validation: {OUTPUT_DIR}/val/")


if __name__ == "__main__":
    main()
