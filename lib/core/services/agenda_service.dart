import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/agenda_model.dart';

/// Service untuk mengelola CRUD Agenda (Kegiatan & Broadcast)
class AgendaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'agenda';

  // ==================== CREATE ====================

  /// Create agenda baru
  Future<String> createAgenda(AgendaModel agenda) async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 Creating agenda...');

      final data = agenda.toMap();
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection(_collection).add(data);

      debugPrint('✅ Agenda created successfully: ${docRef.id}');
      debugPrint('   - Judul: ${agenda.judul}');
      debugPrint('   - Type: ${agenda.type}');
      debugPrint('   - Tanggal: ${agenda.tanggal}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error creating agenda: $e');
      rethrow;
    }
  }

  // ==================== READ ====================

  /// Get all agenda stream (real-time)
  Stream<List<AgendaModel>> getAgendaStream() {
    return _firestore
        .collection(_collection)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      // Sort manually di client side
      final list = snapshot.docs
          .map((doc) => AgendaModel.fromFirestore(doc))
          .toList();

      // Sort by tanggal descending
      list.sort((a, b) => b.tanggal.compareTo(a.tanggal));

      return list;
    });
  }

  /// Get agenda by type (kegiatan/broadcast) stream
  Stream<List<AgendaModel>> getAgendaByTypeStream(String type) {
    return _firestore
        .collection(_collection)
        .where('type', isEqualTo: type)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      // Sort manually di client side
      final list = snapshot.docs
          .map((doc) => AgendaModel.fromFirestore(doc))
          .toList();

      // Sort by tanggal descending
      list.sort((a, b) => b.tanggal.compareTo(a.tanggal));

      return list;
    });
  }

  /// Get agenda by ID
  Future<AgendaModel?> getAgendaById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return AgendaModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting agenda by ID: $e');
      return null;
    }
  }

  /// Get upcoming agenda (kegiatan yang akan datang)
  Stream<List<AgendaModel>> getUpcomingAgendaStream({int limit = 10}) {
    final now = DateTime.now();
    return _firestore
        .collection(_collection)
        .where('type', isEqualTo: 'kegiatan')
        .where('isActive', isEqualTo: true)
        .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('tanggal', descending: false)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AgendaModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get past agenda (kegiatan yang sudah lewat)
  Stream<List<AgendaModel>> getPastAgendaStream({int limit = 10}) {
    final now = DateTime.now();
    return _firestore
        .collection(_collection)
        .where('type', isEqualTo: 'kegiatan')
        .where('isActive', isEqualTo: true)
        .where('tanggal', isLessThan: Timestamp.fromDate(now))
        .orderBy('tanggal', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AgendaModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get agenda by date range
  Stream<List<AgendaModel>> getAgendaByDateRangeStream(
    DateTime startDate,
    DateTime endDate, {
    String? type,
  }) {
    Query query = _firestore.collection(_collection);

    query = query.where('isActive', isEqualTo: true);

    if (type != null && type != 'Semua') {
      query = query.where('type', isEqualTo: type);
    }

    query = query
        .where('tanggal', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('tanggal', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('tanggal', descending: true);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AgendaModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Search agenda by keyword
  Future<List<AgendaModel>> searchAgenda(String keyword, {String? type}) async {
    try {
      Query query = _firestore.collection(_collection);

      query = query.where('isActive', isEqualTo: true);

      if (type != null && type != 'Semua') {
        query = query.where('type', isEqualTo: type);
      }

      final snapshot = await query.get();

      final searchKeyword = keyword.toLowerCase();
      return snapshot.docs
          .map((doc) => AgendaModel.fromFirestore(doc))
          .where((agenda) {
            return agenda.judul.toLowerCase().contains(searchKeyword) ||
                (agenda.deskripsi?.toLowerCase().contains(searchKeyword) ?? false) ||
                (agenda.lokasi?.toLowerCase().contains(searchKeyword) ?? false);
          })
          .toList();
    } catch (e) {
      debugPrint('❌ Error searching agenda: $e');
      return [];
    }
  }

  // ==================== UPDATE ====================

  /// Update agenda
  Future<void> updateAgenda(String id, Map<String, dynamic> data) async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 Updating agenda: $id');

      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(id).update(data);

      debugPrint('✅ Agenda updated successfully');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e) {
      debugPrint('❌ Error updating agenda: $e');
      rethrow;
    }
  }

  // ==================== DELETE ====================

  /// Delete agenda (HARD DELETE - permanently remove from Firestore)
  /// Data akan benar-benar terhapus dari database
  Future<void> deleteAgenda(String id) async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 Deleting agenda (HARD DELETE): $id');

      await _firestore.collection(_collection).doc(id).delete();

      debugPrint('✅ Agenda deleted permanently from Firestore');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e) {
      debugPrint('❌ Error deleting agenda: $e');
      rethrow;
    }
  }

  /// Soft delete agenda (set isActive = false)
  /// Data masih ada di Firestore tapi tidak ditampilkan
  Future<void> softDeleteAgenda(String id) async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔄 Soft deleting agenda: $id');

      await _firestore.collection(_collection).doc(id).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Agenda soft deleted successfully');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e) {
      debugPrint('❌ Error soft deleting agenda: $e');
      rethrow;
    }
  }

  // ==================== STATISTICS ====================

  /// Get agenda count by type
  Future<Map<String, int>> getAgendaCountByType() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      int kegiatanCount = 0;
      int broadcastCount = 0;

      for (var doc in snapshot.docs) {
        final type = doc.data()['type'] ?? 'kegiatan';
        if (type == 'kegiatan') {
          kegiatanCount++;
        } else if (type == 'broadcast') {
          broadcastCount++;
        }
      }

      return {
        'kegiatan': kegiatanCount,
        'broadcast': broadcastCount,
        'total': snapshot.docs.length,
      };
    } catch (e) {
      debugPrint('❌ Error getting agenda count: $e');
      return {'kegiatan': 0, 'broadcast': 0, 'total': 0};
    }
  }

  /// Get agenda summary
  Future<Map<String, dynamic>> getAgendaSummary() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .get();

      int totalKegiatan = 0;
      int totalBroadcast = 0;
      int upcomingKegiatan = 0;
      int pastKegiatan = 0;

      final now = DateTime.now();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final type = data['type'] ?? 'kegiatan';
        final tanggal = (data['tanggal'] as Timestamp?)?.toDate();

        if (type == 'kegiatan') {
          totalKegiatan++;
          if (tanggal != null) {
            if (tanggal.isAfter(now)) {
              upcomingKegiatan++;
            } else {
              pastKegiatan++;
            }
          }
        } else if (type == 'broadcast') {
          totalBroadcast++;
        }
      }

      return {
        'totalKegiatan': totalKegiatan,
        'totalBroadcast': totalBroadcast,
        'totalAgenda': snapshot.docs.length,
        'upcomingKegiatan': upcomingKegiatan,
        'pastKegiatan': pastKegiatan,
      };
    } catch (e) {
      debugPrint('❌ Error getting agenda summary: $e');
      return {
        'totalKegiatan': 0,
        'totalBroadcast': 0,
        'totalAgenda': 0,
        'upcomingKegiatan': 0,
        'pastKegiatan': 0,
      };
    }
  }
}

