# 🚀 QUICK START - FIREBASE SETUP

Ikuti langkah-langkah berikut untuk setup Firebase di aplikasi Jawara:

## 📦 Step 1: Install Dependencies

flutter pub get

## 🔥 Step 2: Install Firebase CLI (jika belum)

npm install -g firebase-tools

## 🔑 Step 3: Login ke Firebase

firebase login

## 🎯 Step 4: Install FlutterFire CLI

dart pub global activate flutterfire_cli

## ⚙️ Step 5: Configure Firebase

flutterfire configure

Pilih:
- Project Firebase Anda
- Platform: Android (minimum)
- iOS (opsional)
- Web (opsional)

## ✅ Step 6: Verifikasi

Cek apakah file berikut sudah terbuat:
- lib/firebase_options.dart
- android/app/google-services.json

## 🏃 Step 7: Run App

flutter run

---

## 📋 Yang Sudah Dibuat:

✅ Dependencies Firebase sudah ditambahkan di pubspec.yaml
✅ Firebase initialization di main.dart
✅ Services:
   - firebase_service.dart
   - auth_service.dart
   - firestore_service.dart
   - storage_service.dart

✅ Models:
   - user_model.dart
   - warga_model.dart
   - agenda_model.dart
   - keuangan_model.dart
   - notification_model.dart

✅ Providers:
   - auth_provider.dart
   - warga_provider.dart

---

## 🔧 Setup Firebase Console:

### 1. Authentication
   - Enable Email/Password
   - (Opsional) Enable Phone

### 2. Firestore Database
   - Create database
   - Start in test mode
   - Location: asia-southeast2 (Jakarta)

### 3. Storage
   - Get started
   - Start in test mode

### 4. Security Rules
   - Lihat FIREBASE_SETUP_GUIDE.md untuk rules lengkap

---

## 📞 Need Help?

Baca panduan lengkap di: FIREBASE_SETUP_GUIDE.md

