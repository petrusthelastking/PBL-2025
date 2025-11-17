# 🎯 GENERATOR DUMMY DATA MUTASI - VISUAL GUIDE

```
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   🔄  GENERATOR DUMMY DATA MUTASI                            ║
║                                                              ║
║   Generate data mutasi masuk, keluar, pindah rumah!         ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 🚀 CARA PALING MUDAH

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  1️⃣  Double-click:                                      │
│      📄 run_generator_mutasi.bat                        │
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
│  📦 30-50 Data Mutasi                                   │
│                                                         │
│  🟢 Mutasi Masuk                                        │
│     Dari kota lain → Perumahan                          │
│                                                         │
│  🔴 Keluar Perumahan                                    │
│     Dari perumahan → Kota lain                          │
│                                                         │
│  🔵 Pindah Rumah                                        │
│     Antar alamat dalam perumahan                        │
│                                                         │
│  📅 Tanggal: 6 bulan terakhir (random)                  │
│  💾 Target: Firestore collection "mutasi"               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🔄 3 JENIS MUTASI

### 1. 🟢 Mutasi Masuk
```
Kota Lain  ──────────────►  Perumahan

Contoh:
Ahmad Sudirman
Dari: Jakarta
Ke  : Jl. Merdeka No. 12, RT 001 RW 001
Alasan: Pindah kerja ke kota ini
```

### 2. 🔴 Keluar Perumahan
```
Perumahan  ──────────────►  Kota Lain

Contoh:
Budi Santoso
Dari: Jl. Sudirman No. 25, RT 002 RW 001
Ke  : Bandung
Alasan: Pindah kerja ke kota lain
```

### 3. 🔵 Pindah Rumah
```
Rumah A  ──────────────►  Rumah B
(dalam perumahan)

Contoh:
Citra Dewi
Dari: Jl. Thamrin No. 8, RT 003 RW 001
Ke  : Jl. Veteran No. 54, RT 003 RW 002
Alasan: Rumah lebih luas
```

---

## 📋 DATA YANG LENGKAP

```
┌──────────────────────┬──────────────────────────────┐
│  ✅ Nama             │  40 variasi nama             │
│  ✅ NIK              │  16 digit unik               │
│  ✅ Jenis Mutasi     │  3 pilihan                   │
│  ✅ Tanggal Mutasi   │  Random 6 bulan terakhir     │
│  ✅ Alamat Asal      │  Sesuai jenis mutasi         │
│  ✅ Alamat Tujuan    │  Sesuai jenis mutasi         │
│  ✅ Alasan Mutasi    │  10+ alasan per jenis        │
│  ✅ Status           │  Selesai                     │
│  ✅ Created By       │  system                      │
│  ✅ Timestamps       │  Auto-generated              │
└──────────────────────┴──────────────────────────────┘
```

---

## 🎯 CONTOH OUTPUT

```
╔═══════════════════════════════════════════════════════╗
║  📊 DATA MUTASI GENERATED                             ║
╠═══════════════════════════════════════════════════════╣
║                                                       ║
║  🟢 Mutasi Masuk #1                                   ║
║     👤 Ahmad Sudirman                                 ║
║     📍 Dari: Jakarta                                  ║
║     📍 Ke: Jl. Merdeka No. 12, RT 001 RW 001         ║
║     📅 Tanggal: 15 Oktober 2025                       ║
║     💬 Alasan: Pindah kerja ke kota ini               ║
║                                                       ║
║  🔴 Keluar Perumahan #2                               ║
║     👤 Budi Santoso                                   ║
║     📍 Dari: Jl. Sudirman No. 25, RT 002 RW 001      ║
║     📍 Ke: Bandung                                    ║
║     📅 Tanggal: 8 September 2025                      ║
║     💬 Alasan: Melanjutkan pendidikan                 ║
║                                                       ║
║  🔵 Pindah Rumah #3                                   ║
║     👤 Citra Dewi                                     ║
║     📍 Dari: Jl. Thamrin No. 8, RT 003 RW 001        ║
║     📍 Ke: Jl. Veteran No. 54, RT 003 RW 002         ║
║     📅 Tanggal: 22 November 2025                      ║
║     💬 Alasan: Rumah lebih luas                       ║
║                                                       ║
║  ... (30-50 data total)                               ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
```

---

## 🎨 UI APLIKASI GENERATOR

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                                    ┃
┃         🔄 Generator Data Dummy Mutasi            ┃
┃                                                    ┃
┃     ┌──────────────────────────────────────┐      ┃
┃     │  ℹ️  Status: Siap generate data       │      ┃
┃     └──────────────────────────────────────┘      ┃
┃                                                    ┃
┃     ┌──────────────────────────────────────┐      ┃
┃     │  ✅ Total: 0 mutasi                   │      ┃
┃     │  ↓ Masuk: 0      ↑ Keluar: 0         │      ┃
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
├── 📄 run_generator_mutasi.bat
│   └── Double-click untuk run (Windows)
│
├── 📄 QUICK_START_GENERATOR_MUTASI.md
│   └── Panduan singkat 3 langkah
│
├── 📁 lib/
│   └── 📄 generate_dummy_mutasi.dart
│       └── Main application code
│
└── 📁 README/
    └── 📄 CARA_GENERATE_DUMMY_MUTASI.md
        └── Tutorial lengkap + troubleshooting
```

---

## 🎮 CARA MENGGUNAKAN

### 🥇 Option 1: Batch File (TERMUDAH!)

```bash
# Cukup double-click:
run_generator_mutasi.bat
```

### 🥈 Option 2: Flutter Command

```bash
flutter run -d chrome lib/generate_dummy_mutasi.dart
```

### 🥉 Option 3: VS Code

```
1. Buka lib/generate_dummy_mutasi.dart
2. Tekan F5 atau Ctrl+F5
3. Pilih Chrome
```

---

## ⚡ PROSES GENERATE

```
1. Klik "Generate Data Dummy"
   ↓
2. Proses dimulai...
   ├── Generate mutasi #1 ✓
   ├── Generate mutasi #2 ✓
   ├── Generate mutasi #3 ✓
   ├── Generate mutasi #4 ✓
   └── ... (30-50 total)
   ↓
3. ✅ Selesai! 35 mutasi digenerate
   ├── Mutasi Masuk: 12
   └── Mutasi Keluar/Pindah: 23
```

---

## 📊 MONITORING PROGRESS

```
┌─────────────────────────────────────────────┐
│                                             │
│  🔄 Generating 35 data mutasi...            │
│                                             │
│  Generated 18 mutasi: Citra Dewi           │
│  (Pindah Rumah)                             │
│                                             │
│  ━━━━━━━━━━━━━━━━━━━━━━━━ 51%              │
│                                             │
└─────────────────────────────────────────────┘
```

---

## ✅ CEK HASIL

### Di Firebase Console:
```
1. Buka Firebase Console
2. Firestore Database
3. Collection: mutasi
4. Lihat data yang sudah digenerate
```

### Di Aplikasi:
```
1. Buka aplikasi utama
2. Menu: Data Warga > Data Mutasi
3. Lihat list mutasi masuk & keluar
4. Klik Details untuk lihat info lengkap
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
✨ 3 Jenis Mutasi        →  Lengkap & realistis
✨ Alamat Sesuai         →  Konsisten dengan jenis
✨ Alasan Realistis      →  10+ variasi per jenis
✨ Tanggal Random        →  6 bulan terakhir
✨ Firestore Ready       →  Langsung ke database
✨ Easy to Use           →  UI sederhana
✨ Fast                  →  30-50 data dalam 1-3 menit
```

---

## 🛠️ KUSTOMISASI (OPSIONAL)

### Ubah Jumlah Data:
```dart
// Di generate_dummy_mutasi.dart baris ~255
final jumlahData = 10 + random.nextInt(11); // 10-20 data
```

### Ubah Range Tanggal:
```dart
// Baris ~152
final daysAgo = random.nextInt(365); // 1 tahun
```

### Tambah Kota:
```dart
// Baris ~68-71
final List<String> _kotaList = [
  'Jakarta', 'Bandung', // existing
  'Bali', 'Lombok', // tambahan
];
```

---

## 📊 STATISTIK

```
┌───────────────────────────────────────┐
│                                       │
│  📈 HASIL GENERATE                    │
│                                       │
│  Total Data: 35 mutasi                │
│  ├─ 🟢 Mutasi Masuk: 12 (34%)         │
│  ├─ 🔴 Keluar Perumahan: 11 (31%)     │
│  └─ 🔵 Pindah Rumah: 12 (35%)         │
│                                       │
│  ⏱️  Waktu: 2 menit 15 detik          │
│  💾 Size: ~35KB di Firestore          │
│                                       │
└───────────────────────────────────────┘
```

---

## ⚠️ CATATAN PENTING

```
⚠️  Data dummy untuk testing only
⚠️  NIK random (tidak valid)
⚠️  Sesuaikan alamat dengan data real jika perlu
⚠️  Backup data lama sebelum generate
⚠️  Firestore rules harus allow write
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
- Cek collection name: "mutasi"
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

