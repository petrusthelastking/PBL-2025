"""
Script to match dataset files based on filenames inside each class.
Deletes files in ref2 that don't exist in ref1 (reference dataset).
Supports nested structure: dataset/split/class/files (e.g., dataset/train/class1/image.jpg)

Usage:
    python match_data.py <ref1_path> <ref2_path> [--dry-run]

Example:
    python match_data.py ./dataset1 ./dataset2
    python match_data.py ./dataset1 ./dataset2 --dry-run
"""

import os
import argparse
from pathlib import Path
from collections import defaultdict


def get_class_files(dataset_path):
    """
    Get all files organized by split and class folder.
    Handles structure: dataset/split/class/files
    
    Args:
        dataset_path: Path to the dataset directory
        
    Returns:
        dict: {split: {class_name: set(filenames)}}
    """
    dataset_path = Path(dataset_path)
    split_class_files = defaultdict(lambda: defaultdict(set))
    
    if not dataset_path.exists():
        print(f"Warning: Dataset path does not exist: {dataset_path}")
        return split_class_files
    
    # Iterate through split folders (train, val, test, etc.)
    for split_dir in dataset_path.iterdir():
        if split_dir.is_dir():
            split_name = split_dir.name
            # Iterate through class folders
            for class_dir in split_dir.iterdir():
                if class_dir.is_dir():
                    class_name = class_dir.name
                    # Get all files in this class folder
                    for file_path in class_dir.iterdir():
                        if file_path.is_file():
                            split_class_files[split_name][class_name].add(file_path.name)
    
    return split_class_files


def match_datasets(ref1_path, ref2_path, dry_run=False):
    """
    Match files in ref2 based on ref1, deleting files not in ref1.
    Handles structure: dataset/split/class/files
    
    Args:
        ref1_path: Path to reference dataset (ref1)
        ref2_path: Path to dataset to match (ref2)
        dry_run: If True, only show what would be deleted without actually deleting
    """
    print(f"Reference dataset (ref1): {ref1_path}")
    print(f"Dataset to match (ref2): {ref2_path}")
    print(f"Dry run mode: {dry_run}")
    print("-" * 60)
    
    # Get files from both datasets
    ref1_files = get_class_files(ref1_path)
    ref2_files = get_class_files(ref2_path)
    
    if not ref1_files:
        print("Error: No splits/classes found in ref1 dataset!")
        return
    
    if not ref2_files:
        print("Error: No splits/classes found in ref2 dataset!")
        return
    
    print(f"Found {len(ref1_files)} splits in ref1: {sorted(ref1_files.keys())}")
    print(f"Found {len(ref2_files)} splits in ref2: {sorted(ref2_files.keys())}")
    print("-" * 60)
    
    total_deleted = 0
    total_kept = 0
    
    # Process each split in ref2
    for split_name in sorted(ref2_files.keys()):
        ref2_split = ref2_files[split_name]
        ref1_split = ref1_files.get(split_name, {})
        
        if not ref1_split:
            print(f"\nWarning: Split '{split_name}' exists in ref2 but not in ref1")
            total_files = sum(len(files) for files in ref2_split.values())
            print(f"  Skipping {total_files} files in {len(ref2_split)} classes")
            continue
        
        print(f"\n{'=' * 60}")
        print(f"Processing split: {split_name}")
        print(f"{'=' * 60}")
        
        # Process each class in this split
        for class_name in sorted(ref2_split.keys()):
            ref2_class_files = ref2_split[class_name]
            ref1_class_files = ref1_split.get(class_name, set())
            
            if not ref1_class_files:
                print(f"\n  Warning: Class '{class_name}' exists in ref2/{split_name} but not in ref1/{split_name}")
                print(f"    Skipping {len(ref2_class_files)} files in this class")
                continue
            
            # Find files to delete (in ref2 but not in ref1)
            files_to_delete = ref2_class_files - ref1_class_files
            files_to_keep = ref2_class_files & ref1_class_files
            
            if files_to_delete or files_to_keep:
                print(f"\n  Class: {class_name}")
                print(f"    Files in ref1: {len(ref1_class_files)}")
                print(f"    Files in ref2: {len(ref2_class_files)}")
                print(f"    Files to keep: {len(files_to_keep)}")
                print(f"    Files to delete: {len(files_to_delete)}")
                
                # Delete files
                if files_to_delete:
                    for filename in sorted(files_to_delete):
                        file_path = Path(ref2_path) / split_name / class_name / filename
                        
                        if dry_run:
                            print(f"      [DRY RUN] Would delete: {filename}")
                        else:
                            try:
                                file_path.unlink()
                                print(f"      Deleted: {filename}")
                                total_deleted += 1
                            except Exception as e:
                                print(f"      Error deleting {filename}: {e}")
            
            total_kept += len(files_to_keep)
    
    print("\n" + "=" * 60)
    print("Summary:")
    print(f"  Total files kept: {total_kept}")
    print(f"  Total files deleted: {total_deleted}")
    if dry_run:
        print(f"\n  This was a DRY RUN - no files were actually deleted")
    print("=" * 60)


def main():
    parser = argparse.ArgumentParser(
        description="Match dataset files based on reference dataset",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python match_data.py ./dataset1 ./dataset2
  python match_data.py ./dataset1 ./dataset2 --dry-run
  
This script will:
  1. Scan all splits (train, val, test, etc.) and class folders in ref1
  2. For each split/class in ref2, delete files that don't exist in ref1
  3. Keep only files that exist in both datasets
  
Expected structure:
  dataset/
    train/
      class1/
        image1.jpg
        image2.jpg
      class2/
        ...
    val/
      class1/
        ...
        """
    )
    
    parser.add_argument(
        "ref1_path",
        type=str,
        help="Path to reference dataset (ref1) - files here will be used as reference"
    )
    
    parser.add_argument(
        "ref2_path",
        type=str,
        help="Path to dataset to match (ref2) - files not in ref1 will be deleted"
    )
    
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be deleted without actually deleting files"
    )
    
    args = parser.parse_args()
    
    # Convert to absolute paths
    ref1_path = Path(args.ref1_path).resolve()
    ref2_path = Path(args.ref2_path).resolve()
    
    # Confirmation
    if not args.dry_run:
        print("WARNING: This will DELETE files in ref2 that don't exist in ref1!")
        print(f"Reference: {ref1_path}")
        print(f"Target: {ref2_path}")
        response = input("\nDo you want to continue? (yes/no): ")
        if response.lower() not in ['yes', 'y']:
            print("Operation cancelled.")
            return
    
    match_datasets(ref1_path, ref2_path, args.dry_run)


if __name__ == "__main__":
    main()
