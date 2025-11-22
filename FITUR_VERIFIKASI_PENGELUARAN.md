# 🎯 FITUR VERIFIKASI PENGELUARAN

## 📋 Deskripsi
Fitur verifikasi pengeluaran memungkinkan **Admin** dan **Bendahara** untuk memverifikasi atau menolak laporan pengeluaran yang diajukan.

## 🔑 Lokasi Tombol Verifikasi

### **Tombol Floating Action Button (FAB) - Kanan Bawah**
Tombol verifikasi berwarna **HIJAU** dengan ikon ✅ akan muncul di **KANAN BAWAH** layar dengan kondisi:

1. ✅ **User adalah Admin atau Bendahara**
2. ✅ **Tombol SELALU muncul** (tidak peduli ada pengeluaran menunggu atau tidak)
3. ✅ Jika ada pengeluaran menunggu, akan ada **badge merah** dengan jumlahnya

**Tampilan:**
```
┌─────────────────────────┐
│                         │
│  Kelola Pengeluaran     │
│                         │
│  [Daftar Pengeluaran]   │
│                         │
│                         │
│              ┌──────────┐ <- FAB HIJAU
│              │ ✓ Verifi │    "Verifikasi"
│              │   kasi   │    atau "Verifikasi (5)"
│              └──────────┘
└─────────────────────────┘
```

## 🎨 Cara Kerja

### 1️⃣ **Klik Tombol Verifikasi**
- Ketika Admin/Bendahara klik tombol **"Verifikasi"** di kanan bawah
- Bottom sheet akan **muncul dari bawah** dengan animasi slide up
- Bottom sheet bisa di-drag (geser) ke atas/bawah

### 2️⃣ **Bottom Sheet Muncul**
Bottom sheet menampilkan:
- **Header hijau** dengan judul "Verifikasi Pengeluaran"
- **Jumlah pengeluaran** yang menunggu verifikasi
- **Daftar pengeluaran** dengan status "Menunggu"

### 3️⃣ **Card Pengeluaran**
Setiap card pengeluaran menampilkan:
- 🏷️ Kategori (dengan warna berbeda)
- 📝 Nama pengeluaran
- 💰 Nominal
- 📅 Tanggal
- 👤 Penerima (jika ada)
- 📄 Deskripsi (jika ada)
- ✅ Tombol **"Verifikasi"** (hijau)
- ❌ Tombol **"Tolak"** (merah)

### 4️⃣ **Aksi Verifikasi**
Ketika klik **"Verifikasi"** atau **"Tolak"**:
1. Dialog loading muncul (dengan animasi)
2. Status pengeluaran diupdate di Firestore:
   - ✅ **"Terverifikasi"** - jika disetujui
   - ❌ **"Ditolak"** - jika ditolak
3. Snackbar sukses muncul di bawah
4. Total pengeluaran otomatis diperbarui

## 🎯 Status Pengeluaran

### Status yang tersedia:
1. **🟡 Menunggu** - Baru dibuat, belum diverifikasi
2. **🟢 Terverifikasi** - Sudah disetujui oleh Admin/Bendahara
3. **🔴 Ditolak** - Ditolak oleh Admin/Bendahara

## 👥 Role & Permission

### **Admin**
- ✅ Dapat memverifikasi/menolak pengeluaran
- ✅ Dapat melihat tombol verifikasi
- ❌ Tidak bisa menambah/edit/hapus pengeluaran

### **Bendahara**
- ✅ Dapat memverifikasi/menolak pengeluaran
- ✅ Dapat menambah pengeluaran (tombol di header)
- ✅ Dapat edit pengeluaran
- ✅ Dapat hapus pengeluaran

## 🎨 Desain UI

### Warna Kategori:
- 🔴 **Operasional** - `#EB5757`
- 🟠 **Infrastruktur** - `#F59E0B`
- 🔵 **Utilitas** - `#3B82F6`
- 🟣 **Kegiatan** - `#8B5CF6`
- 🟢 **Administrasi** - `#10B981`

### Tombol Verifikasi FAB:
- Warna: `#10B981` (Hijau)
- Icon: `verified_rounded`
- Badge: `#EF4444` (Merah) - jika ada pending

## 📱 Lokasi File

### Main Page:
```
lib/features/keuangan/kelola_pengeluaran/kelola_pengeluaran_page.dart
```

### Widget Card:
```
lib/features/keuangan/kelola_pengeluaran/widgets/pengeluaran_card.dart
```

### Widget Header:
```
lib/features/keuangan/kelola_pengeluaran/widgets/pengeluaran_header.dart
```

### Service:
```
lib/core/services/pengeluaran_service.dart
```

### Provider:
```
lib/core/providers/pengeluaran_provider.dart
```

### Model:
```
lib/core/models/pengeluaran_model.dart
```

## 🔧 Troubleshooting

### ❓ **Tombol verifikasi tidak muncul?**
**Jawaban:**
1. Pastikan Anda login sebagai **Admin** atau **Bendahara**
2. Cek role di `AuthProvider` - `userRole == 'Admin'` atau `userRole == 'Bendahara'`
3. Tombol ada di **KANAN BAWAH** layar (Floating Action Button)
4. Tombol berwarna **HIJAU** dengan icon ✓

### ❓ **Bottom sheet tidak muncul?**
**Jawaban:**
1. Pastikan ada data pengeluaran di Firestore
2. Cek koneksi internet
3. Cek console untuk error

### ❓ **Verifikasi tidak berhasil?**
**Jawaban:**
1. Cek Firestore rules - pastikan Admin/Bendahara punya akses write
2. Cek console log untuk error
3. Pastikan ID pengeluaran valid

## 🚀 Demo Flow

```
1. Login sebagai Admin/Bendahara
   ↓
2. Buka "Kelola Pengeluaran"
   ↓
3. Lihat tombol HIJAU "Verifikasi" di kanan bawah (dengan badge jika ada pending)
   ↓
4. Klik tombol "Verifikasi"
   ↓
5. Bottom sheet muncul dari bawah
   ↓
6. Lihat daftar pengeluaran yang menunggu
   ↓
7. Klik "Verifikasi" (hijau) atau "Tolak" (merah)
   ↓
8. Loading muncul
   ↓
9. Status diupdate
   ↓
10. Snackbar sukses muncul ✓
```

## ✨ Fitur Tambahan

### 1. **Filter Status**
Di bawah search bar ada chip filter:
- Semua
- Menunggu
- Terverifikasi  
- Ditolak

### 2. **Badge Notifikasi**
FAB verifikasi menampilkan badge merah dengan jumlah pengeluaran menunggu

### 3. **Loading Animation**
Dialog loading muncul saat proses verifikasi

### 4. **Snackbar Feedback**
Snackbar muncul setelah berhasil/gagal verifikasi

### 5. **Bottom Sheet Draggable**
Bottom sheet bisa di-drag naik/turun

## 📞 Support
Jika ada pertanyaan atau masalah, hubungi developer team.

---
**Last Updated:** 22 November 2025
**Version:** 1.0.0

