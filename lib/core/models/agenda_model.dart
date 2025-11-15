import 'package:cloud_firestore/cloud_firestore.dart';

class AgendaModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final String category; // 'Rapat', 'Kegiatan', 'Sosialisasi'
  final String status; // 'Upcoming', 'Ongoing', 'Completed', 'Cancelled'
  final List<String> penanggungJawab;
  final List<String> participants;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AgendaModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.date,
    this.startTime = '',
    this.endTime = '',
    this.location = '',
    this.category = '',
    this.status = 'Upcoming',
    this.penanggungJawab = const [],
    this.participants = const [],
    this.createdBy = '',
    this.createdAt,
    this.updatedAt,
  });

  // From Firestore
  factory AgendaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AgendaModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      location: data['location'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'Upcoming',
      penanggungJawab: List<String>.from(data['penanggungJawab'] ?? []),
      participants: List<String>.from(data['participants'] ?? []),
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // From Map
  factory AgendaModel.fromMap(Map<String, dynamic> map, String id) {
    return AgendaModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      location: map['location'] ?? '',
      category: map['category'] ?? '',
      status: map['status'] ?? 'Upcoming',
      penanggungJawab: List<String>.from(map['penanggungJawab'] ?? []),
      participants: List<String>.from(map['participants'] ?? []),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // To Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'category': category,
      'status': status,
      'penanggungJawab': penanggungJawab,
      'participants': participants,
    };
  }

  // Copy with
  AgendaModel copyWith({
    String? title,
    String? description,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    String? category,
    String? status,
    List<String>? penanggungJawab,
    List<String>? participants,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AgendaModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      category: category ?? this.category,
      status: status ?? this.status,
      penanggungJawab: penanggungJawab ?? this.penanggungJawab,
      participants: participants ?? this.participants,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if agenda is upcoming
  bool get isUpcoming => status == 'Upcoming' && date.isAfter(DateTime.now());

  // Check if agenda is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Check if agenda is past
  bool get isPast => date.isBefore(DateTime.now()) && status != 'Cancelled';
}

