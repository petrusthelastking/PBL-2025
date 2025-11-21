// ============================================================================
// MOCK DATA HELPER
// ============================================================================
// File ini berisi mock data yang dapat digunakan untuk testing
// ============================================================================

/// Mock Data Generator
/// Berisi data dummy untuk testing purposes
class MockData {
  // ============================================================================
  // AUTHENTICATION DATA
  // ============================================================================

  /// Valid admin credentials untuk testing
  static const Map<String, String> validAdminCredentials = {
    'email': 'admin@jawara.com',
    'password': 'admin123',
  };

  /// Invalid credentials untuk negative testing
  static const Map<String, String> invalidCredentials = {
    'email': 'wrong@example.com',
    'password': 'wrongpassword',
  };

  /// Valid email with wrong password
  static const Map<String, String> validEmailWrongPassword = {
    'email': 'admin@jawara.com',
    'password': 'wrongpassword123',
  };

  /// Invalid email format
  static const Map<String, String> invalidEmailFormat = {
    'email': 'notanemail',
    'password': 'password123',
  };

  /// Empty credentials
  static const Map<String, String> emptyCredentials = {
    'email': '',
    'password': '',
  };

  /// Test user for registration
  static Map<String, String> getTestRegistrationData() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return {
      'email': 'test_$timestamp@jawara.com',
      'password': 'testpassword123',
      'nama': 'Test User $timestamp',
      'nik': '320123456789${timestamp.toString().substring(timestamp.toString().length - 4)}',
      'noTelepon': '081234567890',
      'alamat': 'Jl. Test No. 123',
    };
  }

  // ============================================================================
  // WARGA DATA
  // ============================================================================

  /// Generate mock warga data
  static Map<String, dynamic> getMockWargaData({String? suffix}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final id = suffix ?? timestamp.toString().substring(timestamp.toString().length - 4);

    return {
      'nik': '3201234567890$id',
      'nomorKK': '3201230101010001',
      'name': 'Test Warga $id',
      'tempatLahir': 'Jakarta',
      'birthDate': DateTime(1990, 1, 1),
      'jenisKelamin': 'Laki-laki',
      'agama': 'Islam',
      'golonganDarah': 'O',
      'pendidikan': 'S1',
      'pekerjaan': 'Karyawan Swasta',
      'statusPerkawinan': 'Belum Kawin',
      'statusPenduduk': 'Aktif',
      'statusHidup': 'Hidup',
      'peranKeluarga': 'Anak',
      'namaIbu': 'Ibu Test $id',
      'namaAyah': 'Ayah Test $id',
      'rt': '001',
      'rw': '001',
      'alamat': 'Jl. Test No. $id',
      'phone': '0812345678${id.padLeft(2, '0')}',
      'kewarganegaraan': 'Indonesia',
      'namaKeluarga': 'Keluarga Test',
    };
  }

  // ============================================================================
  // TAGIHAN DATA
  // ============================================================================

  /// Generate mock tagihan data
  static Map<String, dynamic> getMockTagihanData() {
    return {
      'jenisIuranName': 'Iuran Kebersihan',
      'keluargaName': 'Keluarga Test',
      'nominal': 50000,
      'periode': 'November 2025',
      'status': 'Belum Dibayar',
    };
  }

  // ============================================================================
  // PEMASUKAN DATA
  // ============================================================================

  /// Generate mock pemasukan data
  static Map<String, dynamic> getMockPemasukanData() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return {
      'name': 'Test Pemasukan $timestamp',
      'category': 'Donasi',
      'nominal': 100000,
      'deskripsi': 'Pemasukan untuk testing',
      'tanggal': DateTime.now(),
    };
  }

  // ============================================================================
  // PENGELUARAN DATA
  // ============================================================================

  /// Generate mock pengeluaran data
  static Map<String, dynamic> getMockPengeluaranData() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return {
      'name': 'Test Pengeluaran $timestamp',
      'category': 'Operasional',
      'nominal': 75000,
      'deskripsi': 'Pengeluaran untuk testing',
      'penerima': 'Toko Test',
      'tanggal': DateTime.now(),
    };
  }

  // ============================================================================
  // ERROR MESSAGES (Expected)
  // ============================================================================

  /// Expected error messages untuk validation testing
  static const String errorEmailRequired = 'Email harus diisi';
  static const String errorPasswordRequired = 'Password harus diisi';
  static const String errorInvalidEmail = 'Format email tidak valid';
  static const String errorWrongPassword = 'Password salah';
  static const String errorUserNotFound = 'Email tidak ditemukan';
  static const String errorAccountPending = 'Akun Anda masih menunggu persetujuan';
  static const String errorAccountRejected = 'Akun Anda ditolak';

  // ============================================================================
  // SUCCESS MESSAGES (Expected)
  // ============================================================================

  /// Expected success messages
  static const String successLogin = 'Login berhasil';
  static const String successRegister = 'Pendaftaran berhasil';
  static const String successDataSaved = 'Data berhasil disimpan';
  static const String successDataUpdated = 'Data berhasil diperbarui';
  static const String successDataDeleted = 'Data berhasil dihapus';
}

