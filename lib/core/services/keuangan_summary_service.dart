import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class KeuanganSummaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get total pemasukan yang terverifikasi
  Future<double> getTotalPemasukan() async {
    try {
      final snapshot = await _firestore
          .collection('pemasukan_lain')
          .where('isActive', isEqualTo: true)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final nominal = (data['nominal'] as num?)?.toDouble() ?? 0;
        total += nominal;
      }

      debugPrint('✅ Total Pemasukan: Rp ${total.toStringAsFixed(0)}');
      return total;
    } catch (e) {
      debugPrint('❌ Error getting total pemasukan: $e');
      return 0;
    }
  }

  /// Get total pengeluaran yang terverifikasi
  Future<double> getTotalPengeluaran() async {
    try {
      final snapshot = await _firestore
          .collection('pengeluaran')
          .where('isActive', isEqualTo: true)
          .where('status', isEqualTo: 'Terverifikasi')
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final nominal = (data['nominal'] as num?)?.toDouble() ?? 0;
        total += nominal;
      }

      debugPrint('✅ Total Pengeluaran: Rp ${total.toStringAsFixed(0)}');
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
  /// Menghitung persentase dari total yang digunakan
  Future<Map<String, dynamic>> getKeuanganPercentages() async {
    try {
      final pemasukan = await getTotalPemasukan();
      final pengeluaran = await getTotalPengeluaran();

      // Jika tidak ada pemasukan, return 0
      if (pemasukan == 0) {
        return {
          'pemasukanPercentage': 0,
          'pengeluaranPercentage': 0,
        };
      }

      // Hitung persentase pengeluaran dari pemasukan
      final pengeluaranPercentage = ((pengeluaran / pemasukan) * 100).round();

      // Persentase pemasukan selalu 100% (karena ini basis)
      // Atau bisa dihitung dari target
      final pemasukanPercentage = 100;

      debugPrint('✅ Pemasukan: $pemasukanPercentage%, Pengeluaran: $pengeluaranPercentage%');

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

