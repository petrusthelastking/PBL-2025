# 🔥 PANDUAN SETUP FIREBASE UNTUK JAWARA APP

## 📋 Daftar Isi
1. [Setup Firebase Console](#1-setup-firebase-console)
2. [Setup Flutter Project](#2-setup-flutter-project)
3. [Konfigurasi Firebase Services](#3-konfigurasi-firebase-services)
4. [Testing](#4-testing)

---

## 1. Setup Firebase Console

### A. Enable Authentication
1. Buka Firebase Console: https://console.firebase.google.com
2. Pilih project Anda
3. Klik **"Authentication"** di menu kiri
4. Klik tab **"Sign-in method"**
5. Enable metode login berikut:
   - ✅ **Email/Password** (untuk login admin/petugas)
   - ✅ **Phone** (opsional, untuk login warga via SMS)

### B. Setup Firestore Database
1. Klik **"Firestore Database"** di menu kiri
2. Klik **"Create database"**
3. Pilih **"Start in test mode"** (untuk development)
4. Pilih lokasi: **asia-southeast2 (Jakarta)** atau **asia-southeast1 (Singapore)**
5. Klik **"Enable"**

### C. Setup Storage
1. Klik **"Storage"** di menu kiri
2. Klik **"Get started"**
3. Pilih **"Start in test mode"**
4. Pilih lokasi yang sama dengan Firestore
5. Klik **"Done"**

### D. Struktur Firestore Database

Setelah Firestore aktif, kita akan menggunakan struktur koleksi berikut:

```
📁 firestore_database/
├── 👥 users/                    # Data user (admin, petugas, warga)
│   └── {userId}/
│       ├── email: string
│       ├── name: string
│       ├── role: string         # "admin", "petugas", "warga"
│       ├── phone: string
│       ├── address: string
│       ├── nik: string
│       ├── photoUrl: string
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── 📊 warga/                    # Data warga/penduduk
│   └── {wargaId}/
│       ├── nik: string
│       ├── name: string
│       ├── birthDate: timestamp
│       ├── gender: string
│       ├── address: string
│       ├── phone: string
│       ├── rt: string
│       ├── rw: string
│       ├── status: string       # "Kawin", "Belum Kawin", dll
│       ├── occupation: string
│       ├── photoUrl: string
│       ├── createdBy: string
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── 📅 agenda/                   # Data agenda kegiatan
│   └── {agendaId}/
│       ├── title: string
│       ├── description: string
│       ├── date: timestamp
│       ├── startTime: string
│       ├── endTime: string
│       ├── location: string
│       ├── category: string     # "Rapat", "Kegiatan", "Sosialisasi"
│       ├── status: string       # "Upcoming", "Ongoing", "Completed"
│       ├── penanggungJawab: array
│       ├── participants: array
│       ├── createdBy: string
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── 💰 keuangan/                 # Data transaksi keuangan
│   └── {transactionId}/
│       ├── type: string         # "income", "expense"
│       ├── category: string
│       ├── amount: number
│       ├── description: string
│       ├── date: timestamp
│       ├── createdBy: string
│       ├── proofUrl: string     # URL bukti transfer/nota
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── 🔄 mutasi_warga/            # Data mutasi warga (pindah/datang)
│   └── {mutasiId}/
│       ├── wargaId: string
│       ├── type: string         # "masuk", "keluar"
│       ├── reason: string
│       ├── fromAddress: string
│       ├── toAddress: string
│       ├── date: timestamp
│       ├── dokumenUrl: string
│       ├── createdBy: string
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
└── 📢 notifications/           # Data notifikasi
    └── {notificationId}/
        ├── userId: string
        ├── title: string
        ├── message: string
        ├── type: string         # "agenda", "keuangan", "announcement"
        ├── isRead: boolean
        ├── createdAt: timestamp
        └── relatedId: string    # ID dari agenda/keuangan terkait
```

### E. Firestore Security Rules (untuk development)

Di tab **"Rules"** di Firestore, gunakan rules berikut untuk testing:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isAdmin() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    function isPetugas() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'petugas';
    }
    
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Warga collection
    match /warga/{wargaId} {
      allow read: if isSignedIn();
      allow write: if isAdmin() || isPetugas();
    }
    
    // Agenda collection
    match /agenda/{agendaId} {
      allow read: if isSignedIn();
      allow write: if isAdmin() || isPetugas();
    }
    
    // Keuangan collection
    match /keuangan/{transactionId} {
      allow read: if isSignedIn();
      allow write: if isAdmin() || isPetugas();
    }
    
    // Mutasi warga collection
    match /mutasi_warga/{mutasiId} {
      allow read: if isSignedIn();
      allow write: if isAdmin() || isPetugas();
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      allow read: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow write: if isAdmin() || isPetugas();
    }
  }
}
```

### F. Storage Security Rules

Di **Storage > Rules**, gunakan rules berikut:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      request.resource.size < 5 * 1024 * 1024 && // Max 5MB
                      request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## 2. Setup Flutter Project

### A. Install Firebase CLI & FlutterFire CLI

Jalankan perintah berikut di terminal:

```bash
# Install Firebase CLI (jika belum)
npm install -g firebase-tools

# Login ke Firebase
firebase login

# Install FlutterFire CLI
dart pub global activate flutterfire_cli
```

### B. Konfigurasi Firebase di Flutter

```bash
# Jalankan FlutterFire configure
flutterfire configure
```

Pilih project Firebase Anda dan platform yang akan digunakan (Android, iOS, Web).

### C. Tambahkan Dependencies

Dependencies Firebase sudah ditambahkan ke `pubspec.yaml`. Jalankan:

```bash
flutter pub get
```

---

## 3. Konfigurasi Firebase Services

### A. Inisialisasi Firebase

File `main.dart` sudah diupdate dengan konfigurasi Firebase.

### B. Struktur Folder Backend

```
lib/
├── core/
│   ├── services/
│   │   ├── firebase_service.dart
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   └── storage_service.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── warga_model.dart
│   │   ├── agenda_model.dart
│   │   ├── keuangan_model.dart
│   │   └── notification_model.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── warga_repository.dart
│       ├── agenda_repository.dart
│       └── keuangan_repository.dart
```

### C. Testing Firebase Connection

Setelah setup selesai, jalankan aplikasi dan cek console untuk memastikan Firebase terkoneksi dengan baik.

---

## 4. Testing

### A. Test Authentication
1. Jalankan aplikasi
2. Coba register dengan email dan password
3. Cek di Firebase Console > Authentication apakah user baru muncul

### B. Test Firestore
1. Coba tambah data warga
2. Cek di Firebase Console > Firestore apakah data muncul

### C. Test Storage
1. Coba upload foto profil atau dokumen
2. Cek di Firebase Console > Storage apakah file terupload

---

## 🔒 Catatan Keamanan

### Untuk Production:
1. **UBAH** Firestore rules dari test mode ke production mode
2. **AKTIFKAN** App Check untuk keamanan tambahan
3. **BATASI** akses berdasarkan role dan ownership
4. **BACKUP** database secara rutin
5. **MONITOR** usage di Firebase Console

### Recommended: Enable Firebase App Check
1. Buka **App Check** di Firebase Console
2. Register aplikasi Anda
3. Enable reCAPTCHA atau SafetyNet untuk Android
4. Enable DeviceCheck atau App Attest untuk iOS

---

## 📱 Next Steps

1. ✅ Setup Firebase Console (Authentication, Firestore, Storage)
2. ✅ Install Firebase CLI & FlutterFire CLI
3. ✅ Run `flutterfire configure`
4. ✅ Run `flutter pub get`
5. ✅ Test koneksi Firebase
6. 🚀 Mulai implementasi fitur dengan Firebase

---

## 🆘 Troubleshooting

### Error: "FirebaseOptions cannot be null"
- Pastikan sudah menjalankan `flutterfire configure`
- Cek apakah file `firebase_options.dart` sudah terbuat

### Error: "Google Services missing"
- Android: Pastikan file `google-services.json` ada di `android/app/`
- iOS: Pastikan file `GoogleService-Info.plist` ada di `ios/Runner/`

### Error: "Firestore permission denied"
- Cek Firestore rules
- Pastikan user sudah login
- Pastikan role user sudah diset dengan benar

---

## 📞 Support

Jika ada masalah, cek dokumentasi resmi:
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com)

