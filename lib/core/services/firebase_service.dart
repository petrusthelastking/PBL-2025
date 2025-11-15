import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getters
  FirebaseFirestore get firestore => _firestore;
}

