# 🎯 GENERATOR DUMMY DATA PENDUDUK - VISUAL GUIDE

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   📊  GENERATOR DUMMY DATA PENDUDUK                          ║
║                                                              ║
║   Generate ratusan data warga otomatis ke Firestore!        ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 🚀 CARA PALING MUDAH

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  1️⃣  Double-click:                                      │
│      📄 run_generator_penduduk.bat                      │
│                                                         │
│  2️⃣  Klik tombol:                                       │
│      🟦 "Generate Data Dummy"                           │
│                                                         │
│  3️⃣  SELESAI! ✅                                        │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 📊 APA YANG AKAN DIGENERATE?

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  📍 RT 001-005 (5 RT)                                   │
│  📍 RW 001-003 (3 RW)                                   │
│  👨‍👩‍👧‍👦 5-8 Keluarga per RT                                │
│  👤 100-300+ Warga                                       │
│                                                         │
│  ⏱️  Waktu: 1-5 menit                                    │
│  💾 Langsung ke Firestore                               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 👨‍👩‍👧‍👦 STRUKTUR KELUARGA

```
        👨 Kepala Keluarga
        │  (30-60 tahun)
        │
        ├─── 👩 Istri (60% chance)
        │    (25-55 tahun)
        │
        └─── 👶 Anak (0-4 orang)
             (1-25 tahun)
```

---

## 📋 DATA YANG LENGKAP

```
┌──────────────────────┬──────────────────────────────┐
│  ✅ NIK              │  16 digit unik               │
│  ✅ Nomor KK         │  16 digit per keluarga       │
│  ✅ Nama             │  20+ variasi                 │
│  ✅ Tempat Lahir     │  12 kota besar               │
│  ✅ Tanggal Lahir    │  Sesuai umur                 │
│  ✅ Jenis Kelamin    │  Laki-laki/Perempuan         │
│  ✅ Agama            │  6 pilihan                   │
│  ✅ Gol. Darah       │  A, B, AB, O, -              │
│  ✅ Pendidikan       │  8 level (auto sesuai umur)  │
│  ✅ Pekerjaan        │  12+ jenis (auto sesuai umur)│
│  ✅ Status Kawin     │  4 status                    │
│  ✅ Peran Keluarga   │  Kepala/Istri/Anak           │
│  ✅ RT/RW            │  Auto distribute             │
│  ✅ Alamat           │  8 variasi jalan             │
│  ✅ Telepon          │  12 digit random             │
│  ✅ Dan 10+ field lainnya...                        │
└──────────────────────┴──────────────────────────────┘
```

---

## 🎯 CONTOH OUTPUT

```
╔═══════════════════════════════════════════════════════╗
║  RT 001 RW 001                                        ║
╠═══════════════════════════════════════════════════════╣
║                                                       ║
║  🏠 Keluarga Sudirman (KK: 3217***********56)         ║
║     👨 Ahmad Sudirman (Kepala) - 45 tahun             ║
║     👩 Ani Suryani (Istri) - 40 tahun                 ║
║     👦 Andi Sudirman (Anak) - 15 tahun - Pelajar      ║
║     👧 Salsabila Sudirman (Anak) - 12 tahun - Pelajar ║
║                                                       ║
║  🏠 Keluarga Santoso (KK: 3217***********87)          ║
║     👨 Budi Santoso (Kepala) - 52 tahun               ║
║     👩 Citra Dewi (Istri) - 48 tahun                  ║
║     👦 Bayu Santoso (Anak) - 22 tahun - Mahasiswa     ║
║                                                       ║
║  ... 5-8 keluarga total per RT                        ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
```

---

## 🎨 UI APLIKASI GENERATOR

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                                    ┃
┃         👥 Generator Data Dummy Penduduk          ┃
┃                                                    ┃
┃     ┌──────────────────────────────────────┐      ┃
┃     │  ℹ️  Status: Siap generate data       │      ┃
┃     └──────────────────────────────────────┘      ┃
┃                                                    ┃
┃     ┌──────────────────────────────────────┐      ┃
┃     │  ✅ Total: 0 warga                    │      ┃
┃     └──────────────────────────────────────┘      ┃
┃                                                    ┃
┃     ┌──────────────────────────────────────┐      ┃
┃     │  ✨ Generate Data Dummy              │      ┃
┃     └──────────────────────────────────────┘      ┃
┃                                                    ┃
┃     ┌──────────────────────────────────────┐      ┃
┃     │  🗑️  Hapus Semua Data                │      ┃
┃     └──────────────────────────────────────┘      ┃
┃                                                    ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## 📂 FILE YANG DIBUAT

```
📦 Root Directory
│
├── 📄 run_generator_penduduk.bat
│   └── Double-click untuk run (Windows)
│
├── 📄 QUICK_START_GENERATOR_PENDUDUK.md
│   └── Panduan singkat 3 langkah
│
├── 📄 GENERATOR_FILES_SUMMARY.md
│   └── Summary lengkap semua fitur
│
├── 📁 lib/
│   └── 📄 generate_dummy_penduduk.dart
│       └── Main application code
│
└── 📁 README/
    └── 📄 CARA_GENERATE_DUMMY_PENDUDUK.md
        └── Tutorial lengkap + troubleshooting
```

---

## 🎮 CARA MENGGUNAKAN

### 🥇 Option 1: Batch File (TERMUDAH!)

```bash
# Cukup double-click:
run_generator_penduduk.bat
```

### 🥈 Option 2: Flutter Command

```bash
flutter run -d chrome lib/generate_dummy_penduduk.dart
```

### 🥉 Option 3: VS Code

```
1. Buka lib/generate_dummy_penduduk.dart
2. Tekan F5 atau Ctrl+F5
3. Pilih Chrome
```

---

## ⚡ PROSES GENERATE

```
1. Klik "Generate Data Dummy"
   ↓
2. Proses dimulai...
   ├── Generate RT 001 RW 001... ✓
   ├── Generate RT 002 RW 001... ✓
   ├── Generate RT 003 RW 001... ✓
   ├── Generate RT 004 RW 001... ✓
   ├── Generate RT 005 RW 001... ✓
   ├── Generate RT 001 RW 002... ✓
   └── ... (15 kombinasi RT/RW)
   ↓
3. ✅ Selesai! 150+ warga digenerate
```

---

## 📊 MONITORING PROGRESS

```
┌─────────────────────────────────────────────┐
│                                             │
│  🔄 Generate data untuk RT 003 RW 002...    │
│                                             │
│  Generated 87 warga: Fajar Ramadhan        │
│                                             │
│  ━━━━━━━━━━━━━━━━━━━━━━━━ 58%              │
│                                             │
└─────────────────────────────────────────────┘
```

---

## ✅ CEK HASIL

### Di Firebase Console:
```
1. Buka Firebase Console
2. Firestore Database
3. Collection: warga
4. Lihat data yang sudah digenerate
```

### Di Aplikasi:
```
1. Buka aplikasi utama
2. Menu: Data Warga > Data Penduduk
3. Lihat list warga
4. Test fitur search & filter
```

---

## 🗑️ CARA HAPUS DATA

```
1. Di aplikasi generator
2. Klik tombol "Hapus Semua Data" (merah)
3. Konfirmasi
4. Tunggu proses selesai
```

---

## 🎯 KEUNGGULAN

```
✨ No Manual Input       →  100% otomatis
✨ Data Realistis        →  Sesuai umur & status
✨ Relasi Konsisten      →  Keluarga terstruktur
✨ Firestore Ready       →  Langsung ke database
✨ Easy to Use           →  UI sederhana
✨ Fast                  →  1-5 menit untuk 300 data
✨ Customizable          →  Mudah dimodifikasi
✨ Delete Feature        →  Bisa reset data
```

---

## 🛠️ KUSTOMISASI (OPSIONAL)

### Ubah Jumlah Keluarga:
```dart
// Di generate_dummy_penduduk.dart baris ~270
final jumlahKeluarga = 10 + Random().nextInt(6); // 10-15 keluarga
```

### Ubah RT/RW:
```dart
// Baris ~267-268
final rts = ['001', '002', '003', '004', '005', '006'];
final rws = ['001', '002', '003', '004'];
```

### Ubah Jumlah Anak:
```dart
// Baris ~211
final jumlahAnak = random.nextInt(3); // 0-2 anak
```

---

## ⚠️ CATATAN PENTING

```
⚠️  Data dummy untuk testing only
⚠️  NIK/KK random (tidak valid)
⚠️  Backup data lama sebelum generate
⚠️  Firestore rules harus allow write
⚠️  Butuh internet connection
```

---

## 📞 TROUBLESHOOTING

### Problem: Firebase not initialized
```bash
Solution: flutter pub get
```

### Problem: Permission denied
```
Solution: Cek Firestore Rules
```

### Problem: Data tidak muncul
```
Solution: 
- Hot reload (r)
- Hot restart (R)
- Cek Firebase Console
```

---

## 🎉 SIAP DIGUNAKAN!

```
╔══════════════════════════════════════════════╗
║                                              ║
║    Semua sudah siap!                         ║
║    Tinggal run dan generate!                 ║
║                                              ║
║    🚀 Happy Coding! 🎯                        ║
║                                              ║
╚══════════════════════════════════════════════╝
```

---

**Version**: 1.0.0  
**Status**: ✅ Ready to Use  
**Created**: November 2025

