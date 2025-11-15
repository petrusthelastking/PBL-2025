# ✅ FIREBASE SETUP CHECKLIST

Gunakan checklist ini untuk memastikan semua langkah setup sudah dilakukan.

---

## 📋 FASE 1: PERSIAPAN TOOLS

### Install Node.js
- [ ] Download Node.js dari https://nodejs.org/
- [ ] Install Node.js (pilih LTS version)
- [ ] Verify: jalankan `node --version` dan `npm --version` di terminal
- [ ] Restart terminal/IDE setelah instalasi

### Install Firebase CLI
- [ ] Jalankan: `npm install -g firebase-tools`
- [ ] Verify: jalankan `firebase --version`
- [ ] Login: jalankan `firebase login`
- [ ] Browser terbuka dan berhasil login dengan akun Google

### Install FlutterFire CLI
- [ ] Jalankan: `dart pub global activate flutterfire_cli`
- [ ] Verify: jalankan `flutterfire --version`
- [ ] Jika error "command not found", tambahkan Dart bin ke PATH
- [ ] Restart terminal/IDE

**✓ Fase 1 selesai jika semua command di atas berjalan tanpa error**

---

## 📋 FASE 2: SETUP PROJECT FLUTTER

### Install Dependencies
- [ ] Buka terminal di folder project
- [ ] Jalankan: `flutter pub get`
- [ ] Tunggu hingga selesai (semua dependencies downloaded)
- [ ] Tidak ada error

### Configure Firebase
- [ ] Jalankan: `flutterfire configure`
- [ ] Pilih project Firebase Anda dari list
  - [ ] Atau create new project jika belum ada
- [ ] Pilih platforms: minimal **Android**
  - [ ] Optional: iOS
  - [ ] Optional: Web
- [ ] Tunggu hingga proses selesai

### Verify Files Created
- [ ] File `lib/firebase_options.dart` sudah ada
- [ ] File `android/app/google-services.json` sudah ada
- [ ] Tidak ada error di console

**✓ Fase 2 selesai jika semua file di atas sudah ada**

---

## 📋 FASE 3: SETUP FIREBASE CONSOLE

### Buka Firebase Console
- [ ] Buka https://console.firebase.google.com
- [ ] Pilih project Anda
- [ ] Dashboard project terbuka

### Setup Authentication
- [ ] Klik menu "Authentication" di sidebar
- [ ] Klik button "Get started"
- [ ] Klik tab "Sign-in method"
- [ ] Klik "Email/Password"
- [ ] Toggle switch ke "Enabled"
- [ ] Klik "Save"
- [ ] Status "Email/Password" = Enabled ✓

### Setup Firestore Database
- [ ] Klik menu "Firestore Database" di sidebar
- [ ] Klik button "Create database"
- [ ] Pilih "Start in test mode"
- [ ] Pilih location: **asia-southeast2 (Jakarta)** atau **asia-southeast1 (Singapore)**
- [ ] Klik "Enable"
- [ ] Tunggu hingga database ready
- [ ] Status = "Cloud Firestore is ready" ✓

### Setup Firestore Security Rules
- [ ] Di Firestore page, klik tab "Rules"
- [ ] Copy rules dari file `FIREBASE_SETUP_GUIDE.md` (section "Firestore Security Rules")
- [ ] Paste di editor rules
- [ ] Klik "Publish"
- [ ] Rules terpublish tanpa error ✓

### Setup Storage
- [ ] Klik menu "Storage" di sidebar
- [ ] Klik button "Get started"
- [ ] Pilih "Start in test mode"
- [ ] Pilih location yang sama dengan Firestore
- [ ] Klik "Done"
- [ ] Status = "Storage is ready" ✓

### Setup Storage Security Rules
- [ ] Di Storage page, klik tab "Rules"
- [ ] Copy rules dari file `FIREBASE_SETUP_GUIDE.md` (section "Storage Security Rules")
- [ ] Paste di editor rules
- [ ] Klik "Publish"
- [ ] Rules terpublish tanpa error ✓

**✓ Fase 3 selesai jika semua services sudah enabled dan rules terpublish**

---

## 📋 FASE 4: TESTING

### Test 1: Run Aplikasi
- [ ] Buka terminal di folder project
- [ ] Jalankan: `flutter run`
- [ ] App berhasil build tanpa error
- [ ] App running di device/emulator
- [ ] Tidak ada error Firebase di console

### Test 2: Authentication
- [ ] Buka halaman register di app
- [ ] Register user baru:
  - [ ] Email: test@jawara.com
  - [ ] Password: test123456
  - [ ] Name: Test User
  - [ ] Role: admin
- [ ] Register berhasil (tidak ada error)
- [ ] Buka Firebase Console → Authentication → Users
- [ ] User baru muncul di list ✓
- [ ] Try login dengan user tersebut
- [ ] Login berhasil ✓

### Test 3: Firestore
- [ ] Di app, coba tambah data warga baru
- [ ] Fill semua field yang required
- [ ] Simpan data
- [ ] Buka Firebase Console → Firestore Database
- [ ] Collection "warga" muncul
- [ ] Document baru ada di collection ✓
- [ ] Data sesuai dengan yang diinput

### Test 4: Storage (Optional)
- [ ] Di app, coba upload foto profil atau foto warga
- [ ] Pilih foto dari gallery
- [ ] Upload
- [ ] Buka Firebase Console → Storage
- [ ] Folder "profile_photos" atau "warga_photos" muncul
- [ ] File foto ada di folder ✓

**✓ Fase 4 selesai jika semua test berhasil tanpa error**

---

## 📋 FASE 5: INTEGRATION (OPTIONAL - UNTUK NANTI)

### Update App.dart untuk Provider
- [ ] Import provider package
- [ ] Wrap MaterialApp dengan MultiProvider
- [ ] Add AuthProvider
- [ ] Add WargaProvider
- [ ] Test app masih running

### Integrate Auth UI
- [ ] Update Login page gunakan AuthProvider
- [ ] Update Register page gunakan AuthProvider
- [ ] Test login/register dari UI
- [ ] Implement logout button
- [ ] Test logout

### Integrate Warga UI
- [ ] Update Data Warga page gunakan WargaProvider
- [ ] Replace dummy data dengan Firebase data
- [ ] Test CRUD operations dari UI
- [ ] Implement search functionality

**✓ Fase 5 selesai jika UI sudah terintegrasi dengan Firebase**

---

## 🎯 SUMMARY STATUS

### Fase yang HARUS diselesaikan sekarang:
- [ ] Fase 1: Persiapan Tools
- [ ] Fase 2: Setup Project Flutter
- [ ] Fase 3: Setup Firebase Console
- [ ] Fase 4: Testing

### Fase yang bisa dikerjakan nanti:
- [ ] Fase 5: Integration (bisa dikerjakan bertahap)

---

## ✅ VERIFICATION FINAL

Jika semua item di bawah ini ✓, maka setup Firebase **100% SUKSES**:

- [ ] Command `firebase --version` berjalan
- [ ] Command `flutterfire --version` berjalan
- [ ] File `lib/firebase_options.dart` ada
- [ ] File `android/app/google-services.json` ada
- [ ] Firebase Console: Authentication enabled ✓
- [ ] Firebase Console: Firestore Database ready ✓
- [ ] Firebase Console: Storage ready ✓
- [ ] Firebase Console: Security rules published ✓
- [ ] App running tanpa error
- [ ] Test register berhasil
- [ ] User baru muncul di Firebase Console
- [ ] Test tambah data berhasil
- [ ] Data muncul di Firestore

---

## 📝 NOTES

### Jika ada error di fase manapun:
1. Stop dan baca error message dengan teliti
2. Check dokumentasi yang relevan:
   - `SETUP_INSTRUCTIONS.md` untuk step-by-step detail
   - `FIREBASE_SETUP_GUIDE.md` untuk info lengkap
3. Try troubleshooting section di dokumentasi
4. Restart terminal/IDE
5. Try `flutter clean` dan `flutter pub get`

### Setelah setup selesai:
1. Bookmark dokumentasi untuk referensi
2. Baca `FIREBASE_IMPLEMENTATION_SUMMARY.md` untuk cara pakai
3. Baca `FIRESTORE_STRUCTURE.md` untuk struktur database
4. Mulai integrate ke UI secara bertahap

---

## 🎉 CONGRATULATIONS!

Jika semua checklist sudah ✓, berarti Firebase backend sudah siap 100%!

**Anda sekarang bisa:**
- ✅ Login/Register user
- ✅ CRUD data warga
- ✅ Upload files
- ✅ Real-time data sync
- ✅ Offline support

**Next: Integrate ke UI dan develop fitur-fitur baru! 🚀**

---

**Timestamp:** _____________
**Setup by:** _____________
**Status:** ⬜ In Progress | ⬜ Complete

