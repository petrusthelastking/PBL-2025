import argparse
import os
import shutil
import sys
from pathlib import Path
from typing import Dict, List, Tuple
import random

CLASS_TO_GROUP: Dict[str, str] = {
	"bean": "Sayur_Polong",
	"bitter_gourd": "Sayur_Buah",
	"bottle_gourd": "Sayur_Buah",
	"brinjal": "Sayur_Buah",
	"broccoli": "Sayur_Daun",
	"cabbage": "Sayur_Daun",
	"capsicum": "Sayur_Buah",
	"carrot": "Sayur_Akar",
	"cauliflower": "Sayur_Daun",
	"cucumber": "Sayur_Buah",
	"papaya": "Sayur_Buah",
	"potato": "Sayur_Akar",
	"pumpkin": "Sayur_Buah",
	"radish": "Sayur_Akar",
	"tomato": "Sayur_Buah",
}

IMAGE_EXTS = {".jpg", ".jpeg", ".png", ".bmp", ".webp"}


def norm_name(name: str) -> str:
	return name.strip().lower().replace(" ", "_")


def collect_images(input_dir: Path, strict: bool = False) -> Dict[str, List[Tuple[Path, str]]]:
	"""
	Kumpulkan semua gambar dari subfolder kelas dan kelompokkan ke group tujuan.
	Return: dict[group_label] -> list of (image_path, source_class)
	"""
	grouped: Dict[str, List[Tuple[Path, str]]] = {}

	if not input_dir.exists():
		raise FileNotFoundError(f"Input folder tidak ditemukan: {input_dir}")

	for item in sorted(input_dir.iterdir()):
		if not item.is_dir():
			continue

		src_class = item.name
		src_key = norm_name(src_class)
		group = CLASS_TO_GROUP.get(src_key)
		if group is None:
			msg = f"Peringatan: kelas '{src_class}' tidak ada di mapping, dilewati. (tambahkan ke CLASS_TO_GROUP jika perlu)"
			if strict:
				raise KeyError(msg)
			else:
				print(msg)
				continue

		files = [p for p in item.rglob("*") if p.is_file() and p.suffix.lower() in IMAGE_EXTS]
		if not files:
			print(f"Peringatan: tidak ada file gambar di kelas '{src_class}'.")
			continue

		lst = grouped.setdefault(group, [])
		for f in files:
			lst.append((f, src_class))

	return grouped


def split_indices3(
	n: int,
	test_ratio: float,
	val_ratio: float,
	seed: int,
) -> Tuple[List[int], List[int], List[int]]:
	"""Return (train_idx, test_idx, val_idx) disjoint indices.
	Rounding uses floor for test/val; remainder goes to train.
	"""
	indices = list(range(n))
	rnd = random.Random(seed)
	rnd.shuffle(indices)
	n_test = int(n * test_ratio)
	n_val = int(n * val_ratio)
	test_idx = indices[:n_test]
	val_idx = indices[n_test : n_test + n_val]
	train_idx = indices[n_test + n_val :]
	return train_idx, test_idx, val_idx


def safe_copy(src: Path, dst: Path, *, move: bool = False):
	dst.parent.mkdir(parents=True, exist_ok=True)
	if dst.exists():
		# Tambahkan suffix unik jika bentrok
		stem, suf = dst.stem, dst.suffix
		i = 1
		while True:
			cand = dst.with_name(f"{stem}__{i}{suf}")
			if not cand.exists():
				dst = cand
				break
			i += 1
	if move:
		shutil.move(str(src), str(dst))
	else:
		shutil.copy2(str(src), str(dst))
	return dst


def prepare(
	input_dir: Path,
	output_dir: Path,
	test_ratio: float = 0.2,
	val_ratio: float = 0.0,
	seed: int = 42,
	move: bool = False,
	dry_run: bool = False,
	clean: bool = False,
	strict: bool = False,
):
	for name, r in {"test": test_ratio, "val": val_ratio}.items():
		if not (0.0 <= r < 1.0):
			raise ValueError(f"{name}-ratio harus di antara 0.0 dan <1.0")
	if test_ratio + val_ratio >= 0.99:
		raise ValueError("Jumlah test-ratio + val-ratio harus < 0.99 (sisakan untuk train)")

	grouped = collect_images(input_dir, strict=strict)
	if not grouped:
		print("Tidak ada data yang diproses. Pastikan folder input berisi subfolder kelas dan gambar.")
		return

	if clean and output_dir.exists():
		print(f"Membersihkan output dir: {output_dir}")
		shutil.rmtree(output_dir)

	# Ringkasan awal
	total = 0
	print("Ringkasan data per kelompok (sebelum split):")
	for group, items in grouped.items():
		print(f"- {group}: {len(items)} file")
		total += len(items)
	print(f"Total: {total} file\n")

	# Proses split dan salin/pindah
	overall_counts = {"train": 0, "test": 0, "val": 0}
	for group, items in grouped.items():
		n = len(items)
		train_idx, test_idx, val_idx = split_indices3(
			n,
			test_ratio,
			val_ratio,
			seed=hash((seed, group)) & 0xFFFFFFFF,
		)

		def dst_path(split: str, src_path: Path, src_class: str) -> Path:
			# Hindari bentrok nama file antar kelas: prefix dengan nama kelas sumber yang dinormalisasi
			prefix = norm_name(src_class)
			return output_dir / split / group / f"{prefix}__{src_path.stem}{src_path.suffix.lower()}"

		if dry_run:
			msg = (
				f"[DRY-RUN] {group}: train={len(train_idx)}, test={len(test_idx)}"
				+ (f", val={len(val_idx)}" if len(val_idx) > 0 else "")
			)
			print(msg)
		else:
			for i in train_idx:
				src, src_class = items[i]
				dst = dst_path("train", src, src_class)
				safe_copy(src, dst, move=move)
			for i in test_idx:
				src, src_class = items[i]
				dst = dst_path("test", src, src_class)
				safe_copy(src, dst, move=move)
			for i in val_idx:
				src, src_class = items[i]
				dst = dst_path("val", src, src_class)
				safe_copy(src, dst, move=move)
			overall_counts["train"] += len(train_idx)
			overall_counts["test"] += len(test_idx)
			overall_counts["val"] += len(val_idx)

	if dry_run:
		print("\n[DRY-RUN] Tidak ada file yang disalin/dipindah. Gunakan tanpa --dry-run untuk mengeksekusi.")
	else:
		print("\nSelesai.")
		print(f"Output: {output_dir}")
		print(
			f"Total train: {overall_counts['train']} file, "
			f"test: {overall_counts['test']} file"
			+ (f", val: {overall_counts['val']} file" if overall_counts['val'] > 0 else "")
		)
		if move:
			print("Catatan: File sumber telah dipindahkan (bukan disalin).")


def build_arg_parser() -> argparse.ArgumentParser:
	parser = argparse.ArgumentParser(
		description=(
			"Regroup dataset sayuran ke bentuk biologis (Sayur_Daun/Akar/Buah/Polong)"
			" dan split ke train/test (+ val opsional) dengan rasio yang bisa diatur."
		)
	)
	here = Path(__file__).resolve().parent
	default_input = (here / "train").resolve()
	default_output = (here / "dataset_grouped").resolve()

	parser.add_argument(
		"--input",
		type=Path,
		default=default_input,
		help=f"Folder input berisi subfolder kelas (default: {default_input})",
	)
	parser.add_argument(
		"--output",
		type=Path,
		default=default_output,
		help=f"Folder output hasil regroup+split (default: {default_output})",
	)
	parser.add_argument(
		"--test-ratio",
		type=float,
		default=0.2,
		help="Proporsi data untuk test (0.0-<1.0), default 0.2",
	)
	parser.add_argument(
		"--val-ratio",
		type=float,
		default=0.0,
		help="Proporsi data untuk validasi (opsional, 0.0 berarti tidak ada val), default 0.0",
	)
	parser.add_argument(
		"--seed",
		type=int,
		default=42,
		help="Seed random untuk hasil yang reprodusibel (default: 42)",
	)
	parser.add_argument(
		"--move",
		action="store_true",
		help="Pindahkan file (bukan copy). Hati-hati: akan memindahkan dari folder sumber.",
	)
	parser.add_argument(
		"--dry-run",
		action="store_true",
		help="Tampilkan ringkasan tanpa menyalin/memindahkan file.",
	)
	parser.add_argument(
		"--clean",
		action="store_true",
		help="Hapus folder output jika sudah ada sebelum menulis ulang.",
	)
	parser.add_argument(
		"--strict",
		action="store_true",
		help="Error jika ada kelas yang tidak terpetakan (default: skip dengan peringatan)",
	)
	return parser


def main(argv=None):
	parser = build_arg_parser()
	args = parser.parse_args(argv)

	try:
		prepare(
			input_dir=args.input,
			output_dir=args.output,
			test_ratio=args.test_ratio,
			val_ratio=args.val_ratio,
			seed=args.seed,
			move=args.move,
			dry_run=args.dry_run,
			clean=args.clean,
			strict=args.strict,
		)
	except Exception as e:
		print(f"Error: {e}")
		sys.exit(1)


if __name__ == "__main__":
	main()

