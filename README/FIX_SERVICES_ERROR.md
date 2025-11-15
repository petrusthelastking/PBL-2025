# 🛠️ FIX: Error pada auth_provider, firestore_service, dan storage_service

## ✅ MASALAH YANG DIPERBAIKI

### 1. **firestore_service.dart** ✅
**Error:** Menggunakan `_firebaseService.currentUserId` yang sudah tidak ada di firebase_service.dart

**Solusi:**
- Mengubah method `createDocument` untuk menerima parameter `createdBy` (optional)
- `createdBy` bisa di-pass dari `auth_service.currentUserId` saat dipanggil

**Sebelum:**
```dart
Future<String> createDocument({
  required String collection,
  required Map<String, dynamic> data,
  String? docId,
}) async {
  // ...
  data['createdBy'] = _firebaseService.currentUserId; // ERROR: tidak ada
  // ...
}
```

**Sesudah:**
```dart
Future<String> createDocument({
  required String collection,
  required Map<String, dynamic> data,
  String? docId,
  String? createdBy, // NEW: optional parameter
}) async {
  // ...
  if (createdBy != null) {
    data['createdBy'] = createdBy; // FIXED
  }
  // ...
}
```

**Cara pakai:**
```dart
final authService = AuthService();
final firestoreService = FirestoreService();

await firestoreService.createDocument(
  collection: 'warga',
  data: {...},
  createdBy: authService.currentUserId, // Pass dari auth_service
);
```

---

### 2. **storage_service.dart** ✅
**Error:** 
- Menggunakan Firebase Storage yang berbayar (tidak dipakai)
- Menggunakan `_firebaseService.currentUserId` yang tidak ada

**Solusi:**
- Menghapus semua kode Firebase Storage
- Mengganti dengan **base64 encoding** untuk menyimpan image di Firestore
- Tidak perlu lagi upload ke Firebase Storage

**Sebelum:**
```dart
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  Future<String> uploadImage({...}) async {
    // Upload ke Firebase Storage (berbayar)
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putFile(file);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }
}
```

**Sesudah:**
```dart
import 'dart:convert';

class StorageService {
  // Convert image file to base64 string
  Future<String> imageToBase64({
    required File file,
  }) async {
    final bytes = await file.readAsBytes();
    final base64String = base64Encode(bytes);
    return base64String; // Simpan string ini ke Firestore
  }
  
  // Convert base64 back to file (for display)
  File? base64ToFile({...}) {...}
  
  // Validate image
  Future<bool> validateImage({...}) {...}
}
```

**Cara pakai:**
```dart
final storageService = StorageService();
final file = File('path/to/image.jpg');

// Validate dulu
await storageService.validateImage(file: file, maxSizeInMB: 5);

// Convert ke base64
final base64String = await storageService.imageToBase64(file: file);

// Simpan ke Firestore
await FirebaseFirestore.instance.collection('users').doc(userId).update({
  'photoUrl': base64String, // Simpan sebagai string
});

// Untuk display (optional):
// final file = storageService.base64ToFile(
//   base64String: userData['photoUrl'],
//   filePath: 'temp/image.jpg',
// );
```

---

### 3. **auth_provider.dart** ✅
**Error:** Ada duplikasi kode di bagian akhir file

**Solusi:**
- Menghapus kode duplikat
- File sekarang clean tanpa error

---

## 📝 RINGKASAN PERUBAHAN

### File yang Diperbaiki:
1. ✅ `lib/core/services/firestore_service.dart`
2. ✅ `lib/core/services/storage_service.dart`
3. ✅ `lib/core/providers/auth_provider.dart`

### Dependencies yang Tidak Dipakai Lagi:
- ❌ `firebase_storage` - Bisa dihapus dari pubspec.yaml (optional)

### Dependencies yang Masih Dipakai:
- ✅ `crypto` - Untuk password hashing
- ✅ `cloud_firestore` - Untuk database
- ✅ `firebase_core` - Required

---

## 🎯 CARA MENYIMPAN IMAGE SEKARANG

### ❌ CARA LAMA (Firebase Storage - Berbayar):
```dart
// Upload image ke Firebase Storage
final url = await storageService.uploadImage(file: file);

// Simpan URL ke Firestore
await firestore.update({'photoUrl': url});
```

### ✅ CARA BARU (Base64 - Gratis):
```dart
// Convert image ke base64
final base64String = await storageService.imageToBase64(file: file);

// Simpan base64 string langsung ke Firestore
await firestore.update({'photoUrl': base64String});
```

### Keuntungan Base64:
- ✅ **Gratis** (tidak perlu Firebase Storage)
- ✅ **Simple** (langsung simpan di Firestore)
- ✅ **No external URL** (data ada di satu tempat)

### Kekurangan Base64:
- ⚠️ **File size limit** - Firestore document max 1MB
- ⚠️ **Solution:** Compress image sebelum convert ke base64
- ⚠️ **Best practice:** Image < 500KB untuk performa optimal

---

## 💡 TIPS UNTUK IMAGE HANDLING

### 1. Compress Image Sebelum Upload
```dart
// TODO: Install package flutter_image_compress
// import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<File?> compressImage(File file) async {
  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    'temp/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    quality: 70, // 0-100
  );
  return result;
}

// Usage:
final compressedFile = await compressImage(originalFile);
if (compressedFile != null) {
  final base64 = await storageService.imageToBase64(file: compressedFile);
  // Save to Firestore
}
```

### 2. Resize Image
```dart
// TODO: Install package image
// import 'package:image/image.dart' as img;

Future<File?> resizeImage(File file, int maxWidth) async {
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);
  
  if (image == null) return null;
  
  final resized = img.copyResize(image, width: maxWidth);
  final resizedFile = File('temp/resized_${DateTime.now().millisecondsSinceEpoch}.jpg');
  await resizedFile.writeAsBytes(img.encodeJpg(resized, quality: 85));
  
  return resizedFile;
}
```

### 3. Validate Before Upload
```dart
try {
  // Validate image
  await storageService.validateImage(
    file: file,
    maxSizeInMB: 5, // Max 5MB
  );
  
  // Get file size
  final sizeInMB = await storageService.getFileSizeInMB(file);
  print('File size: ${sizeInMB.toStringAsFixed(2)} MB');
  
  // If > 500KB, compress first
  File finalFile = file;
  if (sizeInMB > 0.5) {
    final compressed = await compressImage(file);
    if (compressed != null) finalFile = compressed;
  }
  
  // Convert to base64
  final base64 = await storageService.imageToBase64(file: finalFile);
  
  // Save to Firestore
  await saveToFirestore(base64);
  
} catch (e) {
  print('Error: $e');
}
```

---

## 🧪 TESTING

### Test Storage Service:
```dart
// 1. Test validate image
final file = File('path/to/image.jpg');
try {
  await storageService.validateImage(file: file);
  print('✅ Image valid');
} catch (e) {
  print('❌ Image invalid: $e');
}

// 2. Test convert to base64
final base64 = await storageService.imageToBase64(file: file);
print('Base64 length: ${base64.length}');

// 3. Test convert back to file
final newFile = storageService.base64ToFile(
  base64String: base64,
  filePath: 'temp/test.jpg',
);
print('✅ Conversion successful: ${newFile != null}');
```

### Test Firestore Service:
```dart
// Create document dengan createdBy
final authService = AuthService();
final firestoreService = FirestoreService();

await firestoreService.createDocument(
  collection: 'test',
  data: {'name': 'Test'},
  createdBy: authService.currentUserId, // Pass user ID
);
```

---

## ✅ STATUS

Semua error sudah diperbaiki! 🎉

- [x] firestore_service.dart - Fixed
- [x] storage_service.dart - Fixed (no Firebase Storage)
- [x] auth_provider.dart - Fixed

**Next step:** Test aplikasi untuk memastikan semua berfungsi dengan baik!

---

**Updated:** November 12, 2025

