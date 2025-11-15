import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper script untuk membuat user admin pertama
/// Jalankan sekali saja, lalu hapus atau comment
Future<void> createAdminUser() async {
  final firestore = FirebaseFirestore.instance;
  
  try {
    // Cek apakah admin sudah ada
    final existingAdmin = await firestore
        .collection('users')
        .where('email', isEqualTo: 'admin@jawara.com')
        .limit(1)
        .get();
    
    if (existingAdmin.docs.isNotEmpty) {
      print('❌ Admin user sudah ada!');
      return;
    }
    
    // Buat admin user dengan status approved
    await firestore.collection('users').add({
      'email': 'admin@jawara.com',
      'password': 'admin123', // Plain text for demo - hash in production!
      'nama': 'Admin Jawara',
      'nik': '1234567890123456',
      'jenisKelamin': 'Laki-laki',
      'noTelepon': '081234567890',
      'alamat': 'Jl. Contoh No. 123',
      'role': 'admin',
      'status': 'approved', // Langsung approved
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': null,
    });
    
    print('✅ Admin user berhasil dibuat!');
    print('📧 Email: admin@jawara.com');
    print('🔑 Password: admin123');
    print('✨ Status: Approved (Langsung bisa login)');
  } catch (e) {
    print('❌ Error membuat admin user: $e');
  }
}

/// Helper untuk membuat admin demo tambahan
Future<void> createDemoAdmins() async {
  final firestore = FirebaseFirestore.instance;
  
  final demoAdmins = [
    {
      'email': 'admin1@jawara.com',
      'password': 'admin123',
      'nama': 'Admin 1',
      'nik': '1234567890123457',
      'jenisKelamin': 'Laki-laki',
      'noTelepon': '081234567891',
      'alamat': 'Jl. Demo No. 1',
      'role': 'admin',
      'status': 'approved',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': null,
    },
    {
      'email': 'admin2@jawara.com',
      'password': 'admin123',
      'nama': 'Admin 2',
      'nik': '1234567890123458',
      'jenisKelamin': 'Perempuan',
      'noTelepon': '081234567892',
      'alamat': 'Jl. Demo No. 2',
      'role': 'admin',
      'status': 'approved',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': null,
    },
  ];
  
  try {
    for (var admin in demoAdmins) {
      // Cek apakah admin sudah ada
      final existing = await firestore
          .collection('users')
          .where('email', isEqualTo: admin['email'])
          .limit(1)
          .get();
      
      if (existing.docs.isEmpty) {
        await firestore.collection('users').add(admin);
        print('✅ Created admin: ${admin['email']}');
      } else {
        print('⏭️  Admin ${admin['email']} sudah ada, skip');
      }
    }
    print('\n✅ Semua demo admins berhasil dibuat!');
  } catch (e) {
    print('❌ Error membuat demo admins: $e');
  }
}
