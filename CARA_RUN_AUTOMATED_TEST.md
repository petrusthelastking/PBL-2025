# 🚀 CARA MENJALANKAN AUTOMATED TEST

## ✅ Test Sudah 100% AUTOMATED!

Test Data Penduduk sekarang **SEPENUHNYA OTOMATIS**:
- ✅ Auto-login dengan email & password
- ✅ Auto-navigate ke menu Data Penduduk
- ✅ Auto-CRUD operations (Create, Read, Update, Delete)
- ✅ **TIDAK PERLU KLIK APAPUN SECARA MANUAL!**

---

## 🎯 Pilihan Platform Testing

### 1️⃣ WEB (CHROME) - **RECOMMENDED!** ✨

**Paling mudah dan cepat untuk integration test**

```bash
# Double-click file ini:
run_automated_test_web.bat

# Atau jalankan command:
flutter test integration_test/data_penduduk/data_penduduk_crud_test.dart -d chrome
```

**Keuntungan:**
- ✅ Tidak perlu emulator
- ✅ Tidak perlu device fisik
- ✅ Cepat startup
- ✅ Visual debugging mudah

---

### 2️⃣ ANDROID (EMULATOR / DEVICE)

**Jika ingin test di Android**

```bash
# Double-click file ini:
run_automated_test_android.bat

# Atau jalankan command:
flutter test integration_test/data_penduduk/data_penduduk_crud_test.dart
```

**Persyaratan:**
- Emulator Android sudah running, ATAU
- Device Android sudah terhubung via USB dengan USB Debugging aktif

**Check device terkoneksi:**
```bash
flutter devices
```

---

### 3️⃣ WINDOWS (DESKTOP)

**Jika ingin test di Windows Desktop**

**Persyaratan:**
- Visual Studio 2019/2022 dengan C++ workload

```bash
# Install Visual Studio terlebih dahulu, lalu:
flutter test integration_test/data_penduduk/data_penduduk_crud_test.dart -d windows
```

**NOTE:** Jika ada error Visual Studio, lebih mudah gunakan **WEB** atau **ANDROID**!

---

## 🎬 Step-by-Step Tutorial

### METODE 1: WEB (TERMUDAH) ⭐

1. **Pastikan Chrome terinstall**
   ```bash
   # Check apakah Chrome terdeteksi
   flutter devices
   ```
   Harus ada output:
   ```
   Chrome (web) • chrome • web-javascript • Google Chrome ...
   ```

2. **Jalankan test**
   ```bash
   # Double-click file:
   run_automated_test_web.bat
   ```
   
   Atau manual:
   ```bash
   flutter drive --driver=test_driver/integration_test.dart --target=integration_test/data_penduduk/data_penduduk_crud_test.dart -d chrome
   ```
   
   **⚠️ PENTING:** Gunakan `flutter drive`, BUKAN `flutter test`!

3. **Tunggu test berjalan otomatis**
   - Chrome akan terbuka otomatis
   - App akan load otomatis
   - Test akan berjalan sendiri dari login sampai CRUD
   - **Jangan minimize/close window Chrome!**

4. **Lihat hasil di console**
   ```
   ✅ PHASE 1 COMPLETED: Auto-login successful!
   ✅ PHASE 2 COMPLETED: On Data Penduduk page!
   ✅ PHASE 3 COMPLETED: Data viewed successfully!
   ...
   🎉 ALL PHASES COMPLETED SUCCESSFULLY!
   ```

---

### METODE 2: ANDROID EMULATOR

1. **Start emulator terlebih dahulu**
   ```bash
   # Lihat emulator yang tersedia
   emulator -list-avds
   
   # Start emulator (ganti [NAME] dengan nama emulator Anda)
   emulator -avd [NAME]
   ```
   
   Atau buka Android Studio > AVD Manager > Start emulator

2. **Check emulator terkoneksi**
   ```bash
   flutter devices
   ```
   Harus ada output:
   ```
   Android Emulator • emulator-5554 • android • ...
   ```

3. **Jalankan test**
   ```bash
   # Double-click file:
   run_automated_test_android.bat
   ```
   
   Atau manual:
   ```bash
   flutter drive --driver=test_driver/integration_test.dart --target=integration_test/data_penduduk/data_penduduk_crud_test.dart
   ```

4. **Tunggu test berjalan**
   - App akan terinstall di emulator otomatis
   - Test akan berjalan sendiri
   - **Jangan close emulator!**

---

### METODE 3: ANDROID DEVICE FISIK

1. **Enable USB Debugging di device**
   - Settings > About Phone
   - Tap "Build Number" 7x untuk enable Developer Mode
   - Settings > Developer Options
   - Enable "USB Debugging"

2. **Hubungkan device ke PC via USB**

3. **Check device terkoneksi**
   ```bash
   flutter devices
   ```
   Harus muncul device Anda

4. **Jalankan test**
   ```bash
   flutter drive --driver=test_driver/integration_test.dart --target=integration_test/data_penduduk/data_penduduk_crud_test.dart
   ```

---

## 🎯 RECOMMENDED: Gunakan WEB!

**Untuk testing yang paling cepat dan mudah, gunakan CHROME/WEB:**

```bash
run_automated_test_web.bat
```

**Atau:**

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/data_penduduk/data_penduduk_crud_test.dart -d chrome
```

**⚠️ PENTING:** Gunakan `flutter drive`, BUKAN `flutter test`!  
`flutter test` tidak support web untuk integration test.

---

## 📊 Apa yang Terjadi Saat Test Berjalan?

### Phase 1: Auto-Login 🔐
```
🔐 PHASE 1: AUTO LOGIN
────────────────────────────────────────────────────────
  🔵 Starting application...
  ✅ App started
  
  🔵 Filling login credentials AUTOMATICALLY...
  📧 Email: admin@jawara.com
  🔑 Password: admin123
  
  🔵 Entering email...
  ✅ Email entered
  
  🔵 Entering password...
  ✅ Password entered
  
  🔵 Tapping login button...
  ✅ Login successful!

✅ PHASE 1 COMPLETED: Auto-login successful!
```

### Phase 2: Auto-Navigate 📍
```
📍 PHASE 2: NAVIGATE TO DATA PENDUDUK
────────────────────────────────────────────────────────
  🔵 Looking for Data Warga menu...
  📍 Method 1: Found "Data Warga" text, tapping...
  ✅ Navigated via text

✅ PHASE 2 COMPLETED: On Data Penduduk page!
```

### Phase 3-6: Auto-CRUD Operations ✨
```
📖 PHASE 3: READ - View Data Penduduk List
  📊 Current total: 5 penduduk
✅ PHASE 3 COMPLETED

➕ PHASE 4: CREATE - Tambah Penduduk Baru
  📝 Entering NIK: 32011700123456789
  📝 Entering Nama: E2E Test 1700123456789
  ✅ New penduduk added successfully!
✅ PHASE 4 COMPLETED

✏️ PHASE 5: UPDATE - Edit Data Penduduk
  ✅ Penduduk data updated successfully!
✅ PHASE 5 COMPLETED

🗑️ PHASE 6: DELETE - Hapus Data Penduduk
  ✅ Penduduk deleted successfully!
✅ PHASE 6 COMPLETED
```

### Final Summary 🎉
```
================================================================================
  🎉 ALL PHASES COMPLETED SUCCESSFULLY!
================================================================================

📊 TEST SUMMARY:
  ✅ Phase 1: Login - SUCCESS
  ✅ Phase 2: Navigate - SUCCESS
  ✅ Phase 3: READ (View) - SUCCESS
  ✅ Phase 4: CREATE (Add) - SUCCESS
  ✅ Phase 5: UPDATE (Edit) - SUCCESS
  ✅ Phase 6: DELETE (Remove) - SUCCESS

  🏆 100% CRUD OPERATIONS COMPLETED!
================================================================================
```

---

## ⚠️ Troubleshooting

### ❌ Error: No devices found
**Solution:**
```bash
# Gunakan Chrome:
flutter test integration_test/data_penduduk/data_penduduk_crud_test.dart -d chrome

# Atau start emulator dulu:
emulator -avd [EMULATOR_NAME]
```

### ❌ Error: Visual Studio toolchain
**Solution:**
- Jangan gunakan Windows desktop
- **Gunakan WEB (Chrome) sebagai gantinya!**

### ❌ Test timeout atau stuck
**Solution:**
- Pastikan internet connection aktif (untuk Firebase)
- Jangan minimize/close window test
- Increase timeout jika perlu

### ❌ Login gagal
**Solution:**
- Pastikan admin account ada di Firestore:
  ```
  Collection: users
  Document ID: [auto]
  Fields:
    email: "admin@jawara.com"
    password: [hashed password]
    role: "admin"
  ```

---

## 📝 Notes

1. **Test akan berjalan OTOMATIS** - jangan klik apapun!
2. **Jangan close window** saat test berjalan
3. **Internet connection** harus aktif untuk Firebase
4. **Chrome/Web** adalah pilihan termudah untuk testing
5. **Data test** dibuat dengan timestamp, jadi selalu unique

---

## 🎓 Advanced: Flutter Drive

Untuk test dengan more control (optional):

```bash
# Buat test driver terlebih dahulu (sudah ada di project)
# File: test_driver/integration_test.dart

# Jalankan dengan driver:
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/data_penduduk/data_penduduk_crud_test.dart \
  -d chrome
```

---

## ✅ Quick Start (TL;DR)

**Cara tercepat dan termudah:**

1. Double-click: `run_automated_test_web.bat`
2. Tunggu Chrome terbuka
3. Lihat test berjalan otomatis!
4. Check hasil di console

**SELESAI!** 🎉

---

**Happy Automated Testing! 🚀**

