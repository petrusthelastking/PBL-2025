import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/laporan_keuangan_detail_model.dart';

/// Service untuk Detail Laporan Keuangan
/// Menggabungkan data dari 3 collection
class LaporanKeuanganDetailService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get semua transaksi keuangan (gabungan) dengan limit
  Future<List<LaporanKeuanganDetail>> getAllTransaksi({int limit = 50}) async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 Fetching all transactions (limit: $limit)...');

      List<LaporanKeuanganDetail> allTransaksi = [];

      // 1. Fetch Pemasukan dari Iuran
      debugPrint('   📥 Fetching iuran...');
      final iuranSnapshot = await _firestore
          .collection('jenis_iuran')
          .orderBy('tanggal_pembayaran', descending: true)
          .limit(limit)
          .get();

      for (var doc in iuranSnapshot.docs) {
        final data = doc.data();
        final jenisIuranNama = data['nama_iuran'] ?? 'Iuran Umum';

        allTransaksi.add(
          LaporanKeuanganDetail.fromIuran(doc, jenisIuranNama),
        );
      }
      debugPrint('   ✅ Iuran: ${iuranSnapshot.docs.length} data');

      // 2. Fetch Pemasukan Lain
      debugPrint('   📥 Fetching pemasukan lain...');
      final pemasukanLainSnapshot = await _firestore
          .collection('pemasukan_lain')
          .orderBy('tanggal', descending: true)
          .limit(limit)
          .get();

      for (var doc in pemasukanLainSnapshot.docs) {
        allTransaksi.add(
          LaporanKeuanganDetail.fromPemasukanLain(doc),
        );
      }
      debugPrint('   ✅ Pemasukan Lain: ${pemasukanLainSnapshot.docs.length} data');

      // 3. Fetch Pengeluaran
      debugPrint('   📥 Fetching pengeluaran...');
      final pengeluaranSnapshot = await _firestore
          .collection('pengeluaran')
          .orderBy('tanggal', descending: true)
          .limit(limit)
          .get();

      for (var doc in pengeluaranSnapshot.docs) {
        allTransaksi.add(
          LaporanKeuanganDetail.fromPengeluaran(doc),
        );
      }
      debugPrint('   ✅ Pengeluaran: ${pengeluaranSnapshot.docs.length} data');

      // Sort by tanggal (terbaru dulu)
      allTransaksi.sort(LaporanKeuanganDetail.compareByDate);

      // Limit hasil akhir
      if (allTransaksi.length > limit) {
        allTransaksi = allTransaksi.sublist(0, limit);
      }

      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('✅ Total transaksi: ${allTransaksi.length}');
      debugPrint('   Iuran: ${allTransaksi.where((e) => e.type == 'iuran').length}');
      debugPrint('   Pemasukan Lain: ${allTransaksi.where((e) => e.type == 'pemasukan_lain').length}');
      debugPrint('   Pengeluaran: ${allTransaksi.where((e) => e.type == 'pengeluaran').length}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      return allTransaksi;
    } catch (e) {
      debugPrint('❌ Error fetching all transaksi: $e');
      rethrow;
    }
  }

  /// Get transaksi dengan filter tanggal
  Future<List<LaporanKeuanganDetail>> getTransaksiByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 100,
  }) async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 Fetching transaksi from ${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}');

      List<LaporanKeuanganDetail> allTransaksi = [];

      // 1. Fetch Iuran
      final iuranSnapshot = await _firestore
          .collection('jenis_iuran')
          .where('tanggal_pembayaran', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('tanggal_pembayaran', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('tanggal_pembayaran', descending: true)
          .limit(limit)
          .get();

      for (var doc in iuranSnapshot.docs) {
        final data = doc.data();
        final jenisIuranNama = data['nama_iuran'] ?? 'Iuran Umum';
        allTransaksi.add(LaporanKeuanganDetail.fromIuran(doc, jenisIuranNama));
      }

      // 2. Fetch Pemasukan Lain
      final pemasukanLainSnapshot = await _firestore
          .collection('pemasukan_lain')
          .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('tanggal', descending: true)
          .limit(limit)
          .get();

      for (var doc in pemasukanLainSnapshot.docs) {
        allTransaksi.add(LaporanKeuanganDetail.fromPemasukanLain(doc));
      }

      // 3. Fetch Pengeluaran
      final pengeluaranSnapshot = await _firestore
          .collection('pengeluaran')
          .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('tanggal', descending: true)
          .limit(limit)
          .get();

      for (var doc in pengeluaranSnapshot.docs) {
        allTransaksi.add(LaporanKeuanganDetail.fromPengeluaran(doc));
      }

      // Sort by tanggal
      allTransaksi.sort(LaporanKeuanganDetail.compareByDate);

      debugPrint('✅ Total transaksi dalam range: ${allTransaksi.length}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      return allTransaksi;
    } catch (e) {
      debugPrint('❌ Error fetching transaksi by date range: $e');
      rethrow;
    }
  }

  /// Get transaksi dengan filter type
  Future<List<LaporanKeuanganDetail>> getTransaksiByType({
    required String type, // 'iuran', 'pemasukan_lain', 'pengeluaran'
    int limit = 50,
  }) async {
    try {
      debugPrint('🔄 Fetching transaksi type: $type (limit: $limit)');

      List<LaporanKeuanganDetail> transaksi = [];

      if (type == 'iuran') {
        final snapshot = await _firestore
            .collection('jenis_iuran')
            .orderBy('tanggal_pembayaran', descending: true)
            .limit(limit)
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final jenisIuranNama = data['nama_iuran'] ?? 'Iuran Umum';
          transaksi.add(LaporanKeuanganDetail.fromIuran(doc, jenisIuranNama));
        }
      } else if (type == 'pemasukan_lain') {
        final snapshot = await _firestore
            .collection('pemasukan_lain')
            .orderBy('tanggal', descending: true)
            .limit(limit)
            .get();

        for (var doc in snapshot.docs) {
          transaksi.add(LaporanKeuanganDetail.fromPemasukanLain(doc));
        }
      } else if (type == 'pengeluaran') {
        final snapshot = await _firestore
            .collection('pengeluaran')
            .orderBy('tanggal', descending: true)
            .limit(limit)
            .get();

        for (var doc in snapshot.docs) {
          transaksi.add(LaporanKeuanganDetail.fromPengeluaran(doc));
        }
      }

      debugPrint('✅ Total transaksi $type: ${transaksi.length}');

      return transaksi;
    } catch (e) {
      debugPrint('❌ Error fetching transaksi by type: $e');
      rethrow;
    }
  }

  /// Get summary keuangan
  Future<Map<String, dynamic>> getSummary() async {
    try {
      debugPrint('🔄 Calculating keuangan summary...');

      double totalPemasukanIuran = 0;
      double totalPemasukanLain = 0;
      double totalPengeluaran = 0;

      // 1. Total Pemasukan dari Iuran
      final iuranSnapshot = await _firestore.collection('jenis_iuran').get();
      for (var doc in iuranSnapshot.docs) {
        final data = doc.data();
        totalPemasukanIuran += (data['nominal'] ?? 0).toDouble();
      }

      // 2. Total Pemasukan Lain
      final pemasukanLainSnapshot = await _firestore.collection('pemasukan_lain').get();
      for (var doc in pemasukanLainSnapshot.docs) {
        final data = doc.data();
        totalPemasukanLain += (data['nominal'] ?? 0).toDouble();
      }

      // 3. Total Pengeluaran
      final pengeluaranSnapshot = await _firestore.collection('pengeluaran').get();
      for (var doc in pengeluaranSnapshot.docs) {
        final data = doc.data();
        totalPengeluaran += (data['nominal'] ?? 0).toDouble();
      }

      final totalPemasukan = totalPemasukanIuran + totalPemasukanLain;
      final saldo = totalPemasukan - totalPengeluaran;

      debugPrint('✅ Summary calculated:');
      debugPrint('   Pemasukan Iuran: Rp ${totalPemasukanIuran.toStringAsFixed(0)}');
      debugPrint('   Pemasukan Lain: Rp ${totalPemasukanLain.toStringAsFixed(0)}');
      debugPrint('   Total Pemasukan: Rp ${totalPemasukan.toStringAsFixed(0)}');
      debugPrint('   Total Pengeluaran: Rp ${totalPengeluaran.toStringAsFixed(0)}');
      debugPrint('   Saldo: Rp ${saldo.toStringAsFixed(0)}');

      return {
        'total_pemasukan_iuran': totalPemasukanIuran,
        'total_pemasukan_lain': totalPemasukanLain,
        'total_pemasukan': totalPemasukan,
        'total_pengeluaran': totalPengeluaran,
        'saldo': saldo,
        'count_iuran': iuranSnapshot.docs.length,
        'count_pemasukan_lain': pemasukanLainSnapshot.docs.length,
        'count_pengeluaran': pengeluaranSnapshot.docs.length,
      };
    } catch (e) {
      debugPrint('❌ Error calculating summary: $e');
      rethrow;
    }
  }
}

