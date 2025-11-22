# 📋 BACKEND CRUD KELOLA AGENDA - DOKUMENTASI LENGKAP

## 🎯 Overview

Backend CRUD lengkap untuk **Kelola Agenda** dengan 2 jenis:
1. **Kegiatan** (type: 'kegiatan') - Event/acara yang akan dilaksanakan
2. **Broadcast** (type: 'broadcast') - Pengumuman/informasi

## 📁 Struktur File

```
lib/
├── core/
│   ├── models/
│   │   └── agenda_model.dart          ✅ Model data
│   ├── services/
│   │   └── agenda_service.dart        ✅ Service CRUD
│   └── providers/
│       └── agenda_provider.dart       ✅ State management
└── features/
    └── agenda/
        ├── kegiatan/                  📁 UI untuk Kegiatan
        │   ├── kegiatan_page.dart
        │   ├── tambah_kegiatan_page.dart
        │   └── edit_kegiatan_page.dart
        └── broadcast/                 📁 UI untuk Broadcast
            ├── broadcast_page.dart
            ├── tambah_broadcast_page.dart
            └── edit_broadcast_page.dart
```

---

## 📦 1. AGENDA MODEL

### Fields:
```dart
class AgendaModel {
  final String id;              // Firestore document ID
  final String judul;           // Judul agenda
  final String? deskripsi;      // Deskripsi detail (optional)
  final String type;            // 'kegiatan' atau 'broadcast'
  final DateTime tanggal;       // Tanggal agenda
  final String? lokasi;         // Lokasi (optional, untuk kegiatan)
  final String? gambar;         // URL gambar (optional)
  final String createdBy;       // User ID pembuat
  final DateTime? createdAt;    // Timestamp dibuat
  final DateTime? updatedAt;    // Timestamp update terakhir
  final bool isActive;          // Status aktif/deleted
}
```

### Methods:
- ✅ `fromFirestore()` - Convert dari Firestore Document
- ✅ `toMap()` - Convert ke Map untuk Firestore
- ✅ `copyWith()` - Create copy dengan perubahan

---

## 🔧 2. AGENDA SERVICE

### CREATE Operations

#### `createAgenda(AgendaModel agenda)`
Membuat agenda baru (kegiatan/broadcast).

**Input:**
```dart
final agenda = AgendaModel(
  id: '',
  judul: 'Kerja Bakti RT',
  deskripsi: 'Membersihkan lingkungan',
  type: 'kegiatan',
  tanggal: DateTime.now().add(Duration(days: 7)),
  lokasi: 'Balai RT',
  createdBy: 'userId123',
);
await agendaService.createAgenda(agenda);
```

**Output:** `String` - Document ID

---

### READ Operations

#### `getAgendaStream()`
Stream real-time semua agenda aktif.

**Output:** `Stream<List<AgendaModel>>`
- Sorted by: `tanggal` (descending)
- Filter: `isActive = true`

#### `getAgendaByTypeStream(String type)`
Stream agenda berdasarkan type.

**Input:**
- `type`: 'kegiatan' atau 'broadcast'

**Output:** `Stream<List<AgendaModel>>`

#### `getAgendaById(String id)`
Get agenda by ID (one-time).

**Output:** `Future<AgendaModel?>`

#### `getUpcomingAgendaStream({int limit = 10})`
Stream kegiatan yang akan datang.

**Features:**
- Type: 'kegiatan' only
- Filter: `tanggal >= now`
- Sorted: ascending (terdekat dulu)
- Limit: 10 (default)

#### `getPastAgendaStream({int limit = 10})`
Stream kegiatan yang sudah lewat.

**Features:**
- Type: 'kegiatan' only
- Filter: `tanggal < now`
- Sorted: descending (terbaru dulu)

#### `getAgendaByDateRangeStream(DateTime start, DateTime end, {String? type})`
Stream agenda dalam rentang tanggal.

**Input:**
```dart
final start = DateTime(2025, 11, 1);
final end = DateTime(2025, 11, 30);
final stream = agendaService.getAgendaByDateRangeStream(start, end, type: 'kegiatan');
```

#### `searchAgenda(String keyword, {String? type})`
Search agenda by keyword.

**Search in:**
- Judul
- Deskripsi
- Lokasi

**Output:** `Future<List<AgendaModel>>`

---

### UPDATE Operations

#### `updateAgenda(String id, Map<String, dynamic> data)`
Update agenda.

**Input:**
```dart
await agendaService.updateAgenda('docId123', {
  'judul': 'Kerja Bakti RT (Updated)',
  'lokasi': 'Lapangan RT',
});
```

**Auto-added:**
- `updatedAt`: server timestamp

---

### DELETE Operations

#### `deleteAgenda(String id)`
Soft delete (set `isActive = false`).

**Benefit:** Data masih ada, bisa di-restore

#### `hardDeleteAgenda(String id)`
Hard delete (permanent).

**Benefit:** Data hilang permanen

---

### STATISTICS Operations

#### `getAgendaCountByType()`
Hitung jumlah agenda per type.

**Output:**
```dart
{
  'kegiatan': 15,
  'broadcast': 8,
  'total': 23,
}
```

#### `getAgendaSummary()`
Get statistik lengkap.

**Output:**
```dart
{
  'totalKegiatan': 15,
  'totalBroadcast': 8,
  'totalAgenda': 23,
  'upcomingKegiatan': 5,
  'pastKegiatan': 10,
}
```

---

## 🔄 3. AGENDA PROVIDER

### State Management

#### Load Data
```dart
// Load all
agendaProvider.loadAgenda();

// Load by type
agendaProvider.loadAgenda(type: 'kegiatan');
agendaProvider.loadKegiatan();
agendaProvider.loadBroadcast();

// Load upcoming/past
agendaProvider.loadUpcomingAgenda(limit: 5);
agendaProvider.loadPastAgenda(limit: 10);

// Load by date range
agendaProvider.loadAgendaByDateRange(startDate, endDate, type: 'kegiatan');
```

#### Create
```dart
final success = await agendaProvider.createAgenda(agenda);
if (success) {
  print('✅ Agenda created!');
}
```

#### Read
```dart
// Get by ID
final agenda = await agendaProvider.getAgendaById('docId123');

// Search
await agendaProvider.searchAgenda('kerja bakti', type: 'kegiatan');
final results = agendaProvider.searchResults;
```

#### Update
```dart
final success = await agendaProvider.updateAgenda('docId123', {
  'judul': 'New Title',
});
```

#### Delete
```dart
// Soft delete
final success = await agendaProvider.deleteAgenda('docId123');

// Hard delete
final success = await agendaProvider.hardDeleteAgenda('docId123');
```

#### Statistics
```dart
await agendaProvider.loadSummary();
final stats = agendaProvider.summary;
print('Total Kegiatan: ${stats['totalKegiatan']}');
```

#### Utility
```dart
// Change filter
agendaProvider.setFilterType('broadcast');

// Clear error
agendaProvider.clearError();

// Refresh all
await agendaProvider.refresh();

// Clear search
agendaProvider.clearSearch();
```

---

## 🎨 4. USAGE EXAMPLE - UI Integration

### Dalam Widget (Consumer)

```dart
Consumer<AgendaProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }

    if (provider.error != null) {
      return Text('Error: ${provider.error}');
    }

    final agendaList = provider.agendaList;
    
    return ListView.builder(
      itemCount: agendaList.length,
      itemBuilder: (context, index) {
        final agenda = agendaList[index];
        return ListTile(
          title: Text(agenda.judul),
          subtitle: Text(agenda.type),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await provider.deleteAgenda(agenda.id);
            },
          ),
        );
      },
    );
  },
)
```

### Create Agenda

```dart
ElevatedButton(
  onPressed: () async {
    final agenda = AgendaModel(
      id: '',
      judul: _judulController.text,
      deskripsi: _deskripsiController.text,
      type: 'kegiatan',
      tanggal: _selectedDate,
      lokasi: _lokasiController.text,
      createdBy: currentUserId,
    );

    final provider = Provider.of<AgendaProvider>(context, listen: false);
    final success = await provider.createAgenda(agenda);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Agenda berhasil dibuat!')),
      );
      Navigator.pop(context);
    }
  },
  child: Text('Simpan'),
)
```

### Search Agenda

```dart
TextField(
  onChanged: (value) async {
    final provider = Provider.of<AgendaProvider>(context, listen: false);
    if (value.isNotEmpty) {
      await provider.searchAgenda(value, type: 'kegiatan');
    } else {
      provider.clearSearch();
    }
  },
  decoration: InputDecoration(
    hintText: 'Cari agenda...',
    prefixIcon: Icon(Icons.search),
  ),
)
```

---

## 🔥 5. FIRESTORE STRUCTURE

### Collection: `agenda`

```
agenda/
├── docId1/
│   ├── judul: "Kerja Bakti RT"
│   ├── deskripsi: "Membersihkan lingkungan"
│   ├── type: "kegiatan"
│   ├── tanggal: Timestamp
│   ├── lokasi: "Balai RT"
│   ├── gambar: "https://..."
│   ├── createdBy: "userId123"
│   ├── createdAt: Timestamp
│   ├── updatedAt: Timestamp
│   └── isActive: true
├── docId2/
│   ├── judul: "Pengumuman Iuran"
│   ├── deskripsi: "Pembayaran iuran bulan November"
│   ├── type: "broadcast"
│   ├── tanggal: Timestamp
│   ├── createdBy: "userId456"
│   └── isActive: true
```

### Required Indexes

```
Collection: agenda
Index 1:
  - isActive (Ascending)
  - tanggal (Descending)

Index 2:
  - type (Ascending)
  - isActive (Ascending)
  - tanggal (Descending)

Index 3:
  - type (Ascending)
  - isActive (Ascending)
  - tanggal (Ascending)
```

---

## 🛡️ 6. FIRESTORE RULES

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /agenda/{agendaId} {
      // Allow read for all authenticated users
      allow read: if request.auth != null;
      
      // Allow create for Admin, Bendahara, RT, RW
      allow create: if request.auth != null && 
        (get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['Admin', 'Bendahara', 'RT', 'RW']);
      
      // Allow update for creator or Admin
      allow update: if request.auth != null && 
        (resource.data.createdBy == request.auth.uid || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'Admin');
      
      // Allow delete for Admin only
      allow delete: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'Admin';
    }
  }
}
```

---

## ✅ 7. FEATURES CHECKLIST

### CREATE ✅
- [x] Create kegiatan
- [x] Create broadcast
- [x] Auto timestamp (createdAt, updatedAt)
- [x] Set createdBy user

### READ ✅
- [x] Get all agenda (real-time stream)
- [x] Get by type (kegiatan/broadcast)
- [x] Get by ID
- [x] Get upcoming kegiatan
- [x] Get past kegiatan
- [x] Get by date range
- [x] Search by keyword
- [x] Get statistics

### UPDATE ✅
- [x] Update agenda
- [x] Auto update timestamp

### DELETE ✅
- [x] Soft delete (isActive = false)
- [x] Hard delete (permanent)

### FILTER & SEARCH ✅
- [x] Filter by type
- [x] Filter by date range
- [x] Search by keyword (judul, deskripsi, lokasi)

### STATISTICS ✅
- [x] Count by type
- [x] Summary (total, upcoming, past)

---

## 🚀 8. TESTING

### Manual Test

```dart
// 1. Create
final agenda = AgendaModel(
  id: '',
  judul: 'Test Kegiatan',
  type: 'kegiatan',
  tanggal: DateTime.now().add(Duration(days: 1)),
  createdBy: 'testUser',
);
await provider.createAgenda(agenda);

// 2. Read
provider.loadAgenda();
await Future.delayed(Duration(seconds: 1));
print('Total agenda: ${provider.agendaList.length}');

// 3. Update
await provider.updateAgenda(agendaId, {'judul': 'Updated Title'});

// 4. Delete
await provider.deleteAgenda(agendaId);

// 5. Search
await provider.searchAgenda('test');
print('Search results: ${provider.searchResults.length}');
```

---

## 📊 9. PERFORMANCE TIPS

1. **Use Streams for Real-time** - UI auto-update ketika data berubah
2. **Limit Queries** - Gunakan limit untuk data besar
3. **Index Firestore** - Pastikan index sudah dibuat
4. **Pagination** - Untuk list panjang, gunakan pagination
5. **Cache** - Provider sudah cache data di memory

---

## 🐛 10. TROUBLESHOOTING

### Error: "Missing Index"
**Solution:** Klik link di console log untuk create index

### Error: "Permission Denied"
**Solution:** Check Firestore Rules

### Data tidak muncul
**Solution:** 
1. Check `isActive = true`
2. Check user authentication
3. Check console log untuk error

---

## 📝 11. CHANGELOG

**Version 1.0.0** - 22 November 2025
- ✅ Initial CRUD implementation
- ✅ Service layer complete
- ✅ Provider with state management
- ✅ Search & filter features
- ✅ Statistics & summary
- ✅ Real-time streams
- ✅ Soft & hard delete

---

**Last Updated:** 22 November 2025
**Status:** ✅ PRODUCTION READY
**Maintained by:** Development Team

