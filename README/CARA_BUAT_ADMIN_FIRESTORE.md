# 🔐 CARA MEMBUAT ADMIN DI FIRESTORE CONSOLE

## Langkah-langkah Setup Admin

### 1. Buka Firebase Console
1. Buka browser, ke https://console.firebase.google.com
2. Login dengan akun Google Anda
3. Pilih project **Jawara** (atau nama project Anda)

### 2. Buka Firestore Database
1. Di menu kiri, klik **"Firestore Database"**
2. Jika belum dibuat, klik **"Create database"**
   - Pilih **"Start in test mode"** (untuk development)
   - Pilih location terdekat (misalnya: asia-southeast2)
   - Klik **"Enable"**

### 3. Buat Collection "users"
1. Klik tombol **"Start collection"**
2. Collection ID: `users`
3. Klik **"Next"**

### 4. Tambah Document Admin
Pada halaman "Add document", isi field-field berikut:

#### Document ID
- Pilih **"Auto-ID"** (biarkan Firebase generate otomatis)

#### Fields (Klik "Add field" untuk setiap field):

| Field Name | Type | Value |
|------------|------|-------|
| `email` | string | `admin@jawara.com` |
| `password` | string | `admin123` |
| `nama` | string | `Admin Jawara` |
| `nik` | string | `1234567890123456` |
| `jenisKelamin` | string | `Laki-laki` |
| `noTelepon` | string | `081234567890` |
| `alamat` | string | `Jl. Admin No. 1` |
| `role` | string | `admin` |
| `status` | string | `approved` |
| `createdAt` | string | `2025-01-15T10:00:00.000Z` |
| `updatedAt` | null | (kosongkan) |

### 5. Cara Input Field di Console:

**Contoh untuk field "email":**
```
Field: email
Type: string
Value: admin@jawara.com
```
Klik "Add field" untuk field berikutnya.

**Contoh untuk field "updatedAt" (null):**
```
Field: updatedAt
Type: null
(tidak ada value)
```

### 6. Save Document
1. Setelah semua field diisi, klik **"Save"**
2. Document admin akan muncul di collection "users"

### 7. Verifikasi
Pastikan document terlihat seperti ini:

```
Collection: users
├─ [Auto-Generated ID]
   ├─ email: "admin@jawara.com"
   ├─ password: "admin123"
   ├─ nama: "Admin Jawara"
   ├─ nik: "1234567890123456"
   ├─ jenisKelamin: "Laki-laki"
   ├─ noTelepon: "081234567890"
   ├─ alamat: "Jl. Admin No. 1"
   ├─ role: "admin"
   ├─ status: "approved"
   ├─ createdAt: "2025-01-15T10:00:00.000Z"
   └─ updatedAt: null
```

---

## 🎉 Selesai!

Sekarang Anda bisa login ke aplikasi dengan:

```
📧 Email: admin@jawara.com
🔑 Password: admin123
```

---

## 📝 Catatan Penting:

### ⚠️ Security (Untuk Production):
1. **Ganti password** di Firestore setelah login pertama
2. **Hash password** menggunakan algoritma bcrypt/sha256
3. **Update Firestore Rules** agar lebih ketat
4. **Jangan share kredensial** admin ke orang lain

### 🔐 Firestore Rules:
Rules sudah ada di file `firestore.rules`. Deploy dengan cara:
1. Di Firebase Console → Firestore Database → **Rules**
2. Copy paste isi file `firestore.rules`
3. Klik **"Publish"**

### 👥 Membuat Admin Tambahan:
Ulangi langkah 4-6 dengan email berbeda:
- `admin2@jawara.com`
- `admin3@jawara.com`
- dst.

---

## 🐛 Troubleshooting:

**❌ Login gagal "Email atau password salah"**
- Cek ejaan email di Firestore (huruf kecil semua)
- Pastikan tidak ada spasi di email atau password
- Cek field `status` harus `"approved"` bukan `"pending"`

**❌ "Akun masih menunggu persetujuan"**
- Field `status` masih `"pending"`, ubah ke `"approved"`

**❌ "Permission denied"**
- Deploy Firestore Rules (lihat bagian Security di atas)
- Pastikan rules allow create: if true untuk collection users

---

## ✅ Checklist:

- [ ] Buka Firebase Console
- [ ] Buat Firestore Database
- [ ] Buat collection "users"
- [ ] Tambah document dengan 11 fields
- [ ] Pastikan role = "admin"
- [ ] Pastikan status = "approved"
- [ ] Save document
- [ ] Deploy Firestore Rules
- [ ] Test login di aplikasi
- [ ] Login berhasil? ✅

---

**Dibuat:** 15 Januari 2025  
**Untuk:** Aplikasi Jawara - Admin Panel
