# 🧪 Testing Instructions - Login System

## 🎯 Test Objective

Memastikan login system berfungsi dengan benar dan **tidak lagi auto-login** tanpa validasi.

## 📋 Pre-Test Setup

### 1. Pastikan Admin User Sudah Ada

**Check di Firebase Console:**
1. Buka https://console.firebase.google.com
2. Pilih project → Firestore Database
3. Cari collection `users`
4. Pastikan ada dokumen dengan:
   - email: `admin@jawara.com`
   - password: `admin123`
   - status: `approved`

**Atau create via script:**
```dart
// Di main.dart, uncomment:
await createAdminUser();
// Run app, lalu comment lagi
```

### 2. Hot Restart App

**Penting**: Gunakan **Hot Restart**, bukan Hot Reload
- Terminal: Tekan `R` (kapital)
- VS Code: `Ctrl+Shift+F5`
- Android Studio: Klik icon "Hot Restart"

## 🧪 Test Cases

### Test 1: Login dengan Kredensial Valid ✅

**Steps:**
1. Buka app
2. Tunggu splash screen selesai
3. Swipe onboarding page (atau skip)
4. Klik tombol **Login**
5. Input:
   - Email: `admin@jawara.com`
   - Password: `admin123`
6. Klik tombol **Login**

**Expected Result:**
- ✅ Loading indicator muncul
- ✅ Redirect ke Dashboard
- ✅ Tidak ada error message

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, error: _______________

---

### Test 2: Login dengan Email Salah ❌

**Steps:**
1. Di login page, input:
   - Email: `wrong@email.com`
   - Password: `admin123`
2. Klik tombol **Login**

**Expected Result:**
- ✅ Muncul dialog error
- ✅ Message: "Email atau password salah"
- ✅ Tetap di login page

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, behavior: _______________

---

### Test 3: Login dengan Password Salah ❌

**Steps:**
1. Di login page, input:
   - Email: `admin@jawara.com`
   - Password: `wrongpassword`
2. Klik tombol **Login**

**Expected Result:**
- ✅ Muncul dialog error
- ✅ Message: "Email atau password salah"
- ✅ Tetap di login page

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, behavior: _______________

---

### Test 4: Login dengan Field Kosong ⚠️

**Steps:**
1. Di login page, kosongkan semua field
2. Klik tombol **Login**

**Expected Result:**
- ✅ Form validation error muncul
- ✅ Tidak ada network request
- ✅ Tetap di login page

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, behavior: _______________

---

### Test 5: Login dengan User Pending 🕐

**Pre-requirement:** Buat user dengan status pending di Firestore

**Steps:**
1. Di Firestore, create user baru:
   ```
   email: test@pending.com
   password: test123
   status: pending
   (... other fields ...)
   ```
2. Di login page, input:
   - Email: `test@pending.com`
   - Password: `test123`
3. Klik tombol **Login**

**Expected Result:**
- ✅ Muncul dialog error
- ✅ Message: "Akun Anda masih menunggu persetujuan admin"
- ✅ Tetap di login page

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, behavior: _______________

---

### Test 6: Login dengan User Rejected 🚫

**Pre-requirement:** Buat user dengan status rejected di Firestore

**Steps:**
1. Di Firestore, create user baru:
   ```
   email: test@rejected.com
   password: test123
   status: rejected
   (... other fields ...)
   ```
2. Di login page, input:
   - Email: `test@rejected.com`
   - Password: `test123`
3. Klik tombol **Login**

**Expected Result:**
- ✅ Muncul dialog error
- ✅ Message: "Akun Anda ditolak oleh admin"
- ✅ Tetap di login page

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, behavior: _______________

---

### Test 7: Auto-Login Bug Check 🐛

**Critical Test - Ini yang diperbaiki!**

**Steps:**
1. Dari pre-auth page, klik tombol **Login**
2. **JANGAN** input email dan password
3. Langsung klik tombol **Login** tanpa mengisi apapun

**Expected Result:**
- ✅ Form validation error muncul
- ✅ **TIDAK** auto-login ke dashboard
- ✅ Tetap di login page
- ✅ User diminta mengisi email dan password

**Actual Result:**
- [ ] PASS - Tidak auto-login ✅
- [ ] FAIL - Masih auto-login ❌

**If FAIL:** Bug masih ada, perlu debugging lebih lanjut.

---

### Test 8: Fast Click Test ⚡

**Steps:**
1. Di login page, input valid credentials
2. Klik tombol **Login** berkali-kali dengan cepat (double/triple click)

**Expected Result:**
- ✅ Loading state prevents multiple clicks
- ✅ Hanya satu request ke Firestore
- ✅ Tidak ada duplicate navigation

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, behavior: _______________

---

### Test 9: Back Button Test ◀️

**Steps:**
1. Setelah berhasil login ke dashboard
2. Tekan back button (Android) atau gesture back (iOS)

**Expected Result:**
- ✅ **TIDAK** kembali ke login page
- ✅ Tetap di dashboard (atau exit app)

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, behavior: _______________

---

### Test 10: Logout then Login 🔄

**Steps:**
1. Login dengan valid credentials
2. Dari dashboard, logout (jika ada menu logout)
3. Kembali ke login page
4. Login lagi dengan same credentials

**Expected Result:**
- ✅ Logout berhasil, kembali ke pre-auth
- ✅ Login lagi berhasil
- ✅ Masuk ke dashboard

**Actual Result:**
- [ ] PASS
- [ ] FAIL - jika fail, behavior: _______________

---

## 📊 Test Summary

| Test Case | Status | Notes |
|-----------|--------|-------|
| Test 1: Valid Login | ⬜ | |
| Test 2: Wrong Email | ⬜ | |
| Test 3: Wrong Password | ⬜ | |
| Test 4: Empty Fields | ⬜ | |
| Test 5: Pending User | ⬜ | |
| Test 6: Rejected User | ⬜ | |
| Test 7: Auto-Login Bug | ⬜ | **CRITICAL** |
| Test 8: Fast Click | ⬜ | |
| Test 9: Back Button | ⬜ | |
| Test 10: Logout/Login | ⬜ | |

**Legend:**
- ⬜ Not tested
- ✅ PASS
- ❌ FAIL

## 🐛 If Tests Fail

### Test 7 FAIL (Auto-Login masih terjadi)

**Debugging Steps:**
1. Check `lib/core/providers/auth_provider.dart`:
   ```dart
   // Pastikan ada validation:
   if (email.isEmpty || password.isEmpty) {
     _errorMessage = 'Email dan password harus diisi';
     return false;
   }
   ```

2. Check `lib/features/auth/login_page.dart`:
   ```dart
   // Pastikan ada form validation:
   if (!_formKey.currentState!.validate()) {
     return;
   }
   ```

3. Hot Restart (bukan Hot Reload)

4. Check terminal untuk error messages

### Other Test FAIL

1. **Check Firestore Connection:**
   - Buka Firebase Console
   - Lihat apakah ada request di Firestore

2. **Check Error Messages:**
   - Lihat terminal/console
   - Screenshot error dialog

3. **Check User Data:**
   - Verify user exists di Firestore
   - Check all required fields ada
   - Check data types correct

## ✅ Test Completion

Setelah semua test **PASS**:

1. [ ] Screenshot test results
2. [ ] Document any issues found
3. [ ] Mark test summary as complete
4. [ ] Proceed to next feature

## 📝 Notes

Tambahkan catatan testing di sini:

```
Tested by: _______________
Date: _______________
Device: _______________
OS Version: _______________

Notes:
- 
- 
- 
```

---

**Test Suite Version**: 1.0  
**Created**: 2025-01-15  
**Purpose**: Verify login system fix
