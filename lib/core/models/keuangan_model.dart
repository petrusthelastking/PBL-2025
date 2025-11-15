import 'package:cloud_firestore/cloud_firestore.dart';

class KeuanganModel {
  final String id;
  final String type; // 'income' or 'expense'
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final String? proofUrl; // URL bukti transfer/nota
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  KeuanganModel({
    required this.id,
    required this.type,
    required this.category,
    required this.amount,
    this.description = '',
    required this.date,
    this.proofUrl,
    this.createdBy = '',
    this.createdAt,
    this.updatedAt,
  });

  // From Firestore
  factory KeuanganModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return KeuanganModel(
      id: doc.id,
      type: data['type'] ?? '',
      category: data['category'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      proofUrl: data['proofUrl'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // From Map
  factory KeuanganModel.fromMap(Map<String, dynamic> map, String id) {
    return KeuanganModel(
      id: id,
      type: map['type'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      proofUrl: map['proofUrl'],
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'category': category,
      'amount': amount,
      'description': description,
      'date': Timestamp.fromDate(date),
      'proofUrl': proofUrl,
    };
  }

  // Copy with
  KeuanganModel copyWith({
    String? type,
    String? category,
    double? amount,
    String? description,
    DateTime? date,
    String? proofUrl,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KeuanganModel(
      id: id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      proofUrl: proofUrl ?? this.proofUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if income
  bool get isIncome => type == 'income';

  // Check if expense
  bool get isExpense => type == 'expense';

  // Get formatted amount with sign
  String get formattedAmountWithSign {
    final sign = isIncome ? '+' : '-';
    return '$sign Rp ${amount.toStringAsFixed(0)}';
  }
}

