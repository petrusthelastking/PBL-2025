# 🔐 SISTEM AUTENTIKASI FIRESTORE

## ⚠️ PENTING

Project ini **TIDAK menggunakan Firebase Authentication**. Semua proses autentikasi dilakukan langsung melalui **Firestore Database**.

### Alasan Tidak Menggunakan Firebase Auth:
1. Form registrasi memiliki banyak field tambahan (NIK, alamat, RT/RW, dll)
2. Firebase Auth tidak bisa menampung semua field yang dibutuhkan
3. Sistem approval/rejection user memerlukan kontrol yang lebih fleksibel
4. Lebih mudah untuk manage role dan permissions

---

## 🔑 CARA KERJA SISTEM

### 1. REGISTRASI

**Flow:**
```
User Register
  ↓
Input Data Lengkap:
  - Email (unique)
  - Password (akan di-hash)
  - Nama Lengkap
  - NIK (16 digit, unique)
  - Nomor Telepon
  - Alamat Lengkap
  - RT/RW
  - Jenis Kelamin
  ↓
Password di-hash dengan SHA-256
  ↓
Data disimpan ke Firestore Collection "users"
  ↓
Status: "pending" (menunggu approval admin)
```

**Code Example:**
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

final success = await authProvider.register(
  email: emailController.text,
  password: passwordController.text,
  name: nameController.text,
  nik: nikController.text,
  phone: phoneController.text,
  address: addressController.text,
  rt: rtController.text,
  rw: rwController.text,
  gender: selectedGender, // "laki-laki" atau "perempuan"
);

if (success) {
  // Registration successful
  // User masih pending, harus menunggu admin approve
}
```

---

### 2. LOGIN

**Flow:**
```
User Login
  ↓
Input Email & Password
  ↓
Query Firestore:
  - Cari user by email
  - Hash password input
  - Compare dengan password tersimpan
  ↓
Password Match?
  ├─ YES: Login Success
  │   ↓
  │   Set currentUserId
  │   Load User Data
  │   Navigate to Dashboard
  │
  └─ NO: Show Error
      "Email tidak terdaftar" atau
      "Password salah"
```

**Code Example:**
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

final success = await authProvider.signIn(
  email: emailController.text,
  password: passwordController.text,
);

if (success) {
  // Login successful
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => DashboardPage()),
  );
} else {
  // Show error
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authProvider.errorMessage ?? 'Login gagal')),
  );
}
```

---

### 3. LOGOUT

**Flow:**
```
User Logout
  ↓
Clear currentUserId
  ↓
Clear userModel
  ↓
Navigate to Login Page
```

**Code Example:**
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

await authProvider.signOut();

Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => LoginPage()),
  (route) => false,
);
```

---

### 4. UPDATE PROFILE

**Flow:**
```
User Update Profile
  ↓
Input Data Baru
  ↓
Update Firestore Document
  ↓
Reload User Data
```

**Code Example:**
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

final success = await authProvider.updateProfile(
  name: nameController.text,
  phone: phoneController.text,
  address: addressController.text,
  rt: rtController.text,
  rw: rwController.text,
);

if (success) {
  // Profile updated successfully
}
```

---

### 5. CHANGE PASSWORD

**Flow:**
```
User Change Password
  ↓
Input Old Password & New Password
  ↓
Verify Old Password
  ↓
Hash New Password
  ↓
Update Firestore Document
```

**Code Example:**
```dart
final authService = AuthService();

await authService.updatePassword(
  oldPassword: oldPasswordController.text,
  newPassword: newPasswordController.text,
);
```

---

## 🔒 KEAMANAN

### Password Hashing
- Menggunakan **SHA-256** untuk hash password
- Password TIDAK disimpan dalam plain text
- Hash tidak bisa di-reverse engineer

### Contoh:
```
Input Password: "mypassword123"
Hashed Password: "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
```

### Security Rules (Development Mode)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // ⚠️ Development only
    }
  }
}
```

**⚠️ UNTUK PRODUCTION**, ganti dengan rules yang lebih ketat:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if true; // Admin bisa read semua
      allow create: if true; // Register
      allow update: if request.auth != null; // Hanya user sendiri atau admin
      allow delete: if false; // Tidak ada delete user
    }
    
    match /warga/{wargaId} {
      allow read, write: if true; // Sesuaikan dengan kebutuhan
    }
    
    // ... rules lainnya
  }
}
```

---

## 👥 ROLE & PERMISSIONS

### Admin
- Akses penuh ke semua fitur
- Bisa approve/reject user baru
- Bisa manage semua data (warga, mutasi, keuangan, agenda)
- Bisa manage user roles

### Petugas
- Bisa manage data warga
- Bisa manage mutasi
- Bisa manage keuangan
- Bisa manage agenda
- TIDAK bisa manage user roles

### Warga
- Bisa lihat dashboard
- Bisa lihat data sendiri
- Bisa update profile sendiri
- TIDAK bisa manage data lain

---

## 📝 APPROVAL SYSTEM

### User Status Flow:
```
Register → "pending"
    ↓
Admin Review
    ↓
    ├─ Approve → "approved" (bisa login)
    │
    └─ Reject → "rejected" (tidak bisa login)
```

### Check Status di Login:
```dart
Future<Map<String, dynamic>?> signInWithEmailPassword({
  required String email,
  required String password,
}) async {
  // ... query user ...
  
  final userData = userDoc.data();
  
  // Check status
  if (userData['status'] == 'pending') {
    throw 'Akun Anda masih menunggu persetujuan admin';
  }
  
  if (userData['status'] == 'rejected') {
    throw 'Akun Anda ditolak. Silakan hubungi admin';
  }
  
  // ... check password ...
}
```

---

## 🛠️ TROUBLESHOOTING

### Error: "Email tidak terdaftar"
**Solution:**
- Pastikan email yang diinput benar
- Cek di Firestore Console apakah email ada di collection "users"

### Error: "Password salah"
**Solution:**
- Pastikan password yang diinput benar
- Case sensitive!

### Error: "Email sudah terdaftar"
**Solution:**
- Gunakan email lain
- Atau gunakan fitur forgot password (jika ada)

### Error: "NIK sudah terdaftar"
**Solution:**
- Setiap NIK hanya bisa register 1 kali
- Pastikan NIK belum pernah digunakan

### Login Stuck / Tidak Bisa Login
**Solution:**
1. Cek status user di Firestore: harus "approved"
2. Cek internet connection
3. Cek Firestore rules sudah allow read/write
4. Restart app

---

## 📊 MONITORING

### Cek Data User di Firestore Console:
1. Buka https://console.firebase.google.com
2. Pilih project
3. Klik "Firestore Database"
4. Klik collection "users"
5. Lihat semua user yang terdaftar

### Field yang Penting:
- **email**: Email user (unique)
- **password**: Password ter-hash (jangan dibagikan!)
- **status**: pending/approved/rejected
- **role**: admin/petugas/warga
- **createdAt**: Waktu registrasi

---

## ✅ CHECKLIST IMPLEMENTASI

### Backend (Firestore):
- [x] Collection "users" created
- [x] Security rules setup (development mode)
- [x] Password hashing dengan SHA-256
- [x] Email & NIK unique validation

### Frontend (Flutter):
- [x] AuthService (Firestore-based)
- [x] AuthProvider (State management)
- [x] Login page
- [x] Register page (multi-step form)
- [x] Dashboard page
- [ ] Forgot password page (optional)
- [ ] Admin approval page

### Testing:
- [ ] Test register dengan data lengkap
- [ ] Test login dengan user approved
- [ ] Test login dengan user pending (harus gagal)
- [ ] Test login dengan user rejected (harus gagal)
- [ ] Test update profile
- [ ] Test change password

---

## 🎯 NEXT STEPS

1. **Implementasi Forgot Password** (optional)
   - Bisa pakai email verification
   - Atau pakai security question
   - Atau manual reset by admin

2. **Admin Approval Page**
   - List semua user dengan status "pending"
   - Button "Approve" dan "Reject"
   - Update status di Firestore

3. **Production Security Rules**
   - Ganti rules dari "allow all" ke rules yang ketat
   - Berdasarkan role user

4. **Session Management**
   - Simpan currentUserId di SharedPreferences
   - Auto-login jika sudah pernah login
   - Logout otomatis jika token expired (optional)

---

**🔥 Happy Coding!**

