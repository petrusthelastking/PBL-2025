# 🔧 TROUBLESHOOTING LOGIN

## Masalah: Login Gagal dengan admin@jawara.com

### Langkah Debug:

#### 1. Cek Console/Terminal saat Login

Setelah klik login, lihat output di console. Akan muncul log seperti:

**Jika User Tidak Ditemukan:**
```
=== LOGIN ATTEMPT ===
Email: admin@jawara.com
Password length: 8
🔍 Searching user in Firestore...
❌ User not found in Firestore
⚠️  PASTIKAN sudah buat admin di Firestore Console!
```

**Solusi:** Admin belum dibuat di Firestore. Ikuti langkah di `CARA_BUAT_ADMIN_FIRESTORE.md`

---

**Jika Password Salah:**
```
=== LOGIN ATTEMPT ===
Email: admin@jawara.com
✅ User found!
User data:
  - Password from DB: "admin123"
  - Password input: "admin12"
❌ Password tidak cocok!
```

**Solusi:** Ketik password dengan benar, atau cek password di Firestore Console

---

**Jika Status Bukan Approved:**
```
✅ Password cocok!
❌ Status bukan approved: pending
```

**Solusi:** Ubah field `status` di Firestore dari `"pending"` ke `"approved"`

---

**Jika Berhasil:**
```
=== LOGIN ATTEMPT ===
Email: admin@jawara.com
✅ User found!
✅ Password cocok!
✅ Status approved!
🎉 LOGIN BERHASIL!
```

---

#### 2. Cek Firestore Console

1. Buka https://console.firebase.google.com
2. Pilih project → Firestore Database
3. Cek collection `users`

**Pastikan:**
- ✅ Ada document dengan email `admin@jawara.com`
- ✅ Field `password` berisi `admin123`
- ✅ Field `role` berisi `admin`
- ✅ Field `status` berisi `approved` (BUKAN "pending")

---

#### 3. Cek Firestore Rules

Di Firebase Console → Firestore Database → Rules

Pastikan ada:
```javascript
match /users/{userId} {
  allow read: if true;  // atau if request.auth != null;
  allow create: if true;
}
```

Klik **Publish** setelah edit.

---

#### 4. Quick Fix - Buat Admin via Firebase Console

**Copy data ini ke Firestore Console:**

```
Collection: users
Document ID: (Auto-ID)

Fields:
email: "admin@jawara.com"
password: "admin123"
nama: "Admin Jawara"
nik: "1234567890123456"
jenisKelamin: "Laki-laki"
noTelepon: "081234567890"
alamat: "Jl. Admin No. 1"
role: "admin"
status: "approved"
createdAt: "2025-01-15T10:00:00.000Z"
updatedAt: null
```

**PENTING:** 
- Semua huruf kecil untuk email
- Tidak ada spasi di awal/akhir
- Status HARUS "approved" bukan "pending"

---

#### 5. Test Koneksi Firebase

Run command ini untuk cek Firebase terkoneksi:

```bash
flutter run
```

Lihat console, pastikan tidak ada error:
```
✅ Firebase initialized successfully
```

---

## Checklist Troubleshooting:

- [ ] Admin sudah dibuat di Firestore Console?
- [ ] Email: `admin@jawara.com` (huruf kecil, no spasi)?
- [ ] Password: `admin123` (8 karakter)?
- [ ] Field `status`: `"approved"` (bukan "pending")?
- [ ] Field `role`: `"admin"`?
- [ ] Firestore Rules sudah di-publish?
- [ ] App sudah hot restart (R)?
- [ ] Internet connection OK?
- [ ] Firebase project sudah benar?

---

## Jika Masih Gagal:

### Copy Log Error dari Console

1. Jalankan app: `flutter run`
2. Coba login
3. Copy semua text dari console
4. Kirim ke developer dengan info:
   - Text error dari console
   - Screenshot Firestore document
   - Screenshot error dialog di app

---

## Quick Commands:

```bash
# Clean & rebuild
flutter clean
flutter pub get
flutter run

# Hot restart
Tekan 'R' di terminal

# Stop app
Tekan 'q' di terminal
```

---

**Updated:** 15 Januari 2025
