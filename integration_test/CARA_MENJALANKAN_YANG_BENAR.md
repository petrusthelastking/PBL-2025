# ⚠️ CARA MENJALANKAN INTEGRATION TEST YANG BENAR

## 🚨 ERROR yang Sering Terjadi

Jika Anda mendapat error:
```
Error: Error when reading 'org-dartlang-app:///integration_test/auth/login_test.dart': 
File not found
```

**Penyebabnya:** Command `flutter test` TIDAK BISA digunakan untuk integration test!

---

## ✅ CARA YANG BENAR

Ada **2 cara** untuk menjalankan integration test:

### **Cara 1: Flutter Run (RECOMMENDED - Paling Mudah)**

Integration test di Flutter sebenarnya adalah aplikasi yang dijalankan dalam mode khusus, bukan unit test biasa.

#### Command:
```bash
# Chrome (Web)
flutter run -d chrome integration_test/auth/login_test.dart

# Windows Desktop
flutter run -d windows integration_test/auth/login_test.dart

# Android
flutter run -d <device_id> integration_test/auth/login_test.dart
```

#### Penjelasan:
- `flutter run` = Jalankan aplikasi
- `-d chrome` = Di device Chrome
- `integration_test/auth/login_test.dart` = File test yang akan dijalankan

### **Cara 2: Flutter Drive (Advanced)**

Ini cara official untuk integration test, tapi lebih kompleks.

#### Setup:
1. Buat file driver: `test_driver/integration_test.dart`
   ```dart
   import 'package:integration_test/integration_test_driver.dart';

   Future<void> main() => integrationDriver();
   ```

2. Run command:
   ```bash
   flutter drive \
     --driver=test_driver/integration_test.dart \
     --target=integration_test/auth/login_test.dart \
     -d chrome
   ```

---

## 🎯 QUICK START (Gunakan Ini!)

### **Option A: Gunakan Batch Script (Sudah Diperbaiki)**

```bash
# Double-click file ini:
run_login_test.bat

# Pilih option 1 (Chrome)
```

Script sudah saya update dengan command yang benar!

### **Option B: Manual Command (Copy-Paste)**

**Untuk Chrome (RECOMMENDED):**
```bash
flutter run -d chrome integration_test/auth/login_test.dart
```

**Untuk Windows Desktop:**
```bash
flutter run -d windows integration_test/auth/login_test.dart
```

**Untuk Android Emulator:**
```bash
# 1. Check device ID dulu
flutter devices

# 2. Run test
flutter run -d emulator-5554 integration_test/auth/login_test.dart
```

---

## 📊 YANG AKAN TERJADI

Ketika Anda run integration test dengan `flutter run`:

1. **Aplikasi akan terbuka** (di Chrome/Windows/Android)
2. **Test akan berjalan otomatis** 
3. **Anda akan melihat:**
   - Splash screen muncul
   - Onboarding (kalau ada)
   - Navigate ke login page
   - Form diisi otomatis
   - Login button di-tap
   - Navigate ke dashboard (jika berhasil)
   - Atau error message (jika gagal)
4. **Hasil test akan muncul di console**
5. **Aplikasi akan tetap terbuka** (Anda bisa close manual atau tunggu selesai)

---

## 🎮 INTERACTIVE MODE vs HEADLESS MODE

### Interactive Mode (Default)
```bash
flutter run -d chrome integration_test/auth/login_test.dart
```
- Aplikasi terbuka dan bisa dilihat
- Bagus untuk debugging
- Bisa lihat test berjalan real-time

### Headless Mode (Background)
Untuk headless Chrome:
```bash
flutter run -d chrome integration_test/auth/login_test.dart --headless
```
- Running di background
- Tidak ada UI yang terbuka
- Lebih cepat

---

## 🔧 TROUBLESHOOTING

### Problem 1: "No device available"
**Solution:**
```bash
# Enable web
flutter config --enable-web

# Enable desktop
flutter config --enable-windows-desktop

# Verify
flutter devices
```

### Problem 2: "Chrome not found"
**Solution:**
Install Chrome atau gunakan Windows desktop:
```bash
flutter run -d windows integration_test/auth/login_test.dart
```

### Problem 3: Test tidak muncul
**Solution:**
Pastikan file test ada di path yang benar:
```
integration_test/auth/login_test.dart
```

### Problem 4: "Failed to compile"
**Solution:**
```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Try again
flutter run -d chrome integration_test/auth/login_test.dart
```

---

## 📝 CARA MEMBACA OUTPUT

Saat test berjalan, console akan menampilkan:

```
Launching integration_test\auth\login_test.dart on Chrome...
Building application for the web...

🔵 [TestHelper] Skipping intro screens...
  ✅ Splash screen finished
  ✅ Onboarding skipped

🔵 [TestHelper] Navigating to Login page...
  ✅ Navigated to Login page

🔐 Performing login...
  Email: admin@jawara.com
  Password: ************
  📝 Entering email: admin@jawara.com
  ✅ Text entered successfully
  📝 Entering password: ************
  ✅ Text entered successfully
  👆 Tapping login button...
  ✅ Login button tapped

  🔍 Verifying navigation to Dashboard...
  ✅ Successfully navigated to Dashboard

✅ SUCCESS: Login dengan kredensial valid berhasil! ✅

All tests passed!
```

---

## 💡 TIPS PENTING

### Tip 1: Gunakan Chrome untuk Testing Cepat
Chrome paling cepat untuk development:
```bash
flutter run -d chrome integration_test/auth/login_test.dart
```

### Tip 2: Debug dengan VS Code
1. Open `integration_test/auth/login_test.dart`
2. Klik "Run" atau "Debug" di atas function `main()`
3. Select device (Chrome recommended)

### Tip 3: Hot Restart Tidak Bekerja
Integration test HARUS di-restart penuh setiap kali:
- Stop aplikasi (Ctrl+C)
- Run lagi dari awal

### Tip 4: Jangan Gunakan `flutter test`
**SALAH:** ❌
```bash
flutter test integration_test/auth/login_test.dart
```

**BENAR:** ✅
```bash
flutter run -d chrome integration_test/auth/login_test.dart
```

---

## 🎯 COMMAND CHEAT SHEET

```bash
# ============================================================================
# QUICK REFERENCE - COPY PASTE COMMANDS
# ============================================================================

# 1. CHECK DEVICES
flutter devices

# 2. RUN ON CHROME (FASTEST)
flutter run -d chrome integration_test/auth/login_test.dart

# 3. RUN ON WINDOWS
flutter run -d windows integration_test/auth/login_test.dart

# 4. RUN ON ANDROID
flutter run -d emulator-5554 integration_test/auth/login_test.dart

# 5. LIST EMULATORS
flutter emulators

# 6. LAUNCH EMULATOR
flutter emulators --launch <emulator_id>

# 7. CLEAN BUILD (if error)
flutter clean && flutter pub get
```

---

## 📚 ALTERNATIVE: Gunakan VS Code / Android Studio

### VS Code:
1. Install extension: "Flutter" & "Dart"
2. Open file: `integration_test/auth/login_test.dart`
3. Klik "Run" di atas `void main()`
4. Select device dari dropdown

### Android Studio:
1. Open file: `integration_test/auth/login_test.dart`
2. Klik icon ▶️ (Run) di gutter sebelah `void main()`
3. Select device

---

## ⚡ UPDATED BATCH SCRIPT

Script `run_login_test.bat` sudah saya update dengan command yang benar!

Sekarang bisa langsung digunakan:
```bash
run_login_test.bat
```

Pilih option 1 (Chrome) dan test akan berjalan dengan benar.

---

## ✅ VERIFICATION

Untuk memastikan semuanya bekerja:

```bash
# 1. Check Flutter
flutter doctor

# 2. Check devices
flutter devices

# 3. Enable web (jika belum)
flutter config --enable-web

# 4. Run test
flutter run -d chrome integration_test/auth/login_test.dart
```

Expected output:
- Aplikasi terbuka di Chrome
- Test berjalan otomatis
- Console menampilkan progress
- Hasil: "All tests passed!" ✅

---

## 🎉 SUMMARY

**CARA YANG SALAH (ERROR):**
```bash
flutter test integration_test/auth/login_test.dart  # ❌ SALAH
```

**CARA YANG BENAR:**
```bash
flutter run -d chrome integration_test/auth/login_test.dart  # ✅ BENAR
```

atau gunakan:
```bash
run_login_test.bat  # ✅ Script sudah diperbaiki
```

---

**Sekarang coba lagi dengan command yang benar! 🚀**

Last Updated: November 21, 2025

