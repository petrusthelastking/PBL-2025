import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class KeuanganSummaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get total pemasukan yang terverifikasi
  /// Menghitung dari KEDUA collection: jenis_iuran DAN pemasukan_lain
  Future<double> getTotalPemasukan() async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 Calculating total pemasukan from both collections...');

      // 1. Get total from jenis_iuran
      final jenisIuranSnapshot = await _firestore
          .collection('jenis_iuran')
          .where('isActive', isEqualTo: true)
          .get();

      double totalJenisIuran = 0;
      for (var doc in jenisIuranSnapshot.docs) {
        final data = doc.data();
        // ✅ FIXED: Use 'jumlahIuran' (camelCase) to match Firestore field
        final nominal = (data['jumlahIuran'] as num?)?.toDouble() ?? 0;
        totalJenisIuran += nominal;
        debugPrint('      - ${data['namaIuran']}: Rp ${nominal.toStringAsFixed(0)}');
      }
      debugPrint('   📊 Jenis Iuran: Rp ${totalJenisIuran.toStringAsFixed(0)} (${jenisIuranSnapshot.docs.length} items)');

      // 2. Get total from pemasukan_lain (semua yang active)
      final pemasukanLainSnapshot = await _firestore
          .collection('pemasukan_lain')
          .where('isActive', isEqualTo: true)
          .get();

      double totalPemasukanLain = 0;
      for (var doc in pemasukanLainSnapshot.docs) {
        final data = doc.data();
        final nominal = (data['nominal'] as num?)?.toDouble() ?? 0;
        totalPemasukanLain += nominal;
      }
      debugPrint('   📊 Pemasukan Lain: Rp ${totalPemasukanLain.toStringAsFixed(0)} (${pemasukanLainSnapshot.docs.length} items)');

      // 3. Total keseluruhan
      final total = totalJenisIuran + totalPemasukanLain;
      debugPrint('   💰 TOTAL PEMASUKAN GABUNGAN: Rp ${total.toStringAsFixed(0)}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return total;
    } catch (e) {
      debugPrint('❌ Error getting total pemasukan: $e');
      return 0;
    }
  }

  /// Get total pengeluaran yang terverifikasi
  Future<double> getTotalPengeluaran() async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 Calculating total pengeluaran (TERVERIFIKASI ONLY)...');

      final snapshot = await _firestore
          .collection('pengeluaran')
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: 'Terverifikasi')
          .get();

      double total = 0;
      int count = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final nominal = (data['nominal'] as num?)?.toDouble() ?? 0;
        final name = data['name'] ?? 'Unknown';
        final status = data['status'] ?? 'Unknown';
        total += nominal;
        count++;
        debugPrint('   - [$status] $name: Rp ${nominal.toStringAsFixed(0)}');
      }

      debugPrint('   📊 Total Items: $count');
      debugPrint('   💰 TOTAL PENGELUARAN TERVERIFIKASI: Rp ${total.toStringAsFixed(0)}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      return total;
    } catch (e) {
      debugPrint('❌ Error getting total pengeluaran: $e');
      return 0;
    }
  }

  /// Get total asset (pemasukan - pengeluaran)
  Future<double> getTotalAsset() async {
    try {
      final pemasukan = await getTotalPemasukan();
      final pengeluaran = await getTotalPengeluaran();
      final asset = pemasukan - pengeluaran;

      debugPrint('✅ Total Asset: Rp ${asset.toStringAsFixed(0)}');
      return asset;
    } catch (e) {
      debugPrint('❌ Error calculating total asset: $e');
      return 0;
    }
  }

  /// Get percentage untuk progress bar
  /// Pemasukan = % saldo tersisa dari total pemasukan
  /// Pengeluaran = % yang sudah digunakan dari total pemasukan
  Future<Map<String, dynamic>> getKeuanganPercentages() async {
    try {
      final pemasukan = await getTotalPemasukan();
      final pengeluaran = await getTotalPengeluaran();
      final asset = pemasukan - pengeluaran; // Saldo tersisa

      // Jika tidak ada pemasukan, return 0
      if (pemasukan == 0) {
        return {
          'pemasukanPercentage': 0,
          'pengeluaranPercentage': 0,
        };
      }

      // Persentase pengeluaran dari pemasukan (sudah digunakan)
      final pengeluaranPercentage = ((pengeluaran / pemasukan) * 100).round();

      // Persentase saldo tersisa dari pemasukan
      final pemasukanPercentage = ((asset / pemasukan) * 100).round();

      debugPrint('✅ Pemasukan: $pemasukanPercentage% (sisa), Pengeluaran: $pengeluaranPercentage% (terpakai)');

      return {
        'pemasukanPercentage': pemasukanPercentage.clamp(0, 100),
        'pengeluaranPercentage': pengeluaranPercentage.clamp(0, 100),
      };
    } catch (e) {
      debugPrint('❌ Error calculating percentages: $e');
      return {
        'pemasukanPercentage': 0,
        'pengeluaranPercentage': 0,
      };
    }
  }

  /// Get growth percentage (dibandingkan bulan lalu)
  Future<double> getGrowthPercentage() async {
    try {
      final now = DateTime.now();
      final thisMonthStart = DateTime(now.year, now.month, 1);
      final lastMonthStart = DateTime(now.year, now.month - 1, 1);
      final lastMonthEnd = thisMonthStart.subtract(const Duration(days: 1));

      // Total bulan ini
      final thisMonthSnapshot = await _firestore
          .collection('pemasukan_lain')
          .where('isActive', isEqualTo: true)
          .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(thisMonthStart))
          .get();

      double thisMonthTotal = 0;
      for (var doc in thisMonthSnapshot.docs) {
        final nominal = (doc.data()['nominal'] as num?)?.toDouble() ?? 0;
        thisMonthTotal += nominal;
      }

      // Total bulan lalu
      final lastMonthSnapshot = await _firestore
          .collection('pemasukan_lain')
          .where('isActive', isEqualTo: true)
          .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(lastMonthStart))
          .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(lastMonthEnd))
          .get();

      double lastMonthTotal = 0;
      for (var doc in lastMonthSnapshot.docs) {
        final nominal = (doc.data()['nominal'] as num?)?.toDouble() ?? 0;
        lastMonthTotal += nominal;
      }

      // Hitung growth percentage
      if (lastMonthTotal == 0) {
        return thisMonthTotal > 0 ? 100 : 0;
      }

      final growth = ((thisMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;
      debugPrint('✅ Growth: ${growth.toStringAsFixed(1)}%');

      return growth;
    } catch (e) {
      debugPrint('❌ Error calculating growth: $e');
      return 0;
    }
  }

  /// Get summary for dashboard
  Future<Map<String, dynamic>> getKeuanganSummary() async {
    try {
      final pemasukan = await getTotalPemasukan();
      final pengeluaran = await getTotalPengeluaran();
      final asset = pemasukan - pengeluaran;
      final percentages = await getKeuanganPercentages();
      final growth = await getGrowthPercentage();

      return {
        'totalPemasukan': pemasukan,
        'totalPengeluaran': pengeluaran,
        'totalAsset': asset,
        'pemasukanPercentage': percentages['pemasukanPercentage'],
        'pengeluaranPercentage': percentages['pengeluaranPercentage'],
        'growthPercentage': growth,
      };
    } catch (e) {
      debugPrint('❌ Error getting keuangan summary: $e');
      return {
        'totalPemasukan': 0.0,
        'totalPengeluaran': 0.0,
        'totalAsset': 0.0,
        'pemasukanPercentage': 0,
        'pengeluaranPercentage': 0,
        'growthPercentage': 0.0,
      };
    }
  }
}

