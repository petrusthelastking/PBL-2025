import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Script untuk generate dummy data pengeluaran ke Firestore
/// Run this file to populate pengeluaran collection with dummy data
class GenerateDummyPengeluaran {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> generate({int count = 50}) async {
    try {
      debugPrint('🚀 Starting to generate $count dummy pengeluaran data...');

      final List<String> categories = [
        'Operasional',
        'Infrastruktur',
        'Utilitas',
        'Kegiatan',
        'Administrasi',
        'Lainnya',
      ];

      final List<String> names = [
        'Pembelian Alat Kebersihan',
        'Perbaikan Jalan Utama',
        'Pembayaran Listrik Bulanan',
        'Kegiatan 17 Agustus',
        'Biaya Administrasi',
        'Pembelian ATK',
        'Perbaikan Pagar',
        'Pembayaran Air PDAM',
        'Kegiatan Posyandu',
        'Pembelian Lampu Jalan',
        'Perbaikan Selokan',
        'Biaya Internet RT',
        'Kegiatan Kerja Bakti',
        'Pembelian Cat Tembok',
        'Perbaikan Atap Pos Ronda',
        'Pembayaran Sampah',
        'Kegiatan PKK',
        'Pembelian Buku Tamu',
        'Perbaikan Papan Nama',
        'Biaya Konsumsi Rapat',
      ];

      final List<String> penerima = [
        'Toko Makmur Jaya',
        'CV. Karya Mandiri',
        'Toko Bangunan Sejahtera',
        'PT. Listrik Negara',
        'PDAM Kota',
        'Warung Pak Budi',
        'Toko Alat Tulis',
        'CV. Kontraktor Jaya',
        'Toko Material',
        'Warung Makan Bu Siti',
        'Toko Cat & Bangunan',
        'Provider Internet',
        'Pedagang Sayur',
        'Toko Listrik',
        'CV. Pembangunan',
        'Petugas Kebersihan',
        'Katering Bu Ani',
        'Toko Buku',
        'Percetakan Digital',
        'Supplier ATK',
      ];

      final List<String> deskripsi = [
        'Pembelian untuk kebutuhan kebersihan lingkungan RT',
        'Perbaikan jalan berlubang di area RT',
        'Pembayaran tagihan bulanan untuk fasilitas umum',
        'Biaya penyelenggaraan kegiatan kemerdekaan',
        'Biaya administrasi dan surat menyurat',
        'Pembelian keperluan kantor RT',
        'Perbaikan fasilitas umum yang rusak',
        'Pembayaran utilitas untuk kepentingan bersama',
        'Dana kegiatan sosial warga',
        'Pemeliharaan fasilitas RT/RW',
      ];

      final List<String> statuses = ['Menunggu', 'Terverifikasi', 'Ditolak'];
      final List<double> weights = [0.2, 0.7, 0.1]; // 20% menunggu, 70% terverifikasi, 10% ditolak

      final now = DateTime.now();
      int successCount = 0;

      for (int i = 0; i < count; i++) {
        try {
          // Random date dalam 6 bulan terakhir
          final randomDays = (i * 180 / count).floor(); // Spread across 6 months
          final tanggal = now.subtract(Duration(days: randomDays));

          // Random nominal antara 50k - 5jt
          final baseNominal = [50000, 100000, 200000, 300000, 500000, 750000, 1000000, 2000000, 3000000, 5000000];
          final nominal = baseNominal[i % baseNominal.length].toDouble();

          // Random category
          final category = categories[i % categories.length];

          // Random name
          final name = names[i % names.length];

          // Random penerima
          final penerimaName = penerima[i % penerima.length];

          // Random deskripsi
          final desc = deskripsi[i % deskripsi.length];

          // Random status dengan weight
          final random = (i % 10) / 10; // Pseudo random 0-1
          String status;
          if (random < weights[0]) {
            status = statuses[0]; // Menunggu
          } else if (random < weights[0] + weights[1]) {
            status = statuses[1]; // Terverifikasi
          } else {
            status = statuses[2]; // Ditolak
          }

          // Create pengeluaran document
          final docRef = _firestore.collection('pengeluaran').doc();

          await docRef.set({
            'name': '$name ${i + 1}',
            'category': category,
            'nominal': nominal,
            'deskripsi': desc,
            'tanggal': Timestamp.fromDate(tanggal),
            'status': status,
            'penerima': penerimaName,
            'createdBy': 'system_generator@admin.com',
            'createdAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
            'isActive': true,
            'bukti': null,
          });

          successCount++;

          if ((i + 1) % 10 == 0) {
            debugPrint('✅ Generated ${i + 1}/$count pengeluaran...');
          }

        } catch (e) {
          debugPrint('❌ Error generating pengeluaran #${i + 1}: $e');
        }
      }

      debugPrint('');
      debugPrint('🎉 Successfully generated $successCount/$count dummy pengeluaran data!');
      debugPrint('');
      debugPrint('📊 Summary:');
      debugPrint('   - Total records: $successCount');
      debugPrint('   - Categories: ${categories.length} types');
      debugPrint('   - Date range: Last 6 months');
      debugPrint('   - Status distribution: 20% Menunggu, 70% Terverifikasi, 10% Ditolak');
      debugPrint('   - Nominal range: Rp 50.000 - Rp 5.000.000');
      debugPrint('');

    } catch (e) {
      debugPrint('❌ Fatal error generating dummy data: $e');
    }
  }

  /// Delete all dummy data (cleanup)
  static Future<void> deleteAll() async {
    try {
      debugPrint('🗑️ Deleting all pengeluaran data...');

      final snapshot = await _firestore.collection('pengeluaran').get();

      int deleteCount = 0;
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        deleteCount++;
      }

      debugPrint('✅ Deleted $deleteCount pengeluaran records');
    } catch (e) {
      debugPrint('❌ Error deleting data: $e');
    }
  }

  /// Delete only dummy data (created by system_generator)
  static Future<void> deleteDummyOnly() async {
    try {
      debugPrint('🗑️ Deleting dummy pengeluaran data...');

      final snapshot = await _firestore
          .collection('pengeluaran')
          .where('createdBy', isEqualTo: 'system_generator@admin.com')
          .get();

      int deleteCount = 0;
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        deleteCount++;
      }

      debugPrint('✅ Deleted $deleteCount dummy pengeluaran records');
    } catch (e) {
      debugPrint('❌ Error deleting dummy data: $e');
    }
  }
}

