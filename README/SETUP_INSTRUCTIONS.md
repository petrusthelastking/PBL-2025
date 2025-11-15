# 🎯 INSTRUKSI SETUP FIREBASE - LANGKAH DEMI LANGKAH

## ⚠️ PENTING: Baca ini terlebih dahulu!

File `main.dart` saat ini menampilkan error karena:
1. Dependencies Firebase belum di-install
2. File `firebase_options.dart` belum dibuat

**Ini NORMAL dan akan fixed setelah Anda menjalankan setup di bawah.**

---

## 📋 CHECKLIST SETUP

Copy checklist ini dan tandai setiap langkah yang sudah selesai:

```
SETUP LOKAL:
□ Install Node.js (jika belum ada)
□ Install Firebase CLI
□ Login Firebase CLI
□ Install FlutterFire CLI
□ Run flutter pub get
□ Run flutterfire configure

FIREBASE CONSOLE:
□ Buat project Firebase (jika belum)

TESTING:
□ Run flutter run (tanpa error)
□ Test login/register
□ Test tambah data warga
□ Cek data di Firebase Console
```

---

## 🚀 LANGKAH 1: INSTALL TOOLS

### A. Install Node.js (jika belum ada)
Download dari: https://nodejs.org/
Pilih versi LTS (Long Term Support)

Verify instalasi:
```bash
node --version
npm --version
```

### B. Install Firebase CLI
Buka Command Prompt/PowerShell dan jalankan:
```bash
npm install -g firebase-tools
```

Verify instalasi:
```bash
firebase --version
```

### C. Login Firebase CLI
```bash
firebase login
```
Browser akan terbuka, login dengan akun Google Anda.

### D. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

Verify instalasi:
```bash
flutterfire --version
```

**Jika command 'flutterfire' not found:**
Tambahkan ke PATH:
- Windows: `%USERPROFILE%\AppData\Local\Pub\Cache\bin`

---

## 🚀 LANGKAH 2: SETUP PROJECT FLUTTER

### A. Install Dependencies
Buka terminal di folder project, jalankan:
```bash
flutter pub get
```

Tunggu hingga selesai download semua packages.

### B. Configure Firebase
```bash
flutterfire configure
```

Akan muncul pertanyaan:
1. **"Select a Firebase project"**
   - Pilih project Firebase Anda (yang sudah dibuat di console)
   - Jika belum ada, pilih "Create new project"

2. **"Which platforms should your configuration support?"**
   - Minimal pilih: Android
   - Optional: iOS, Web

3. Tunggu hingga proses selesai

**Output yang diharapkan:**
- ✓ File `lib/firebase_options.dart` terbuat
- ✓ File `android/app/google-services.json` terbuat
- ✓ Configuration files updated

### C. Verify
Check apakah file berikut sudah ada:
```
lib/firebase_options.dart           ← HARUS ADA
android/app/google-services.json    ← HARUS ADA (untuk Android)
```

---

## 🚀 LANGKAH 3: SETUP FIREBASE CONSOLE

Buka: https://console.firebase.google.com

⚠️ **CATATAN PENTING:** 
5. Klik **"Enable"**
⚠️ **CATATAN PENTING:** 
Project ini **TIDAK menggunakan Firebase Authentication** karena form register memiliki banyak field tambahan (nama, NIK, alamat, dll) yang tidak bisa ditangani oleh Firebase Auth. Semua autentikasi akan langsung menggunakan **Firestore** untuk menyimpan data user lengkap.
Tunggu beberapa saat...
### A. Create Firestore Database
  match /databases/{database}/documents {
    // ⚠️ UNTUK DEVELOPMENT ONLY
2. Klik button **"Create database"**
    // TODO: Ganti dengan rules yang lebih ketat untuk production
    
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```
---
### B. Setup Firestore Security Rules
```bash
✅ Firestore berhasil!
2. Replace semua code dengan code ini:

1. **Buat admin user pertama** (via register di app atau Firebase Console)
2. **Integrasikan Provider ke UI** (lihat FIREBASE_IMPLEMENTATION_SUMMARY.md)
3. **Replace dummy data** dengan real Firebase data
4. **Implement fitur-fitur baru**
    // ⚠️ UNTUK DEVELOPMENT ONLY
    // Mengizinkan akses penuh untuk development
    // TODO: Ganti dengan rules yang lebih ketat untuk production

    match /{document=**} {
      allow read, write: if true;

Jika masih ada masalah:

1. **Check Firebase Console:**
   - Apakah services sudah enabled?
   - Apakah ada error di Usage & Logs?

2. **Check Flutter Doctor:**
   ```bash
⚠️ **PENTING:** Rules di atas mengizinkan semua akses untuk memudahkan development. Untuk production, ganti dengan rules yang lebih ketat berdasarkan role user.

   flutter doctor -v
   ```

3. **Clean & Rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Check Documentation:**
   - FIREBASE_SETUP_GUIDE.md (panduan lengkap)
   - FIREBASE_IMPLEMENTATION_SUMMARY.md (cara pakai)
### B. Test Register & Login

1. Buka halaman register di app
2. Coba register dengan data lengkap:
   - Nama: Test User
## 📚 FILE DOKUMENTASI

   - NIK: 1234567890123456
   - Alamat, RT/RW, dll.

3. Cek Firebase Console → Firestore Database → Collection "users"
4. Data user baru harus muncul

5. Logout, lalu coba login dengan email dan password yang sama
6. Harus berhasil masuk ke dashboard

✅ Login/Register berhasil!
FIREBASE_SETUP_GUIDE.md              ← Panduan lengkap & detail
### C. Test Firestore
SETUP_INSTRUCTIONS.md                ← File ini (step by step)
1. Di app, coba tambah data warga baru
2. Cek Firebase Console → Firestore Database
3. Collection "warga" harus muncul dengan data baru


---


**Selamat mencoba! 🚀**

Jika ada pertanyaan, silakan tanya!

