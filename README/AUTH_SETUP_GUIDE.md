# Setup Authentication System

## Struktur Database Firestore

### Collection: `users`

Setiap dokumen user memiliki field berikut:

```
{
  "email": "admin@jawara.com",
  "password": "admin123", // NOTE: Dalam produksi, gunakan hash password!
  "nama": "Admin Jawara",
  "nik": "1234567890123456",
  "jenisKelamin": "Laki-laki",
  "noTelepon": "081234567890",
  "alamat": "Jl. Contoh No. 123",
  "role": "admin", // "admin" atau "user"
  "status": "approved", // "pending", "approved", "rejected"
  "createdAt": "2025-01-15T10:00:00.000Z",
  "updatedAt": null
}
```

## Cara Membuat User Admin Pertama

### Opsi 1: Melalui Firebase Console

1. Buka Firebase Console (https://console.firebase.google.com)
2. Pilih project Anda
3. Buka menu "Firestore Database"
4. Klik "Start collection"
5. Masukkan Collection ID: `users`
6. Tambahkan dokumen dengan field di atas

### Opsi 2: Melalui Kode (Temporary Script)

Buat file `create_admin.dart` di folder `lib/` dengan isi:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createAdminUser() async {
  final firestore = FirebaseFirestore.instance;
  
  await firestore.collection('users').add({
    'email': 'admin@jawara.com',
    'password': 'admin123',
    'nama': 'Admin Jawara',
    'nik': '1234567890123456',
    'jenisKelamin': 'Laki-laki',
    'noTelepon': '081234567890',
    'alamat': 'Jl. Contoh No. 123',
    'role': 'admin',
    'status': 'approved',
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': null,
  });
  
  print('Admin user created successfully!');
}
```

Panggil fungsi ini di `main.dart` sementara:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Jalankan sekali, lalu comment/hapus
  // await createAdminUser();
  
  runApp(...);
}
```

## Login Credentials Default

Setelah membuat user admin, Anda bisa login dengan:
- **Email**: admin@jawara.com
- **Password**: admin123

## Catatan Penting

⚠️ **KEAMANAN**: Sistem saat ini menggunakan password plain text untuk demo. Dalam produksi:

1. Gunakan Firebase Authentication atau
2. Hash password menggunakan package seperti `crypto` atau `bcrypt`
3. Jangan simpan password plain text di database

## Cara Kerja Authentication

1. User memasukkan email dan password
2. System query Firestore untuk mencari user dengan email tersebut
3. Verifikasi password (saat ini simple comparison)
4. Cek status user:
   - `pending`: Menunggu approval admin
   - `approved`: Bisa login
   - `rejected`: Tidak bisa login
5. Simpan data user di `AuthProvider`
6. Navigate ke Dashboard

## Registrasi User Baru

1. User mengisi form registrasi
2. System membuat dokumen baru di Firestore dengan `status: "pending"`
3. User tidak bisa login sampai admin approve
4. Admin bisa approve/reject dari menu "Kelola Pengguna"

## Mengelola User

Admin dapat:
- Melihat semua user di menu "Kelola Pengguna"
- Approve/reject user baru
- Edit informasi user
- Hapus user

## Troubleshooting

### Login gagal terus?
- Pastikan user sudah dibuat di Firestore
- Cek status user harus "approved"
- Cek email dan password sesuai

### Error "Akun Anda masih menunggu persetujuan"?
- Ubah status user menjadi "approved" di Firestore
- Atau login menggunakan akun admin

### Tidak bisa akses Firebase?
- Pastikan `google-services.json` sudah ada di `android/app/`
- Pastikan Firebase sudah di-initialize di `main.dart`
- Cek koneksi internet
