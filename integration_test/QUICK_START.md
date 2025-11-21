# ⚡ QUICK START - E2E Testing Login

## 🎯 Test yang Sudah Dibuat

✅ **Login Flow E2E Test** sudah siap digunakan!

**File:** `integration_test/auth/login_test.dart`

**Test Cases (7 scenarios):**
1. ✅ TC-AUTH-001: Login dengan kredensial valid
2. ✅ TC-AUTH-002: Login dengan email tidak terdaftar
3. ✅ TC-AUTH-003: Login dengan password salah
4. ✅ TC-AUTH-004: Login dengan email kosong
5. ✅ TC-AUTH-005: Login dengan password kosong
6. ✅ TC-AUTH-006: Login dengan email & password kosong
7. ✅ TC-AUTH-007: Login dengan email format invalid

## 🚀 Cara Cepat Menjalankan Test

### 1. Install Dependencies (Sekali saja)
```bash
flutter pub get
```

### 2. Run Test di Chrome (Tercepat)
```bash
flutter run -d chrome integration_test/auth/login_test.dart
```

### 3. Run Test di Windows Desktop
```bash
flutter run -d windows integration_test/auth/login_test.dart
```

### 4. Atau Gunakan Batch Script (Termudah)
```bash
run_login_test.bat
```

⚠️ **PENTING:** Jangan gunakan `flutter test`! Gunakan `flutter run` untuk integration test.

Baca: `CARA_MENJALANKAN_YANG_BENAR.md` untuk penjelasan lengkap.

## 📂 Struktur Folder yang Sudah Dibuat

```
integration_test/
├── README.md                           # Dokumentasi lengkap
├── auth/
│   ├── login_test.dart                # ✅ Test utama
│   └── HOW_TO_RUN.md                  # Panduan detail
├── helpers/
│   ├── test_helper.dart               # Helper functions
│   └── mock_data.dart                 # Data untuk testing
└── pages/
    └── login_page.dart                # Page Object Model
```

## 🎓 Cara Belajar dari Test ini

### 1. Baca Test Code
Mulai dari: `integration_test/auth/login_test.dart`

Struktur test:
```dart
testWidgets('Test description', (tester) async {
  // ARRANGE - Setup
  // ACT - Execute action
  // ASSERT - Verify result
});
```

### 2. Pahami Helper Functions
File: `integration_test/helpers/test_helper.dart`

Contoh:
- `skipIntroScreens()` - Skip splash & onboarding
- `navigateToLoginPage()` - Navigate ke login
- `enterTextByLabel()` - Isi form field

### 3. Pahami Page Object Pattern
File: `integration_test/pages/login_page.dart`

Benefits:
- Reusable code
- Easy maintenance
- Clear separation

## 🔧 Modifikasi Test

### Tambah Test Case Baru

```dart
testWidgets('TC-AUTH-XXX: Deskripsi test', (tester) async {
  TestHelper.printTestSection('TC-AUTH-XXX: ...');
  
  // ARRANGE
  app.main();
  await tester.pumpAndSettle();
  await TestHelper.skipIntroScreens(tester);
  await TestHelper.navigateToLoginPage(tester);
  
  // ACT
  final loginPage = LoginPageObject(tester);
  await loginPage.login(email: '...', password: '...');
  
  // ASSERT
  loginPage.verifyErrorMessage('...');
});
```

### Update Mock Data

Edit: `integration_test/helpers/mock_data.dart`

```dart
static const Map<String, String> myTestData = {
  'email': 'mytest@test.com',
  'password': 'mypassword',
};
```

## 📊 Expected Results

Saat run test, output akan seperti:
```
🔐 Login Flow E2E Tests
  ✅ TC-AUTH-001: Login dengan kredensial valid (15.2s)
  ✅ TC-AUTH-002: Login dengan email tidak terdaftar (8.5s)
  ✅ TC-AUTH-003: Login dengan password salah (8.3s)
  ✅ TC-AUTH-004: Login dengan email kosong (6.1s)
  ✅ TC-AUTH-005: Login dengan password kosong (6.0s)
  ✅ TC-AUTH-006: Login dengan email dan password kosong (5.8s)
  ✅ TC-AUTH-007: Login dengan format email invalid (7.2s)

🎨 Login Page UI Elements Tests
  ✅ TC-AUTH-UI-001: Semua elemen UI harus terlihat (4.5s)

✅ All tests passed! (8 tests, 62.6s)
```

## ⚠️ Catatan Penting

### 1. Test Data
Pastikan di Firestore ada user dengan credentials:
- Email: `admin@jawara.com`
- Password: `admin123`

### 2. Internet Connection
Test butuh koneksi internet untuk Firebase.

### 3. First Run Might Be Slow
Test pertama kali run bisa lambat (build + setup).
Test selanjutnya akan lebih cepat.

## 🎯 Next Steps

### Untuk Memperluas Testing:

1. **Tambah Register Test**
   - Buat `integration_test/auth/register_test.dart`
   - Copy pattern dari `login_test.dart`

2. **Tambah Dashboard Test**
   - Buat `integration_test/dashboard/dashboard_test.dart`
   - Test navigation & data display

3. **Tambah CRUD Test**
   - Buat `integration_test/warga/warga_crud_test.dart`
   - Test create, read, update, delete

## 📚 Resources

- 📖 Full Documentation: `integration_test/README.md`
- 📖 Detailed Guide: `integration_test/auth/HOW_TO_RUN.md`
- 🌐 Flutter Docs: https://docs.flutter.dev/testing/integration-tests

---

**🎉 Selamat! E2E Testing untuk Login sudah siap digunakan!**

Developed with ❤️ by PBL 2025 Team
Last Updated: November 21, 2025

