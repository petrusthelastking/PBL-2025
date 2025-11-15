# ⚡ Quick Start - Login System

## 🎯 TL;DR

Masalah login yang otomatis masuk tanpa validasi **sudah diperbaiki**. Sekarang sistem akan memvalidasi email dan password dengan benar.

## 🚀 Langkah Cepat

### 1. Buat User Admin (Pilih salah satu)

#### Opsi A: Via Script (Tercepat) ⚡

Edit `lib/main.dart`, tambahkan di baris ke-8:
```dart
import 'create_admin.dart';
```

Lalu tambahkan sebelum `runApp()`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 🔥 Jalankan sekali, lalu comment!
  await createAdminUser();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WargaProvider()),
      ],
      child: const JawaraApp(),
    ),
  );
}
```

**Run app**, tunggu muncul di console:
```
✅ Admin user berhasil dibuat!
📧 Email: admin@jawara.com
🔑 Password: admin123
```

**PENTING**: Setelah berhasil, **comment** baris `await createAdminUser();`

#### Opsi B: Via Firebase Console 🌐

1. Buka https://console.firebase.google.com
2. Pilih project → Firestore Database
3. Create collection: `users`
4. Add document dengan fields:

```
email: admin@jawara.com
password: admin123
nama: Admin Jawara
nik: 1234567890123456
jenisKelamin: Laki-laki
noTelepon: 081234567890
alamat: Jl. Contoh No. 123
role: admin
status: approved
createdAt: 2025-01-15T10:00:00.000Z
updatedAt: (leave null)
```

### 2. Test Login

1. **Hot Restart** app (tekan `R` di terminal atau Shift+F5)
2. Tunggu splash → swipe onboarding → klik **Login**
3. Masukkan:
   - Email: `admin@jawara.com`
   - Password: `admin123`
4. Klik **Login**
5. ✅ Harus berhasil masuk ke Dashboard

## 🐛 Troubleshooting

### ❌ "Email atau password salah"
- Pastikan user sudah dibuat di Firestore
- Check spelling email dan password
- Pastikan huruf besar/kecil sesuai

### ❌ "Akun Anda masih menunggu persetujuan"
- Di Firestore, ubah field `status` menjadi `"approved"`

### ❌ Masih auto-login tanpa validasi
- Hot Restart (Shift+F5), bukan Hot Reload
- Pastikan file terbaru sudah di-save semua
- Check tidak ada error di terminal

### ❌ Error "Undefined name 'AuthProvider'"
- Pastikan sudah add di `pubspec.yaml`:
  ```yaml
  dependencies:
    provider: ^6.0.5
  ```
- Run: `flutter pub get`

## 📖 Dokumentasi Lengkap

- **AUTH_SETUP_GUIDE.md** - Panduan setup detail
- **SETUP_AUTH_STEPS.md** - Langkah-langkah lengkap  
- **LOGIN_FIX_SUMMARY.md** - Ringkasan perbaikan

## ✅ Checklist

- [ ] Firebase sudah tersetup
- [ ] File `google-services.json` ada di `android/app/`
- [ ] User admin sudah dibuat di Firestore
- [ ] Status user = "approved"
- [ ] Test login berhasil
- [ ] Baris `await createAdminUser();` sudah di-comment

## 🎉 Selesai!

Login system sekarang bekerja dengan baik. Email dan password akan divalidasi sebelum login.

---

**Created**: 2025-01-15
**Status**: ✅ FIXED
