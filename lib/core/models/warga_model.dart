import 'package:cloud_firestore/cloud_firestore.dart';

class WargaModel {
  final String id;
  final String nik;
  final String name;
  final DateTime? birthDate;
  final String gender; // 'Laki-laki' or 'Perempuan'
  final String address;
  final String phone;
  final String rt;
  final String rw;
  final String status; // 'Kawin', 'Belum Kawin', 'Cerai Hidup', 'Cerai Mati'
  final String occupation;
  final String photoUrl;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WargaModel({
    required this.id,
    required this.nik,
    required this.name,
    this.birthDate,
    required this.gender,
    required this.address,
    this.phone = '',
    this.rt = '',
    this.rw = '',
    this.status = '',
    this.occupation = '',
    this.photoUrl = '',
    this.createdBy = '',
    this.createdAt,
    this.updatedAt,
  });

  // From Firestore
  factory WargaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WargaModel(
      id: doc.id,
      nik: data['nik'] ?? '',
      name: data['name'] ?? '',
      birthDate: (data['birthDate'] as Timestamp?)?.toDate(),
      gender: data['gender'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      rt: data['rt'] ?? '',
      rw: data['rw'] ?? '',
      status: data['status'] ?? '',
      occupation: data['occupation'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // From Map
  factory WargaModel.fromMap(Map<String, dynamic> map, String id) {
    return WargaModel(
      id: id,
      nik: map['nik'] ?? '',
      name: map['name'] ?? '',
      birthDate: (map['birthDate'] as Timestamp?)?.toDate(),
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      rt: map['rt'] ?? '',
      rw: map['rw'] ?? '',
      status: map['status'] ?? '',
      occupation: map['occupation'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'nik': nik,
      'name': name,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'gender': gender,
      'address': address,
      'phone': phone,
      'rt': rt,
      'rw': rw,
      'status': status,
      'occupation': occupation,
      'photoUrl': photoUrl,
    };
  }

  // Copy with
  WargaModel copyWith({
    String? nik,
    String? name,
    DateTime? birthDate,
    String? gender,
    String? address,
    String? phone,
    String? rt,
    String? rw,
    String? status,
    String? occupation,
    String? photoUrl,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WargaModel(
      id: id,
      nik: nik ?? this.nik,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      rt: rt ?? this.rt,
      rw: rw ?? this.rw,
      status: status ?? this.status,
      occupation: occupation ?? this.occupation,
      photoUrl: photoUrl ?? this.photoUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get age
  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }
}

