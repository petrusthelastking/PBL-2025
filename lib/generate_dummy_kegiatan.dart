import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Script untuk generate dummy data Kegiatan
/// Jalankan dengan: flutter run lib/generate_dummy_kegiatan.dart
class GenerateDummyKegiatan {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Data dummy kegiatan yang realistis
  final List<Map<String, dynamic>> _dummyKegiatan = [
    {
      'judul': 'Kerja Bakti Bersih Lingkungan',
      'type': 'kegiatan',
      'tanggal': DateTime(2025, 11, 30, 8, 0), // 30 Nov 2025, 08:00
      'lokasi': 'Taman RT 05',
      'deskripsi': 'Kegiatan membersihkan lingkungan sekitar taman RT 05. Membawa alat kebersihan masing-masing. Akan disediakan makanan ringan dan minuman.',
      'isActive': true,
      'createdBy': 'Admin RT',
    },
    {
      'judul': 'Rapat Koordinasi RT',
      'type': 'kegiatan',
      'tanggal': DateTime(2025, 12, 5, 19, 30), // 5 Des 2025, 19:30
      'lokasi': 'Balai RT',
      'deskripsi': 'Rapat koordinasi bulanan untuk membahas program kerja bulan Desember dan persiapan perayaan tahun baru.',
      'isActive': true,
      'createdBy': 'Ketua RT',
    },
    {
      'judul': 'Posyandu Balita',
      'type': 'kegiatan',
      'tanggal': DateTime(2025, 12, 10, 9, 0), // 10 Des 2025, 09:00
      'lokasi': 'Posyandu RT 05',
      'deskripsi': 'Pelayanan kesehatan untuk balita meliputi penimbangan, pemberian vitamin, dan imunisasi. Bawa buku KIA dan KMS.',
      'isActive': true,
      'createdBy': 'Kader Posyandu',
    },
    {
      'judul': 'Pengajian Rutin Ibu-Ibu',
      'type': 'kegiatan',
      'tanggal': DateTime(2025, 12, 12, 15, 0), // 12 Des 2025, 15:00
      'lokasi': 'Musholla Al-Ikhlas',
      'deskripsi': 'Pengajian rutin mingguan untuk ibu-ibu. Tema: Pendidikan Anak dalam Islam. Pembicara: Ustadzah Siti Aminah.',
      'isActive': true,
      'createdBy': 'Takmir Musholla',
    },
    {
      'judul': 'Senam Sehat Warga',
      'type': 'kegiatan',
      'tanggal': DateTime(2025, 12, 15, 6, 30), // 15 Des 2025, 06:30
      'lokasi': 'Lapangan RT',
      'deskripsi': 'Senam sehat bersama untuk semua warga. Instruktur: Bu Rina. Gratis untuk semua peserta. Bawa matras/alas sendiri.',
      'isActive': true,
      'createdBy': 'Karang Taruna',
    },
    {
      'judul': 'Lomba 17 Agustus - Persiapan',
      'type': 'kegiatan',
      'tanggal': DateTime(2025, 12, 20, 16, 0), // 20 Des 2025, 16:00
      'lokasi': 'Balai RT',
      'deskripsi': 'Rapat persiapan lomba 17 Agustus. Membahas jenis lomba, hadiah, dan kepanitiaan.',
      'isActive': true,
      'createdBy': 'Ketua Pemuda',
    },
    {
      'judul': 'Bazaar Produk UMKM Warga',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 1, 5, 10, 0), // 5 Jan 2026, 10:00
      'lokasi': 'Halaman Balai RT',
      'deskripsi': 'Bazaar untuk mempromosikan produk UMKM warga. Gratis untuk peserta, dibuka untuk umum. Stand terbatas 20 peserta.',
      'isActive': true,
      'createdBy': 'Admin RT',
    },
    {
      'judul': 'Gotong Royong Perbaikan Jalan',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 1, 12, 7, 0), // 12 Jan 2026, 07:00
      'lokasi': 'Jalan RT 05',
      'deskripsi': 'Gotong royong memperbaiki jalan yang rusak. Membawa cangkul, sekop, dan peralatan lainnya. Semen dan pasir sudah disiapkan.',
      'isActive': true,
      'createdBy': 'Sekretaris RT',
    },
    {
      'judul': 'Pelatihan Komputer Gratis',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 1, 18, 13, 0), // 18 Jan 2026, 13:00
      'lokasi': 'Balai RT (Lab Komputer)',
      'deskripsi': 'Pelatihan komputer dasar untuk warga (Microsoft Word & Excel). Gratis, peserta maksimal 15 orang. Daftar ke Admin.',
      'isActive': true,
      'createdBy': 'Karang Taruna',
    },
    {
      'judul': 'Arisan RT Bulanan',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 1, 25, 19, 0), // 25 Jan 2026, 19:00
      'lokasi': 'Rumah Pak RT',
      'deskripsi': 'Arisan rutin RT bulan Januari. Iuran Rp 50.000. Undian door prize dan makan bersama.',
      'isActive': true,
      'createdBy': 'Bendahara RT',
    },
    {
      'judul': 'Donor Darah PMI',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 2, 1, 8, 0), // 1 Feb 2026, 08:00
      'lokasi': 'Balai RT',
      'deskripsi': 'Kegiatan donor darah bekerja sama dengan PMI. Syarat: sehat, usia 17-60 tahun, berat minimal 45kg. Dapat sertifikat dan snack.',
      'isActive': true,
      'createdBy': 'Admin RT',
    },
    {
      'judul': 'Pelatihan Hidroponik',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 2, 8, 9, 0), // 8 Feb 2026, 09:00
      'lokasi': 'Taman Edukasi RT',
      'deskripsi': 'Pelatihan berkebun hidroponik untuk warga. Narasumber: Pak Budi (ahli pertanian). Gratis, dapat starter kit.',
      'isActive': true,
      'createdBy': 'PKK RT',
    },
    {
      'judul': 'Lomba Kebersihan Antar RW',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 2, 14, 14, 0), // 14 Feb 2026, 14:00
      'lokasi': 'Seluruh Area RT 05',
      'deskripsi': 'Penilaian lomba kebersihan tingkat RW. Pastikan lingkungan rumah dan jalan bersih. Hadiah total 5 juta rupiah.',
      'isActive': true,
      'createdBy': 'Ketua RT',
    },
    {
      'judul': 'Peringatan Maulid Nabi',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 2, 20, 20, 0), // 20 Feb 2026, 20:00
      'lokasi': 'Musholla Al-Ikhlas',
      'deskripsi': 'Peringatan Maulid Nabi Muhammad SAW dengan pengajian dan santunan anak yatim. Sambutan Ketua RT dan ceramah Ustadz.',
      'isActive': true,
      'createdBy': 'Takmir Musholla',
    },
    {
      'judul': 'Turnamen Voli RT',
      'type': 'kegiatan',
      'tanggal': DateTime(2026, 2, 28, 16, 0), // 28 Feb 2026, 16:00
      'lokasi': 'Lapangan Voli RT',
      'deskripsi': 'Turnamen voli antar RT. Pendaftaran dibuka untuk 8 tim. Hadiah juara 1: Rp 1.000.000. Daftar ke Pak Budi.',
      'isActive': true,
      'createdBy': 'Ketua Pemuda',
    },
  ];

  /// Generate dummy kegiatan ke Firestore
  Future<void> generateKegiatan() async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 GENERATING DUMMY KEGIATAN...');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      int successCount = 0;
      int errorCount = 0;

      for (var i = 0; i < _dummyKegiatan.length; i++) {
        try {
          final data = _dummyKegiatan[i];
          
          // Tambahkan createdAt dan updatedAt
          final docData = {
            ...data,
            'tanggal': Timestamp.fromDate(data['tanggal']),
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          };

          // Add to Firestore
          final docRef = await _firestore.collection('agenda').add(docData);

          successCount++;
          debugPrint('✅ [${i + 1}/${_dummyKegiatan.length}] ${data['judul']}');
          debugPrint('   ID: ${docRef.id}');
          debugPrint('   Tanggal: ${data['tanggal']}');
          debugPrint('   Lokasi: ${data['lokasi']}');
          
        } catch (e) {
          errorCount++;
          debugPrint('❌ Error creating kegiatan ${i + 1}: $e');
        }
      }

      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('📊 SUMMARY:');
      debugPrint('   Total: ${_dummyKegiatan.length}');
      debugPrint('   Success: $successCount ✅');
      debugPrint('   Failed: $errorCount ❌');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      if (successCount > 0) {
        debugPrint('✨ Dummy kegiatan berhasil ditambahkan ke Firestore!');
        debugPrint('🔍 Cek di Firebase Console → Firestore → agenda');
      }

    } catch (e) {
      debugPrint('❌ Fatal error: $e');
      rethrow;
    }
  }

  /// Hapus semua kegiatan (untuk reset)
  Future<void> deleteAllKegiatan() async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🗑️  DELETING ALL KEGIATAN...');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final snapshot = await _firestore
          .collection('agenda')
          .where('type', isEqualTo: 'kegiatan')
          .get();

      int deletedCount = 0;

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        deletedCount++;
        debugPrint('🗑️  Deleted: ${doc.data()['judul']}');
      }

      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('✅ Total deleted: $deletedCount kegiatan');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    } catch (e) {
      debugPrint('❌ Error deleting kegiatan: $e');
      rethrow;
    }
  }

  /// Generate kegiatan dengan jumlah custom
  Future<void> generateCustomKegiatan(int count) async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 GENERATING $count RANDOM KEGIATAN...');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final random = DateTime.now().millisecondsSinceEpoch;
      int successCount = 0;

      for (var i = 0; i < count; i++) {
        try {
          // Pilih random dari template
          final template = _dummyKegiatan[i % _dummyKegiatan.length];
          
          // Generate tanggal random (1-90 hari ke depan)
          final randomDays = (random % 90) + 1;
          final randomDate = DateTime.now().add(Duration(days: randomDays));

          final data = {
            'judul': '${template['judul']} #${i + 1}',
            'type': 'kegiatan',
            'tanggal': Timestamp.fromDate(randomDate),
            'lokasi': template['lokasi'],
            'deskripsi': template['deskripsi'],
            'isActive': true,
            'createdBy': template['createdBy'],
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          };

          await _firestore.collection('agenda').add(data);
          successCount++;
          debugPrint('✅ [$successCount/$count] ${data['judul']}');

        } catch (e) {
          debugPrint('❌ Error: $e');
        }
      }

      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('✅ Generated $successCount kegiatan');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    } catch (e) {
      debugPrint('❌ Fatal error: $e');
      rethrow;
    }
  }
}

