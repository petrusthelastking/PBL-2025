# 🚀 Langkah-langkah Setup Authentication

## 1️⃣ Setup Firebase (Jika belum)

Pastikan Firebase sudah tersetup dengan benar:
- ✅ File `google-services.json` ada di `android/app/`
- ✅ Firebase SDK sudah di-add di `pubspec.yaml`
- ✅ Firebase sudah di-initialize di `main.dart`

## 2️⃣ Membuat User Admin Pertama

### Cara 1: Menggunakan Script Helper (RECOMMENDED)

1. Buka file `lib/main.dart`
2. Import helper script di bagian atas:
   ```dart
   import 'create_admin.dart'; // Tambahkan ini
   ```

3. Tambahkan kode berikut di dalam fungsi `main()` sebelum `runApp()`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
     
     // 🔥 JALANKAN SEKALI SAJA, LALU COMMENT!
     await createAdminUser();
     // Opsional: untuk membuat demo users
     // await createDemoUsers();
     
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

4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

5. Lihat console/terminal, akan muncul:
   ```
   ✅ Admin user berhasil dibuat!
   📧 Email: admin@jawara.com
   🔑 Password: admin123
   ```

6. **PENTING**: Comment atau hapus baris `await createAdminUser();` setelah berhasil!

### Cara 2: Manual via Firebase Console

1. Buka [Firebase Console](https://console.firebase.google.com)
2. Pilih project Anda
3. Menu **Firestore Database** → **Start collection**
4. Collection ID: `users`
5. Add document dengan data berikut:

| Field | Type | Value |
|-------|------|-------|
| email | string | admin@jawara.com |
| password | string | admin123 |
| nama | string | Admin Jawara |
| nik | string | 1234567890123456 |
| jenisKelamin | string | Laki-laki |
| noTelepon | string | 081234567890 |
| alamat | string | Jl. Contoh No. 123 |
| role | string | admin |
| status | string | approved |
| createdAt | string | 2025-01-15T10:00:00.000Z |
| updatedAt | null | null |

6. Klik **Save**

## 3️⃣ Test Login

1. Jalankan aplikasi
2. Tunggu splash screen selesai
3. Swipe onboarding
4. Klik tombol **Login**
5. Masukkan kredensial:
   - **Email**: `admin@jawara.com`
   - **Password**: `admin123`
6. Klik **Login**
7. Jika berhasil, akan redirect ke Dashboard

## 4️⃣ Verifikasi

### ✅ Login Berhasil
- Masuk ke halaman Dashboard
- Tidak ada error

### ❌ Troubleshooting

**Problem**: "Email atau password salah"
- ✔️ Pastikan user sudah dibuat di Firestore
- ✔️ Cek ejaan email dan password
- ✔️ Cek field name di Firestore sesuai (case-sensitive)

**Problem**: "Akun Anda masih menunggu persetujuan"
- ✔️ Pastikan field `status` = `"approved"` (bukan `"pending"`)

**Problem**: "Terjadi kesalahan: ..."
- ✔️ Cek koneksi internet
- ✔️ Pastikan Firebase sudah di-initialize
- ✔️ Cek Firebase console untuk error logs
- ✔️ Lihat terminal/console untuk detail error

**Problem**: Langsung masuk Dashboard tanpa login
- ✔️ Ini bug yang sudah diperbaiki
- ✔️ Pastikan menggunakan kode terbaru
- ✔️ Hot restart (R di terminal atau Ctrl+Shift+F5)

## 5️⃣ Membuat User Baru via App

### Sebagai Admin:
1. Login sebagai admin
2. Buka menu **Data Warga** → **Kelola Pengguna**
3. Klik tombol **+ Tambah Pengguna**
4. Isi form dan simpan
5. User baru langsung aktif (status: approved)

### Sebagai User (Registrasi):
1. Dari halaman Pre-Auth, klik **Sign Up**
2. Isi form registrasi
3. Klik **Daftar**
4. User dibuat dengan status `pending`
5. Tunggu admin approve dari menu Kelola Pengguna atau Terima Warga

## 6️⃣ Struktur Role & Status

### Role:
- **admin**: Full access, bisa approve/reject user
- **user**: Limited access, tergantung implementasi

### Status:
- **pending**: Menunggu approval, tidak bisa login
- **approved**: Bisa login dan akses app
- **rejected**: Ditolak, tidak bisa login

## 7️⃣ Security Notes

⚠️ **PENTING untuk Production**:

1. **Password Hashing**: 
   - Saat ini menggunakan plain text (DEMO ONLY!)
   - Gunakan package `crypto` atau `bcrypt`
   - Atau gunakan Firebase Authentication

2. **Validation**:
   - Add email validation
   - Add password strength requirements
   - Add rate limiting untuk prevent brute force

3. **Session Management**:
   - Implement proper session/token
   - Add auto-logout setelah timeout
   - Store session securely

4. **Firestore Rules**:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         // Only authenticated users can read
         allow read: if request.auth != null;
         // Only admin can write
         allow write: if request.auth != null && 
                         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
       }
     }
   }
   ```

## 8️⃣ Next Steps

- [ ] Implement password hashing
- [ ] Add "Forgot Password" feature
- [ ] Add email verification
- [ ] Implement proper session management
- [ ] Add two-factor authentication (optional)
- [ ] Setup Firestore security rules
- [ ] Add activity logging untuk audit trail

## 📞 Need Help?

Lihat file `AUTH_SETUP_GUIDE.md` untuk informasi lebih detail.
