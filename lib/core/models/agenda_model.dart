import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Model untuk Agenda (Kegiatan & Broadcast)
class AgendaModel {
  final String id;
  final String judul;
  final String? deskripsi;
  final String type; // 'kegiatan' atau 'broadcast'
  final DateTime tanggal;
  final String? lokasi;
  final String? gambar;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  AgendaModel({
    required this.id,
    required this.judul,
    this.deskripsi,
    required this.type,
    required this.tanggal,
    this.lokasi,
    this.gambar,
    this.createdBy = '',
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  // From Firestore
  factory AgendaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    debugPrint('📄 Parsing agenda: ${doc.id}');
    debugPrint('   Data: $data');

    return AgendaModel(
      id: doc.id,
      judul: data['judul'] ?? data['title'] ?? '',
      deskripsi: data['deskripsi'] ?? data['description'],
      type: data['type'] ?? 'kegiatan',
      tanggal: (data['tanggal'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lokasi: data['lokasi'] ?? data['location'],
      gambar: data['gambar'] ?? data['image'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'title': judul, // Backward compatibility
      'deskripsi': deskripsi,
      'description': deskripsi,
      'type': type,
      'tanggal': Timestamp.fromDate(tanggal),
      'lokasi': lokasi,
      'location': lokasi,
      'gambar': gambar,
      'image': gambar,
      'createdBy': createdBy,
      'isActive': isActive,
    };
  }

  // CopyWith
  AgendaModel copyWith({
    String? judul,
    String? deskripsi,
    String? type,
    DateTime? tanggal,
    String? lokasi,
    String? gambar,
    String? createdBy,
    bool? isActive,
  }) {
    return AgendaModel(
      id: id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      type: type ?? this.type,
      tanggal: tanggal ?? this.tanggal,
      lokasi: lokasi ?? this.lokasi,
      gambar: gambar ?? this.gambar,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

