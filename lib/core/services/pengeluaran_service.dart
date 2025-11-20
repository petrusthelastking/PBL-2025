// filepath: lib/core/services/pengeluaran_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/pengeluaran_model.dart';

class PengeluaranService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'pengeluaran';

  /// Create pengeluaran baru
  Future<String> createPengeluaran(PengeluaranModel pengeluaran) async {
    try {
      final data = pengeluaran.toMap();
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection(_collection).add(data);
      debugPrint('✅ Pengeluaran created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error creating pengeluaran: $e');
      rethrow;
    }
  }

  /// Get all pengeluaran (stream)
  Stream<List<PengeluaranModel>> getPengeluaranStream() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PengeluaranModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get pengeluaran by status (stream)
  Stream<List<PengeluaranModel>> getPengeluaranByStatusStream(String status) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: status)
        .where('isActive', isEqualTo: true)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PengeluaranModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get pengeluaran by category (stream)
  Stream<List<PengeluaranModel>> getPengeluaranByCategoryStream(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PengeluaranModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get pengeluaran by date range (stream)
  Stream<List<PengeluaranModel>> getPengeluaranByDateRangeStream(
      DateTime startDate, DateTime endDate) {
    return _firestore
        .collection(_collection)
        .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .where('isActive', isEqualTo: true)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PengeluaranModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get pengeluaran by ID
  Future<PengeluaranModel?> getPengeluaranById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return PengeluaranModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting pengeluaran: $e');
      return null;
    }
  }

  /// Update pengeluaran
  Future<void> updatePengeluaran(String id, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(id).update(data);
      debugPrint('✅ Pengeluaran updated: $id');
    } catch (e) {
      debugPrint('❌ Error updating pengeluaran: $e');
      rethrow;
    }
  }

  /// Verifikasi pengeluaran (approve/reject)
  Future<void> verifikasiPengeluaran(String id, bool approved) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'status': approved ? 'Terverifikasi' : 'Ditolak',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Pengeluaran verified: $id - ${approved ? "Approved" : "Rejected"}');
    } catch (e) {
      debugPrint('❌ Error verifying pengeluaran: $e');
      rethrow;
    }
  }

  /// Delete pengeluaran (soft delete)
  Future<void> deletePengeluaran(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ Pengeluaran deleted (soft): $id');
    } catch (e) {
      debugPrint('❌ Error deleting pengeluaran: $e');
      rethrow;
    }
  }

  /// Hard delete pengeluaran
  Future<void> hardDeletePengeluaran(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      debugPrint('✅ Pengeluaran deleted (hard): $id');
    } catch (e) {
      debugPrint('❌ Error hard deleting pengeluaran: $e');
      rethrow;
    }
  }

  /// Get total pengeluaran terverifikasi
  Future<double> getTotalPengeluaranTerverifikasi() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'Terverifikasi')
          .where('isActive', isEqualTo: true)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final nominal = (data['nominal'] as num?)?.toDouble() ?? 0;
        total += nominal;
      }
      return total;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint('⚠️ Permission denied for getTotalPengeluaranTerverifikasi - returning 0');
        debugPrint('💡 Please update Firestore rules to allow read access to pengeluaran collection');
        return 0;
      }
      debugPrint('❌ Error getting total pengeluaran: $e');
      return 0;
    } catch (e) {
      debugPrint('❌ Error getting total pengeluaran: $e');
      return 0;
    }
  }

  /// Get total pengeluaran by category
  Future<double> getTotalPengeluaranByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .where('status', isEqualTo: 'Terverifikasi')
          .where('isActive', isEqualTo: true)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final nominal = (data['nominal'] as num?)?.toDouble() ?? 0;
        total += nominal;
      }
      return total;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint('⚠️ Permission denied - returning 0');
        return 0;
      }
      debugPrint('❌ Error getting total by category: $e');
      return 0;
    } catch (e) {
      debugPrint('❌ Error getting total by category: $e');
      return 0;
    }
  }

  /// Get total pengeluaran by date range
  Future<double> getTotalPengeluaranByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .where('status', isEqualTo: 'Terverifikasi')
          .where('isActive', isEqualTo: true)
          .get();

      double total = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final nominal = (data['nominal'] as num?)?.toDouble() ?? 0;
        total += nominal;
      }
      return total;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint('⚠️ Permission denied - returning 0');
        return 0;
      }
      debugPrint('❌ Error getting total by date range: $e');
      return 0;
    } catch (e) {
      debugPrint('❌ Error getting total by date range: $e');
      return 0;
    }
  }

  /// Get summary statistics
  Future<Map<String, dynamic>> getPengeluaranSummary() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      int total = 0;
      int menunggu = 0;
      int terverifikasi = 0;
      int ditolak = 0;
      double totalNominal = 0;
      double totalTerverifikasi = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? '';
        final nominal = (data['nominal'] as num?)?.toDouble() ?? 0;

        total++;
        totalNominal += nominal;

        switch (status) {
          case 'Menunggu':
            menunggu++;
            break;
          case 'Terverifikasi':
            terverifikasi++;
            totalTerverifikasi += nominal;
            break;
          case 'Ditolak':
            ditolak++;
            break;
        }
      }

      return {
        'total': total,
        'menunggu': menunggu,
        'terverifikasi': terverifikasi,
        'ditolak': ditolak,
        'totalNominal': totalNominal,
        'totalTerverifikasi': totalTerverifikasi,
      };
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint('⚠️ Permission denied - returning empty summary');
        return {
          'total': 0,
          'menunggu': 0,
          'terverifikasi': 0,
          'ditolak': 0,
          'totalNominal': 0.0,
          'totalTerverifikasi': 0.0,
        };
      }
      debugPrint('❌ Error getting summary: $e');
      return {
        'total': 0,
        'menunggu': 0,
        'terverifikasi': 0,
        'ditolak': 0,
        'totalNominal': 0.0,
        'totalTerverifikasi': 0.0,
      };
    } catch (e) {
      debugPrint('❌ Error getting summary: $e');
      return {
        'total': 0,
        'menunggu': 0,
        'terverifikasi': 0,
        'ditolak': 0,
        'totalNominal': 0.0,
        'totalTerverifikasi': 0.0,
      };
    }
  }
}

