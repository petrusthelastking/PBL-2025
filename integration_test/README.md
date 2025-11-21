# 🧪 Integration Tests (E2E Tests)

Folder ini berisi **End-to-End (E2E) Tests** untuk aplikasi JAWARA.

## ⚠️ PENTING - BACA INI DULU!

**Test AKAN GAGAL jika user test tidak ada di Firestore!**

### 🔴 WAJIB: Setup User Test Dulu!

Sebelum run test, **HARUS** buat user test di Firestore:

```
Collection: users
Document: (any ID)

Fields:
  email: "admin@jawara.com"
  password: "admin123"
  status: "approved"      ← HARUS "approved"!
  role: "admin"
  nama: "Admin Test"
```

**📖 Panduan lengkap:** `SETUP_USER_TEST.md` ⭐ **BACA INI DULU!**

---

## 🚀 Cara Menjalankan Tests

### Quick Start (3 Langkah):

#### 1. Setup User Test (Sekali saja)
- Buka Firebase Console → Firestore
- Collection `users` → Add document
- Isi fields seperti di atas
- **Detail:** Lihat `SETUP_USER_TEST.md`

#### 2. Run Test
```bash
# Option A: Batch script (TERMUDAH)
run_login_test.bat
# Pilih: 5. Run SIMPLE test

# Option B: Manual command
flutter run -d chrome integration_test/auth/login_test_simple.dart
```

#### 3. Lihat Hasil
- Console akan menampilkan progress dengan emoji
- ✅ = Success, ❌ = Failed

---

## 📁 Struktur Folder

```
integration_test/
├── README.md                    # Dokumentasi ini
├── auth/                        # Tests untuk Authentication
│   ├── login_test.dart         # Test login flow
│   └── register_test.dart      # Test register flow
├── dashboard/                   # Tests untuk Dashboard
│   └── dashboard_test.dart     # Test dashboard flow
├── warga/                       # Tests untuk Data Warga
│   └── warga_crud_test.dart    # Test CRUD warga
├── tagihan/                     # Tests untuk Tagihan
│   └── tagihan_test.dart       # Test tagihan flow
├── helpers/                     # Helper functions & utilities
│   ├── test_helper.dart        # Common test helpers
│   ├── mock_data.dart          # Mock data generator
│   └── firebase_helper.dart    # Firebase test helpers
└── pages/                       # Page Object Models
    ├── login_page.dart         # Login page object
    ├── dashboard_page.dart     # Dashboard page object
    └── ...
```

## 🚀 Cara Menjalankan Tests

### Run Semua Integration Tests
```bash
flutter test integration_test
```

### Run Test Spesifik (Login Only)
```bash
flutter test integration_test/auth/login_test.dart
```

### Run dengan Device Spesifik
```bash
flutter test integration_test --device-id=<device_id>
```

### Run di Chrome (Web)
```bash
flutter test integration_test/auth/login_test.dart --platform chrome
```

### Run dengan Verbose Output
```bash
flutter test integration_test -v
```

## 📝 Cara Menulis Test Baru

1. **Buat file test** di folder yang sesuai
2. **Import dependencies** yang diperlukan
3. **Setup IntegrationTestWidgetsFlutterBinding**
4. **Tulis test cases** dengan struktur:
   ```dart
   void main() {
     IntegrationTestWidgetsFlutterBinding.ensureInitialized();
     
     group('Feature Name Tests', () {
       testWidgets('should do something', (tester) async {
         // Arrange - Setup
         // Act - Execute
         // Assert - Verify
       });
     });
   }
   ```

## 🎯 Test Coverage Target

- **Critical Paths:** 100% (Auth, Dashboard, Warga CRUD)
- **Secondary Features:** 80%
- **Optional Features:** 60%

## 📊 Test Reports

Test results akan tersimpan di:
- Console output
- Coverage report: `coverage/`
- Screenshots (jika ada error): `integration_test/screenshots/`

## ⚠️ Troubleshooting

### Test Gagal karena Timeout
```dart
await tester.pumpAndSettle(const Duration(seconds: 10));
```

### Widget Tidak Ditemukan
- Pastikan widget sudah di-render
- Gunakan `Key` untuk reliable finding
- Check dengan `await tester.pumpAndSettle()`

### Firebase Connection Error
- Pastikan Firebase sudah diinisialisasi
- Check internet connection
- Verify Firebase configuration

## 📚 Resources

- [Flutter Integration Testing Docs](https://docs.flutter.dev/testing/integration-tests)
- [Provider Testing Guide](https://pub.dev/packages/provider#testing)
- [Firebase Test Lab](https://firebase.google.com/docs/test-lab)

---

**Last Updated:** November 21, 2025  
**Maintained by:** PBL 2025 Team

