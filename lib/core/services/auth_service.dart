import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'firebase_service.dart';

class AuthService {
  final FirebaseService _firebaseService = FirebaseService();
  
  FirebaseFirestore get _firestore => _firebaseService.firestore;

  // Current logged in user ID (stored in memory)
  String? _currentUserId;
  
  // Get current user ID
  String? get currentUserId => _currentUserId;

  // Check if user is logged in
  bool get isLoggedIn => _currentUserId != null;

  // Hash password
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Sign in with email and password
  Future<Map<String, dynamic>?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Query user by email
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw 'Email tidak terdaftar';
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();
      final hashedPassword = _hashPassword(password);

      // Check password
      if (userData['password'] != hashedPassword) {
        throw 'Password salah';
      }

      // Set current user ID
      _currentUserId = userDoc.id;

      // Return user data with ID
      return {
        'id': userDoc.id,
        ...userData,
      };
    } catch (e) {
      if (e is String) rethrow;
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Register with email and password (with complete user data)
  Future<Map<String, dynamic>?> registerWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String nik,
    required String phone,
    required String address,
    required String rt,
    required String rw,
    required String gender,
    String role = 'warga',
    String? photoUrl,
  }) async {
    try {
      // Check if email already exists
      final emailCheck = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (emailCheck.docs.isNotEmpty) {
        throw 'Email sudah terdaftar';
      }

      // Check if NIK already exists
      final nikCheck = await _firestore
          .collection('users')
          .where('nik', isEqualTo: nik)
          .limit(1)
          .get();

      if (nikCheck.docs.isNotEmpty) {
        throw 'NIK sudah terdaftar';
      }

      // Hash password
      final hashedPassword = _hashPassword(password);

      // Create user document
      final userRef = _firestore.collection('users').doc();
      await userRef.set({
        'email': email,
        'password': hashedPassword,
        'name': name,
        'nik': nik,
        'phone': phone,
        'address': address,
        'rt': rt,
        'rw': rw,
        'gender': gender,
        'role': role,
        'photoUrl': photoUrl ?? '',
        'status': 'pending', // pending approval by admin
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Set current user ID
      _currentUserId = userRef.id;

      // Return user data
      final userDoc = await userRef.get();
      return {
        'id': userRef.id,
        ...userDoc.data()!,
      };
    } catch (e) {
      if (e is String) rethrow;
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _currentUserId = null;
    } catch (e) {
      throw 'Gagal logout: $e';
    }
  }

  // Update password
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (_currentUserId == null) throw 'User tidak login';

      // Get current user data
      final userDoc = await _firestore.collection('users').doc(_currentUserId).get();
      if (!userDoc.exists) throw 'User tidak ditemukan';

      final userData = userDoc.data()!;
      final hashedOldPassword = _hashPassword(oldPassword);

      // Verify old password
      if (userData['password'] != hashedOldPassword) {
        throw 'Password lama salah';
      }

      // Update with new password
      final hashedNewPassword = _hashPassword(newPassword);
      await _firestore.collection('users').doc(_currentUserId).update({
        'password': hashedNewPassword,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (e is String) rethrow;
      throw 'Terjadi kesalahan: $e';
    }
  }

  // Get user role from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data()?['role'] as String?;
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil role user: $e';
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return {
          'id': uid,
          ...doc.data()!,
        };
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil data user: $e';
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? phone,
    String? address,
    String? rt,
    String? rw,
    String? photoUrl,
  }) async {
    try {
      if (_currentUserId == null) throw 'User tidak login';

      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (address != null) updateData['address'] = address;
      if (rt != null) updateData['rt'] = rt;
      if (rw != null) updateData['rw'] = rw;
      if (photoUrl != null) updateData['photoUrl'] = photoUrl;

      await _firestore.collection('users').doc(_currentUserId).update(updateData);
    } catch (e) {
      if (e is String) rethrow;
      throw 'Gagal update profil: $e';
    }
  }
}

