# ⚠️ PENTING - SETUP USER TEST DULU!

## 🚨 MASALAH UTAMA

Test **AKAN GAGAL** jika user test tidak ada di Firestore!

Error yang terjadi:
```
Multiple exceptions (2) were detected
TC-AUTH-001: Login Flow - All Scenarios [E]
Test failed.
```

## ✅ SOLUSI: SETUP USER TEST DI FIRESTORE

### **WAJIB DILAKUKAN SEBELUM RUN TEST!**

#### Option 1: Via Firebase Console (RECOMMENDED) ⭐

1. **Buka Firebase Console**
   - Go to: https://console.firebase.google.com
   - Pilih project: `pbl-2025-35a1c`

2. **Buka Firestore Database**
   - Klik "Firestore Database" di sidebar
   - Klik "Start collection" atau pilih collection `users` jika sudah ada

3. **Add Document ke Collection `users`**
   
   **Klik "Add document"** dan isi:
   
   ```
   Document ID: (auto-generated) atau ketik manual
   
   Fields (SEMUA WAJIB):
   ─────────────────────────────────────────────
   Field Name          | Type   | Value
   ─────────────────────────────────────────────
   email               | string | admin@jawara.com
   password            | string | admin123
   status              | string | approved
   role                | string | admin
   nama                | string | Admin Test
   createdAt           | timestamp | (now)
   ─────────────────────────────────────────────
   ```

4. **Klik "Save"**

5. **Verify** - Pastikan document muncul di Firestore

#### Option 2: Via Aplikasi (Manual Registration)

1. **Run aplikasi normal (bukan test)**
   ```bash
   flutter run -d chrome
   ```

2. **Register akun baru**
   - Email: `admin@jawara.com`
   - Password: `admin123`
   - Nama: `Admin Test`

3. **Buka Firebase Console**
   - Firestore Database → Collection `users`
   - Cari document dengan email `admin@jawara.com`

4. **Update field `status`**
   - Klik document
   - Edit field `status`
   - Change dari `pending` ke `approved`
   - Save

---

## 🚀 SETELAH SETUP USER, RUN TEST

### Command:

```bash
# Option 1: Batch script
run_login_test.bat
# Pilih: 5. Run SIMPLE test

# Option 2: Manual
flutter run -d chrome integration_test/auth/login_test_simple.dart
```

---

## ✅ OUTPUT YANG DIHARAPKAN

### Jika User Sudah Ada & Setup Benar:

```
🔐 STARTING LOGIN E2E TEST
════════════════════════════════════════════════════════════

🔵 STEP 1: Starting application...
  ✅ Application started

🔵 STEP 2: Skipping intro screens...
  ✅ Splash screen finished
  ✅ Onboarding skipped

🔵 STEP 3: Navigating to Login page...
  ✅ Navigated to Login page

🔵 STEP 4: Checking Login page elements...
  ✅ Email field found
  ✅ Password field found
  ✅ Login button found

🔵 STEP 5: Attempting to fill login form...
  ✅ Email entered
  ✅ Password entered

🔵 STEP 6: Attempting to submit login...
  ✅ Login button tapped

🔵 STEP 7: Checking result...
  ✅ Successfully navigated to Dashboard!
  ✅ Dashboard elements found

════════════════════════════════════════════════════════════
  ✅ TEST RESULT: LOGIN SUCCESSFUL
════════════════════════════════════════════════════════════

✅ Test completed without exceptions
```

### Jika User Tidak Ada:

```
🔵 STEP 7: Checking result...
  ⚠️  Login failed with error
  ❌ Error: Email tidak ditemukan
  ℹ️  User "admin@jawara.com" not found in Firestore!

════════════════════════════════════════════════════════════
  ⚠️  TEST RESULT: LOGIN FAILED - USER SETUP REQUIRED
════════════════════════════════════════════════════════════

📝 ACTION REQUIRED:
   1. Buka Firebase Console → Firestore
   2. Collection: users
   3. Add Document dengan fields:
      - email: "admin@jawara.com"
      - password: "admin123"
      - status: "approved"
      - role: "admin"
      - nama: "Admin Test"
```

---

## 🔍 CHECKLIST SEBELUM RUN TEST

- [ ] ✅ User test sudah ada di Firestore
- [ ] ✅ Email: `admin@jawara.com`
- [ ] ✅ Password: `admin123`
- [ ] ✅ Status: `approved` (BUKAN "pending"!)
- [ ] ✅ Role: `admin`
- [ ] ✅ Internet connection OK
- [ ] ✅ Firebase project ID benar: `pbl-2025-35a1c`

---

## 📸 SCREENSHOT FIREBASE CONSOLE

Struktur yang benar di Firestore:

```
Firestore Database
└── users (collection)
    └── [auto-generated-id] (document)
        ├── email: "admin@jawara.com"
        ├── password: "admin123"
        ├── status: "approved"      ← PENTING!
        ├── role: "admin"
        ├── nama: "Admin Test"
        └── createdAt: [timestamp]
```

**CATATAN PENTING:**
- Field `status` HARUS `"approved"` (bukan "pending" atau "rejected")
- Field `email` HARUS persis `"admin@jawara.com"` (lowercase)
- Field `password` HARUS persis `"admin123"`

---

## ❓ FAQ

### Q: Test masih gagal meskipun user sudah ada?
**A:** Check:
1. Email spelling benar? (admin@jawara.com dengan lowercase)
2. Status = "approved"? (bukan "pending")
3. Password benar? (admin123)
4. Internet connection OK?

### Q: Dimana lihat Firebase Console?
**A:** https://console.firebase.google.com → Pilih project `pbl-2025-35a1c`

### Q: Apakah password harus di-hash?
**A:** TIDAK! Di projek ini password disimpan plain text (untuk simplicity). 
Cukup tulis `"admin123"` langsung.

### Q: Bisa pakai email lain?
**A:** TIDAK! Test hardcoded untuk email `admin@jawara.com`. 
Kalau mau ganti, edit file `lib/test_helpers/mock_data.dart`

---

## 🎯 SUMMARY

**LANGKAH WAJIB:**

1. **Setup user test di Firestore** (5 menit)
   - Buka Firebase Console
   - Collection: `users`
   - Add document dengan fields di atas

2. **Run test** (30 detik)
   ```bash
   flutter run -d chrome integration_test/auth/login_test_simple.dart
   ```

3. **Lihat hasil**
   - ✅ Login successful → Test PASS
   - ❌ Login failed → Check Firestore setup

---

**Tanpa setup user test, test PASTI GAGAL!**

**Setup dulu baru run test!** 🚀

---

**Last Updated:** November 21, 2025  
**Status:** User setup REQUIRED before running test

