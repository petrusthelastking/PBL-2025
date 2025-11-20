# 🎲 DUMMY DATA GENERATOR - PENGELUARAN

Script untuk generate data dummy pengeluaran ke Firestore agar dashboard terlihat penuh dengan data.

---

## 📦 Files Created:

1. **`lib/generate_dummy_pengeluaran.dart`** - Core generator logic
2. **`lib/test_generate_pengeluaran.dart`** - UI page untuk generate
3. **`run_generate_pengeluaran.bat`** - Batch file untuk run dengan 1 klik

---

## 🚀 Cara Menggunakan:

### **Option 1: Via Batch File (RECOMMENDED)**

1. Double-click file **`run_generate_pengeluaran.bat`**
2. App akan terbuka dengan UI generator
3. Pilih jumlah data (10-100 records)
4. Klik **"Generate Data"**
5. Tunggu sampai selesai
6. Check Firestore console

### **Option 2: Via Command Line**

```bash
flutter run -d windows -t lib/test_generate_pengeluaran.dart
```

### **Option 3: Via Code (Manual)**

Tambahkan di main.dart atau file manapun:

```dart
import 'generate_dummy_pengeluaran.dart';

// Generate 50 records
await GenerateDummyPengeluaran.generate(count: 50);

// Delete dummy data only
await GenerateDummyPengeluaran.deleteDummyOnly();

// Delete all pengeluaran data
await GenerateDummyPengeluaran.deleteAll();
```

---

## 📊 Data yang Dihasilkan:

### **Struktur Data:**

```dart
{
  'name': 'Pembelian Alat Kebersihan 1',
  'category': 'Operasional',
  'nominal': 500000.0,
  'deskripsi': 'Pembelian untuk kebutuhan kebersihan lingkungan RT',
  'tanggal': Timestamp,
  'status': 'Terverifikasi',
  'penerima': 'Toko Makmur Jaya',
  'createdBy': 'system_generator@admin.com',
  'createdAt': Timestamp,
  'updatedAt': Timestamp,
  'isActive': true,
  'bukti': null,
}
```

### **Karakteristik Data:**

| Property | Value |
|----------|-------|
| **Jumlah Default** | 50 records (adjustable 10-100) |
| **Date Range** | Last 6 months |
| **Nominal Range** | Rp 50.000 - Rp 5.000.000 |
| **Categories** | 6 types |
| **Status Distribution** | 70% Terverifikasi, 20% Menunggu, 10% Ditolak |

### **Categories:**

1. **Operasional** - Kegiatan operasional harian
2. **Infrastruktur** - Perbaikan dan pembangunan
3. **Utilitas** - Listrik, air, internet
4. **Kegiatan** - Event dan acara warga
5. **Administrasi** - Biaya administrasi
6. **Lainnya** - Pengeluaran lain-lain

### **Sample Names:**

- Pembelian Alat Kebersihan
- Perbaikan Jalan Utama
- Pembayaran Listrik Bulanan
- Kegiatan 17 Agustus
- Biaya Administrasi
- Pembelian ATK
- Perbaikan Pagar
- Pembayaran Air PDAM
- Kegiatan Posyandu
- Pembelian Lampu Jalan
- Dan 10 lainnya...

### **Sample Penerima:**

- Toko Makmur Jaya
- CV. Karya Mandiri
- PT. Listrik Negara
- PDAM Kota
- Warung Pak Budi
- Dan 15 lainnya...

---

## 🎯 Features:

### **1. Generate Dummy Data** ✅
- Generate 10-100 records sekaligus
- Data tersebar dalam 6 bulan terakhir
- Realistic nominal dan kategori
- Auto timestamp

### **2. Delete Dummy Data** ✅
- Hapus hanya dummy data (by createdBy)
- Tidak menghapus data real user
- Confirmation dialog

### **3. Delete All Data** ⚠️
- Hapus semua data pengeluaran
- USE WITH CAUTION!
- Untuk reset database

---

## 📱 UI Generator:

### **Components:**

- **Slider**: Pilih jumlah data (10-100)
- **Generate Button**: Create dummy data
- **Delete Button**: Remove dummy data
- **Status Display**: Show progress & result
- **Info Panel**: Show data characteristics

### **States:**

- ✅ **Ready**: Siap generate
- ⏳ **Generating**: Sedang proses
- ✅ **Success**: Data berhasil dibuat
- ❌ **Error**: Ada kesalahan

---

## 🔥 Firestore Impact:

### **Before Generate:**
```
Collection: pengeluaran
Documents: 0-5 (manual entries)
```

### **After Generate (50 records):**
```
Collection: pengeluaran
Documents: 50-55
Storage: ~50KB
Read Operations: 50
Write Operations: 50
```

### **Cost Estimation:**
- Write: 50 operations = Free tier OK
- Read: When fetching = Depends on usage
- Storage: Minimal (~50KB for 50 records)

---

## ⚠️ Important Notes:

### **1. Identifier:**
```dart
'createdBy': 'system_generator@admin.com'
```
Semua dummy data punya identifier ini, sehingga bisa dihapus tanpa menghapus data real.

### **2. Date Distribution:**
Data tersebar merata dalam 6 bulan terakhir untuk simulasi data historis yang realistis.

### **3. Status Distribution:**
- 70% Terverifikasi (untuk calculation)
- 20% Menunggu (untuk approval flow)
- 10% Ditolak (untuk variety)

### **4. Performance:**
- 50 records: ~5-10 seconds
- 100 records: ~10-20 seconds
- Depends on internet speed

---

## 🧹 Cleanup:

### **Delete Dummy Only:**
```dart
await GenerateDummyPengeluaran.deleteDummyOnly();
```
Hanya hapus data dengan `createdBy = 'system_generator@admin.com'`

### **Delete All:**
```dart
await GenerateDummyPengeluaran.deleteAll();
```
Hapus SEMUA data pengeluaran (⚠️ CAREFUL!)

---

## 📈 Use Cases:

### **1. Development:**
- Test UI dengan banyak data
- Test pagination
- Test filter & search
- Test export feature

### **2. Demo:**
- Show dashboard penuh data
- Demo ke client/stakeholder
- Presentasi fitur

### **3. Testing:**
- Performance testing
- Load testing
- Calculation testing
- Export testing

---

## 🎨 UI Screenshots:

### **Generator Page:**
```
┌─────────────────────────────────────┐
│  Generate Dummy Pengeluaran         │
├─────────────────────────────────────┤
│  Script ini akan membuat data dummy │
│  untuk collection pengeluaran...    │
│                                     │
│  Jumlah Data: [━━━━━●━━━] 50       │
│                                     │
│  [Generate Data]                    │
│  [Delete Dummy Data]                │
│                                     │
│  Status:                            │
│  ┌─────────────────────────────┐   │
│  │ Generating 50 records...    │   │
│  │ ✅ Success! 50 records...   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ℹ️ Info:                           │
│  • Data dalam 6 bulan terakhir     │
│  • Nominal: Rp 50k - 5jt           │
│  • 6 Kategori tersedia             │
└─────────────────────────────────────┘
```

---

## ✅ Testing Checklist:

**Before Generate:**
- [ ] Check current pengeluaran count
- [ ] Backup if needed
- [ ] Decide on record count

**Generate:**
- [ ] Run generator
- [ ] Wait for completion
- [ ] Check Firestore console
- [ ] Verify data structure

**After Generate:**
- [ ] Test Keuangan page
- [ ] Verify totals update
- [ ] Test filters
- [ ] Test export
- [ ] Check percentages

**Cleanup:**
- [ ] Delete dummy data when done
- [ ] Verify only dummy deleted
- [ ] Check real data intact

---

## 🚀 Quick Start:

1. **Generate Data:**
   ```bash
   run_generate_pengeluaran.bat
   ```

2. **Check Firestore:**
   ```
   https://console.firebase.google.com
   → Firestore Database
   → pengeluaran collection
   ```

3. **Test Dashboard:**
   ```
   Open app → Keuangan page
   → See dynamic totals
   → See realistic percentages
   ```

4. **Export Test:**
   ```
   Keuangan page → Cetak button
   → Choose format
   → Verify data in export
   ```

---

## 🎉 Result:

**After generating 50 records:**

### **Keuangan Dashboard:**
- ✅ Total Pengeluaran: ~Rp 50.000.000 - 150.000.000
- ✅ Chart percentage: Calculated from real data
- ✅ Growth: Based on date distribution
- ✅ List: 50 items dengan filter & search

### **Export:**
- ✅ Excel: 50 rows + header
- ✅ PDF: Multi-page dengan total
- ✅ CSV: 50 lines ready to import

### **Performance:**
- ✅ Page load: Fast (Firebase indexed)
- ✅ Filter: Instant
- ✅ Search: Real-time
- ✅ Export: 2-5 seconds

---

## 📝 Notes:

1. **Dummy data** dapat dihapus kapan saja tanpa mempengaruhi data real
2. **Generate ulang** jika perlu data lebih banyak
3. **Customize** nominal, kategori, atau date range di code
4. **Test thoroughly** sebelum deploy ke production

---

**Created**: November 20, 2025  
**Version**: 1.0.0  
**Status**: ✅ Ready to Use

🎲 **Happy Testing!** 🚀

