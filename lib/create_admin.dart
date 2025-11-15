import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================================
// ADMIN SETUP SERVICE
// ============================================================================
// Service untuk inisialisasi admin pertama kali
// Gunakan hanya untuk development/setup awal
// ============================================================================

/// Konstanta untuk admin default
class AdminConstants {
  static const String defaultEmail = 'admin@jawara.com';
  static const String defaultPassword = 'admin123';
  static const String defaultName = 'Admin Jawara';
  static const String defaultNik = '1234567890123456';
  static const String defaultPhone = '081234567890';
  static const String defaultAddress = 'Jl. Contoh No. 123';

  // Collection name
  static const String usersCollection = 'users';

  // Role & Status
  static const String adminRole = 'admin';
  static const String approvedStatus = 'approved';
}

/// Model data untuk admin user
class AdminUserData {
  final String email;
  final String password;
  final String nama;
  final String nik;
  final String jenisKelamin;
  final String noTelepon;
  final String alamat;
  final String role;
  final String status;

  AdminUserData({
    required this.email,
    required this.password,
    required this.nama,
    required this.nik,
    required this.jenisKelamin,
    required this.noTelepon,
    required this.alamat,
    this.role = AdminConstants.adminRole,
    this.status = AdminConstants.approvedStatus,
  });

  /// Convert ke Map untuk Firestore
  Map<String, dynamic> toFirestoreMap() {
    return {
      'email': email,
      'password': password,
      'nama': nama,
      'nik': nik,
      'jenisKelamin': jenisKelamin,
      'noTelepon': noTelepon,
      'alamat': alamat,
      'role': role,
      'status': status,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': null,
    };
  }
}

/// Service untuk manage admin users
class AdminSetupService {
  final FirebaseFirestore _firestore;

  AdminSetupService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Cek apakah user dengan email tertentu sudah ada
  Future<bool> _isUserExists(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(AdminConstants.usersCollection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('❌ Error checking user existence: $e');
      return false;
    }
  }

  /// Buat admin user baru
  Future<bool> _createAdmin(AdminUserData adminData) async {
    try {
      await _firestore
          .collection(AdminConstants.usersCollection)
          .add(adminData.toFirestoreMap());

      return true;
    } catch (e) {
      print('❌ Error creating admin: $e');
      return false;
    }
  }

  /// Buat admin default (admin@jawara.com)
  Future<void> createDefaultAdmin() async {
    print('🔧 Membuat admin default...');

    final defaultAdmin = AdminUserData(
      email: AdminConstants.defaultEmail,
      password: AdminConstants.defaultPassword,
      nama: AdminConstants.defaultName,
      nik: AdminConstants.defaultNik,
      jenisKelamin: 'Laki-laki',
      noTelepon: AdminConstants.defaultPhone,
      alamat: AdminConstants.defaultAddress,
    );

    // Cek apakah sudah ada
    final exists = await _isUserExists(defaultAdmin.email);
    if (exists) {
      print('⏭️  Admin default sudah ada, skip.');
      return;
    }
    
    // Buat admin baru
    final success = await _createAdmin(defaultAdmin);
    if (success) {
      print('✅ Admin default berhasil dibuat!');
      print('📧 Email: ${defaultAdmin.email}');
      print('🔑 Password: ${defaultAdmin.password}');
      print('✨ Status: Approved (Langsung bisa login)');
    }
  }

  /// Buat multiple admin sekaligus
  Future<void> createMultipleAdmins(List<AdminUserData> admins) async {
    print('🔧 Membuat ${admins.length} admin...\n');

    int created = 0;
    int skipped = 0;

    for (var adminData in admins) {
      // Cek apakah sudah ada
      final exists = await _isUserExists(adminData.email);
      if (exists) {
        print('⏭️  ${adminData.email} sudah ada, skip.');
        skipped++;
        continue;
      }

      // Buat admin baru
      final success = await _createAdmin(adminData);
      if (success) {
        print('✅ Created: ${adminData.email}');
        created++;
      }
    }

    print('\n📊 Summary:');
    print('   ✅ Created: $created');
    print('   ⏭️  Skipped: $skipped');
  }
}

// ============================================================================
// HELPER FUNCTIONS (untuk backward compatibility)
// ============================================================================

/// Helper untuk membuat admin default
/// [DEPRECATED] Gunakan AdminSetupService.createDefaultAdmin() sebagai gantinya
Future<void> createAdminUser() async {
  final service = AdminSetupService();
  await service.createDefaultAdmin();
}

/// Helper untuk membuat demo admins
/// [DEPRECATED] Gunakan AdminSetupService.createMultipleAdmins() sebagai gantinya
Future<void> createDemoAdmins() async {
  final demoAdmins = [
    AdminUserData(
      email: 'admin1@jawara.com',
      password: 'admin123',
      nama: 'Admin 1',
      nik: '1234567890123457',
      jenisKelamin: 'Laki-laki',
      noTelepon: '081234567891',
      alamat: 'Jl. Demo No. 1',
    ),
    AdminUserData(
      email: 'admin2@jawara.com',
      password: 'admin123',
      nama: 'Admin 2',
      nik: '1234567890123458',
      jenisKelamin: 'Perempuan',
      noTelepon: '081234567892',
      alamat: 'Jl. Demo No. 2',
    ),
  ];
  
  final service = AdminSetupService();
  await service.createMultipleAdmins(demoAdmins);
}
