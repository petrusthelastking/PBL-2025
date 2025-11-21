# 🧪 CARA MENJALANKAN E2E TEST - LOGIN

## 📋 Prerequisites

Sebelum menjalankan test, pastikan:
1. ✅ Flutter SDK sudah terinstall
2. ✅ Device/Emulator sudah running atau Chrome untuk web
3. ✅ Dependencies sudah diinstall (`flutter pub get`)
4. ✅ Firebase sudah dikonfigurasi dengan benar

## 🚀 Langkah-langkah Menjalankan Test

### 1️⃣ Install Dependencies

```bash
cd "C:\Peyimpanan Pribadi\Data D\New folder (2)\Semester 5\PBL 2025"
flutter pub get
```

### 2️⃣ Check Device yang Tersedia

```bash
flutter devices
```

Output akan menampilkan device yang tersedia:
```
Chrome (web)                 • chrome      • web-javascript • Google Chrome 120.0
Windows (desktop)            • windows     • windows-x64    • Microsoft Windows
Android SDK (emulator)       • emulator    • android        • Android 13
```

### 3️⃣ Run Login E2E Test

⚠️ **PENTING:** Integration test menggunakan `flutter run`, BUKAN `flutter test`!

#### Option A: Run di Chrome (Web) - RECOMMENDED untuk Testing Cepat
```bash
flutter run -d chrome integration_test/auth/login_test.dart
```

#### Option B: Run di Windows Desktop
```bash
flutter run -d windows integration_test/auth/login_test.dart
```

#### Option C: Run di Android Emulator
```bash
# Start emulator dulu
flutter emulators --launch <emulator_id>

# Run test
flutter run -d emulator-5554 integration_test/auth/login_test.dart
```

#### Option D: Gunakan Batch Script (Termudah)
```bash
run_login_test.bat
```
Pilih option 1 (Chrome) dari menu.

📖 **Penjelasan lengkap kenapa harus pakai `flutter run`:**  
Baca file: `integration_test/CARA_MENJALANKAN_YANG_BENAR.md`

### 4️⃣ Run Semua Integration Tests
```bash
flutter test integration_test
```

### 5️⃣ Run dengan Verbose Output (untuk Debugging)
```bash
flutter test integration_test/auth/login_test.dart -v
```

## 📊 Memahami Output Test

### ✅ Test Berhasil
```
00:01 +1: 🔐 Login Flow E2E Tests TC-AUTH-001: Login dengan kredensial valid harus berhasil
00:05 +2: 🔐 Login Flow E2E Tests TC-AUTH-002: Login dengan email tidak terdaftar
...
00:45 +8: All tests passed!
```

### ❌ Test Gagal
```
00:05 +1 -1: 🔐 Login Flow E2E Tests TC-AUTH-001: Login dengan kredensial valid
Expected: finds one widget
Actual: <zero widgets>
```

**Artinya:** Widget yang diharapkan tidak ditemukan. Bisa jadi:
- Widget belum muncul (perlu wait lebih lama)
- Selector salah
- Bug di aplikasi

## 🐛 Troubleshooting

### Problem 1: "No device available"
**Solution:**
```bash
# Untuk web
flutter config --enable-web

# Untuk desktop
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

### Problem 2: "Flutter SDK not found"
**Solution:**
```bash
flutter doctor
```
Fix semua issues yang muncul.

### Problem 3: Test Timeout
**Solution:** Increase timeout di test:
```dart
await tester.pumpAndSettle(const Duration(seconds: 10));
```

### Problem 4: Firebase Connection Error
**Solution:**
- Check internet connection
- Verify `firebase_options.dart` configuration
- Check Firestore rules

### Problem 5: Widget Not Found
**Solution:**
- Add more wait time: `await tester.pumpAndSettle()`
- Check widget selectors
- Use `find.byKey()` instead of `find.byType()` untuk reliable testing

## 📈 Test Coverage

Untuk generate test coverage report:

```bash
# Run tests dengan coverage
flutter test --coverage integration_test

# Generate HTML report (butuh lcov tools)
genhtml coverage/lcov.info -o coverage/html

# Open report
start coverage/html/index.html  # Windows
open coverage/html/index.html   # macOS
xdg-open coverage/html/index.html  # Linux
```

## 🎯 Test Scenarios yang Dicover

### ✅ Positive Tests
- [x] Login dengan kredensial valid → Success
- [x] UI elements semua visible

### ✅ Negative Tests
- [x] Login dengan email tidak terdaftar → Error
- [x] Login dengan password salah → Error
- [x] Login dengan email kosong → Validation error
- [x] Login dengan password kosong → Validation error
- [x] Login dengan email & password kosong → Validation error
- [x] Login dengan email format invalid → Validation error

## 📝 Tips untuk Development

### 1. Run Test saat Develop Feature Baru
```bash
# Run test secara berulang (watch mode tidak available, manual re-run)
flutter test integration_test/auth/login_test.dart
```

### 2. Run Specific Test Case
```dart
// Di file test, tambahkan skip untuk test lain:
testWidgets('TC-AUTH-001: ...', (tester) async {
  // test code
}, skip: false);

testWidgets('TC-AUTH-002: ...', (tester) async {
  // test code
}, skip: true);  // Skip test ini
```

### 3. Debug Mode
Tambahkan breakpoint di test code dan run dengan debugger IDE:
- VS Code: F5
- Android Studio: Shift+F9

### 4. Screenshot saat Error
Uncomment di `TestHelper.takeScreenshot()` untuk auto-capture saat error.

## 🔄 CI/CD Integration (Future)

Untuk integrate dengan GitHub Actions atau CI/CD pipeline:

```yaml
# .github/workflows/integration_test.yml
name: Integration Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test integration_test
```

## 📞 Support

Jika ada masalah:
1. Check dokumentasi Flutter: https://docs.flutter.dev/testing/integration-tests
2. Search di Stack Overflow
3. Ask team member

---

**Happy Testing! 🎉**

Last Updated: November 21, 2025

