# 🔥 FIRESTORE DATABASE STRUCTURE

⚠️ **CATATAN PENTING:** 
Project ini **TIDAK menggunakan Firebase Authentication**. Semua autentikasi dan data user disimpan langsung di **Firestore**.

Struktur database yang sudah disiapkan untuk aplikasi Jawara:

## 📊 Collections

### 1️⃣ users
```
users/{userId}
├── email: string (unique)
├── password: string (hashed SHA-256)
├── name: string
├── nik: string (16 digit, unique)
├── phone: string
├── address: string
├── rt: string
├── rw: string
├── gender: string (laki-laki/perempuan)
├── role: string (admin/petugas/warga)
├── status: string (pending/approved/rejected)
├── photoUrl: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

**Status Values:**
- **pending**: User baru register, menunggu approval admin
- **approved**: User sudah disetujui, bisa login
- **rejected**: User ditolak

**Role Values:**
- **admin**: Akses penuh ke semua fitur
- **petugas**: Akses ke fitur kelola data warga, mutasi, dll
- **warga**: Akses terbatas, hanya bisa lihat data sendiri

**Example:**
```json
{
  "email": "admin@jawara.com",
  "password": "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918", // hashed
  "name": "Admin Jawara",
  "nik": "3201234567890001",
  "phone": "081234567890",
  "address": "Jl. Contoh No. 1, RT 01 RW 02",
  "rt": "01",
  "rw": "02",
  "gender": "laki-laki",
  "role": "admin",
  "status": "approved",
  "photoUrl": "",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### 2️⃣ warga
```
warga/{wargaId}
├── nik: string
├── name: string
├── birthDate: timestamp
├── gender: string (Laki-laki/Perempuan)
├── address: string
├── phone: string
├── rt: string
├── rw: string
├── status: string (Kawin/Belum Kawin/Cerai Hidup/Cerai Mati)
├── occupation: string
├── photoUrl: string
├── createdBy: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

**Example:**
```json
{
  "nik": "3201234567890002",
  "name": "Budi Santoso",
  "birthDate": "1990-05-15T00:00:00Z",
  "gender": "Laki-laki",
  "address": "Jl. Merdeka No. 10, RT 01/RW 05",
  "phone": "081234567891",
  "rt": "001",
  "rw": "005",
  "status": "Kawin",
  "occupation": "Wiraswasta",
  "photoUrl": "https://...",
  "createdBy": "admin_user_id",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### 3️⃣ agenda
```
agenda/{agendaId}
├── title: string
├── description: string
├── date: timestamp
├── startTime: string
├── endTime: string
├── location: string
├── category: string (Rapat/Kegiatan/Sosialisasi)
├── status: string (Upcoming/Ongoing/Completed/Cancelled)
├── penanggungJawab: array[string]
├── participants: array[string]
├── createdBy: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

**Example:**
```json
{
  "title": "Rapat RT Bulanan",
  "description": "Membahas program kerja bulan depan",
  "date": "2024-02-01T00:00:00Z",
  "startTime": "19:00",
  "endTime": "21:00",
  "location": "Balai RT 01",
  "category": "Rapat",
  "status": "Upcoming",
  "penanggungJawab": ["user_id_1", "user_id_2"],
  "participants": ["user_id_3", "user_id_4"],
  "createdBy": "admin_user_id",
  "createdAt": "2024-01-15T00:00:00Z",
  "updatedAt": "2024-01-15T00:00:00Z"
}
```

### 4️⃣ keuangan
```
keuangan/{transactionId}
├── type: string (income/expense)
├── category: string
├── amount: number
├── description: string
├── date: timestamp
├── proofUrl: string (optional)
├── createdBy: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

**Example (Income):**
```json
{
  "type": "income",
  "category": "Iuran Warga",
  "amount": 500000,
  "description": "Iuran bulanan Januari 2024",
  "date": "2024-01-05T00:00:00Z",
  "proofUrl": "https://...",
  "createdBy": "admin_user_id",
  "createdAt": "2024-01-05T00:00:00Z",
  "updatedAt": "2024-01-05T00:00:00Z"
}
```

**Example (Expense):**
```json
{
  "type": "expense",
  "category": "Kebersihan",
  "amount": 200000,
  "description": "Biaya kebersihan lingkungan",
  "date": "2024-01-10T00:00:00Z",
  "proofUrl": "https://...",
  "createdBy": "admin_user_id",
  "createdAt": "2024-01-10T00:00:00Z",
  "updatedAt": "2024-01-10T00:00:00Z"
}
```

### 5️⃣ mutasi_warga
```
mutasi_warga/{mutasiId}
├── wargaId: string
├── type: string (masuk/keluar)
├── reason: string
├── fromAddress: string
├── toAddress: string
├── date: timestamp
├── dokumenUrl: string (optional)
├── createdBy: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

**Example:**
```json
{
  "wargaId": "warga_id_123",
  "type": "masuk",
  "reason": "Pindah domisili",
  "fromAddress": "Jl. Lama No. 5",
  "toAddress": "Jl. Baru No. 10",
  "date": "2024-01-15T00:00:00Z",
  "dokumenUrl": "https://...",
  "createdBy": "admin_user_id",
  "createdAt": "2024-01-15T00:00:00Z",
  "updatedAt": "2024-01-15T00:00:00Z"
}
```

### 6️⃣ notifications
```
notifications/{notificationId}
├── userId: string
├── title: string
├── message: string
├── type: string (agenda/keuangan/announcement/warga)
├── isRead: boolean
├── relatedId: string (optional)
└── createdAt: timestamp
```

**Example:**
```json
{
  "userId": "user_id_123",
  "title": "Rapat RT Besok",
  "message": "Jangan lupa hadir di rapat RT besok pukul 19:00",
  "type": "agenda",
  "isRead": false,
  "relatedId": "agenda_id_456",
  "createdAt": "2024-01-31T18:00:00Z"
}
```

---

## 🔍 Indexes

Untuk performa yang optimal, buat composite indexes berikut di Firestore:

### warga collection:
- name (Ascending) + createdAt (Descending)

### agenda collection:
- date (Ascending) + status (Ascending)
- createdBy (Ascending) + date (Descending)

### keuangan collection:
- type (Ascending) + date (Descending)
- createdBy (Ascending) + date (Descending)

### notifications collection:
- userId (Ascending) + isRead (Ascending) + createdAt (Descending)

---

## 📝 Notes:

1. Semua timestamp menggunakan server timestamp dari Firebase
2. Array fields dapat kosong []
3. Optional fields dapat null atau dihilangkan
4. ID dokumen di-generate otomatis oleh Firestore
5. createdBy selalu berisi userId yang membuat dokumen

---

## 🔒 Security Rules:

Lihat file FIREBASE_SETUP_GUIDE.md untuk security rules lengkap.

