import 'dart:io';
import 'dart:convert';

/// StorageService WITHOUT Firebase Storage (karena berbayar)
/// Menggunakan base64 encoding untuk menyimpan image di Firestore
class StorageService {
  // Convert image file to base64 string
  Future<String> imageToBase64({
    required File file,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      throw 'Gagal convert image ke base64: $e';
    }
  }

  // Convert base64 string to image file (for display)
  // Returns null if conversion fails
  File? base64ToFile({
    required String base64String,
    required String filePath,
  }) {
    try {
      final bytes = base64Decode(base64String);
      final file = File(filePath);
      file.writeAsBytesSync(bytes);
      return file;
    } catch (e) {
      print('Gagal convert base64 ke file: $e');
      return null;
    }
  }

  // Validate image file (size, type, etc)
  Future<bool> validateImage({
    required File file,
    int maxSizeInMB = 5,
  }) async {
    try {
      // Check file exists
      if (!await file.exists()) {
        throw 'File tidak ditemukan';
      }

      // Check file size
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      
      if (fileSizeInMB > maxSizeInMB) {
        throw 'Ukuran file terlalu besar. Maksimal $maxSizeInMB MB';
      }

      // Check file extension
      final extension = file.path.split('.').last.toLowerCase();
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];
      
      if (!allowedExtensions.contains(extension)) {
        throw 'Format file tidak didukung. Gunakan: ${allowedExtensions.join(", ")}';
      }

      return true;
    } catch (e) {
      throw e.toString();
    }
  }

  // Get file size in MB
  Future<double> getFileSizeInMB(File file) async {
    final fileSizeInBytes = await file.length();
    return fileSizeInBytes / (1024 * 1024);
  }

  // Compress image (optional - implement if needed)
  // You can use packages like 'flutter_image_compress'
  Future<File> compressImage({
    required File file,
    int quality = 85,
  }) async {
    // TODO: Implement image compression if needed
    // For now, just return the original file
    return file;
  }
}

