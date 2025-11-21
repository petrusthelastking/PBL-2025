# 🔧 TROUBLESHOOTING - User Sudah Ada Tapi Test Masih Gagal

## ❌ MASALAH

Anda sudah buat user di Firestore dengan:
- Email: `admin@jawara.com`
- Password: `admin123`

Tapi test **MASIH GAGAL** dengan error:
```
Multiple exceptions (2) were detected
Test failed.
```

## 🔍 KEMUNGKINAN PENYEBAB

Ada beberapa kemungkinan kenapa masih gagal:

### 1. **Field Name Salah** ⚠️

Firestore **case-sensitive**! Pastikan field name PERSIS seperti ini:

| ❌ SALAH | ✅ BENAR |
|----------|----------|
| Email | email |
| Password | password |
| Status | status |
| Role | role |

**Semua huruf kecil (lowercase)!**

### 2. **Field Value Salah** ⚠️

Check value dengan teliti:

| Field | ✅ Value yang BENAR | ❌ SALAH |
|-------|---------------------|----------|
| email | `admin@jawara.com` | `Admin@jawara.com` (huruf besar) |
| password | `admin123` | `Admin123` (huruf besar) |
| status | `approved` | `Approved` atau `pending` |
| role | `admin` | `Admin` |

### 3. **Collection Name Salah** ⚠️

Collection HARUS bernama: **`users`** (lowercase, plural)

❌ SALAH: `Users`, `user`, `User`
✅ BENAR: `users`

### 4. **Ada Spasi/Karakter Hidden** ⚠️

Kadang ada spasi tersembunyi di awal/akhir:

❌ SALAH: `admin@jawara.com ` (ada spasi di akhir)
✅ BENAR: `admin@jawara.com`

### 5. **Firestore Rules Blocking** ⚠️

Rules mungkin block read access.

---

## ✅ SOLUSI: RUN DEBUG TEST

Saya sudah buat **DEBUG TEST** yang akan check Firestore data Anda!

### **Command:**

```bash
# Option 1: Batch script
run_login_test.bat
# Pilih: 6. Run DEBUG test

# Option 2: Manual
flutter run -d chrome integration_test/auth/debug_test.dart
```

### **Apa yang akan dilakukan debug test:**

1. ✅ Connect ke Firestore
2. ✅ List semua users
3. ✅ Cari user "admin@jawara.com"
4. ✅ Check setiap field (email, password, status, role)
5. ✅ Kasih tahu field mana yang salah

### **Output Debug Test:**

Debug test akan menampilkan:

```
🔍 DEBUG TEST - Checking Firestore
════════════════════════════════════════════════════════════

🔍 CHECK 1: Testing Firestore Connection...
  ✅ Firestore instance created

🔍 CHECK 2: Querying users collection...
  ✅ Query successful!
  📊 Total documents in users collection: 1

🔍 CHECK 3: Listing all users...

  📄 Document ID: abc123
     Email: admin@jawara.com
     Nama: Admin Test
     Status: approved
     Role: admin
     Password length: 8 chars

🔍 CHECK 4: Looking for user "admin@jawara.com"...

  ✅ User "admin@jawara.com" FOUND!

  📋 User Details:
     Document ID: abc123
     Email: admin@jawara.com
     Password: admin123
     Status: approved
     Role: admin

🔍 CHECK 5: Validating fields...

  ✅ Email is correct
  ✅ Password is correct
  ✅ Status is "approved"
  ✅ Role is "admin"

════════════════════════════════════════════════════════════
  ✅ ALL CHECKS PASSED!
  ✅ User setup is CORRECT
════════════════════════════════════════════════════════════
```

Jika ada yang salah, akan muncul pesan:

```
  ❌ Password mismatch!
     Expected: admin123
     Found: Admin123

  ❌ Status is NOT "approved"!
     Expected: approved
     Found: pending
```

---

## 🎯 LANGKAH-LANGKAH TROUBLESHOOTING

### **Step 1: Run Debug Test**

```bash
run_login_test.bat
# Pilih: 6. Run DEBUG test
```

### **Step 2: Baca Output**

Lihat output di console. Cari:
- ❌ (tanda silang merah) = Ada masalah
- ✅ (tanda centang hijau) = OK

### **Step 3: Fix Masalah**

Jika ada ❌, fix di Firebase Console:

1. Buka Firebase Console
2. Firestore Database
3. Collection `users`
4. Edit document
5. Fix field yang salah
6. Save

### **Step 4: Run Debug Test Lagi**

Pastikan semua ✅ (hijau)

### **Step 5: Run Login Test**

Setelah semua ✅, run login test:

```bash
run_login_test.bat
# Pilih: 5. Run SIMPLE test
```

---

## 📋 CHECKLIST LENGKAP

Copy ini dan check satu-satu:

```
FIRESTORE SETUP CHECKLIST:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Collection Name:
[ ] Collection bernama "users" (lowercase, plural)

Field Names (case-sensitive!):
[ ] email (bukan Email atau EMAIL)
[ ] password (bukan Password)
[ ] status (bukan Status)
[ ] role (bukan Role)
[ ] nama (optional, bukan Nama)

Field Values:
[ ] email = "admin@jawara.com" (persis, lowercase)
[ ] password = "admin123" (persis, lowercase)
[ ] status = "approved" (persis, lowercase)
[ ] role = "admin" (lowercase)
[ ] nama = "Admin Test" (apa saja)

No Hidden Characters:
[ ] Tidak ada spasi di awal/akhir email
[ ] Tidak ada spasi di awal/akhir password
[ ] Copy-paste langsung, jangan ketik manual

Document Status:
[ ] Document sudah di-save
[ ] Document muncul di Firestore console
[ ] Bisa di-click dan lihat isinya

Internet & Firebase:
[ ] Internet connection OK
[ ] Firebase project benar (pbl-2025-35a1c)
[ ] Firestore rules allow read

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🎓 COMMON MISTAKES

### **Mistake #1: Huruf Besar/Kecil**

❌ **SALAH:**
```
email: Admin@jawara.com     (huruf A besar)
password: Admin123          (huruf A besar)
status: Approved            (huruf A besar)
```

✅ **BENAR:**
```
email: admin@jawara.com     (semua lowercase)
password: admin123          (semua lowercase)
status: approved            (semua lowercase)
```

### **Mistake #2: Field Name Salah**

❌ **SALAH:**
```
Email: admin@jawara.com     (E besar)
Password: admin123          (P besar)
```

✅ **BENAR:**
```
email: admin@jawara.com     (e kecil)
password: admin123          (p kecil)
```

### **Mistake #3: Status Pending**

❌ **SALAH:**
```
status: pending             (user belum di-approve)
```

✅ **BENAR:**
```
status: approved            (user sudah di-approve)
```

---

## 💡 TIPS

### **Tip 1: Copy-Paste Langsung**

Jangan ketik manual! Copy-paste dari sini:

```
email: admin@jawara.com
password: admin123
status: approved
role: admin
```

### **Tip 2: Double Check di Firebase Console**

Setelah save, click document dan verify field-nya.

### **Tip 3: Delete & Create Ulang**

Jika masih bingung, delete document lama dan buat baru:

1. Delete document yang lama
2. Add document baru
3. Copy-paste values dari atas
4. Save
5. Run debug test

---

## 🚀 QUICK FIX

**Cara tercepat untuk fix:**

1. **Delete user yang lama** di Firestore

2. **Add document baru** dengan copy-paste ini:

   ```
   Collection: users
   
   email: admin@jawara.com
   password: admin123
   status: approved
   role: admin
   nama: Admin Test
   ```

3. **Run debug test:**
   ```bash
   run_login_test.bat
   # Pilih: 6
   ```

4. **Check output** - pastikan semua ✅

5. **Run login test:**
   ```bash
   run_login_test.bat
   # Pilih: 5
   ```

---

## 📞 NEXT STEPS

### **Kalau masih gagal setelah debug test menunjukkan semua ✅:**

Kemungkinan masalahnya bukan di Firestore, tapi di:

1. **Login flow aplikasi** - ada bug
2. **Navigation** - tidak ke dashboard
3. **Widget finder** - widget tidak ketemu
4. **Timing** - butuh wait lebih lama

Dalam hal ini, **screenshot console output** dan tunjukkan ke saya untuk analisis lebih lanjut.

---

## ✅ SUMMARY

**Problem:** User sudah ada di Firestore tapi test gagal

**Root Cause:** Kemungkinan besar typo di field name atau value

**Solution:**
1. ✅ Run debug test: `run_login_test.bat` → pilih 6
2. ✅ Lihat output, cari ❌
3. ✅ Fix yang ❌ di Firebase Console
4. ✅ Run debug test lagi sampai semua ✅
5. ✅ Run login test

**Debug Test Command:**
```bash
flutter run -d chrome integration_test/auth/debug_test.dart
```

---

**Last Updated:** November 21, 2025  
**Status:** Debug test available untuk troubleshooting

