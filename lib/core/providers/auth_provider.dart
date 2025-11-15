import 'package:flutter/foundation.dart';
import 'package:jawara/core/models/user_model.dart';
import 'package:jawara/core/services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  // Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('\n=== LOGIN ATTEMPT ===');
      print('Email: $email');
      print('Password length: ${password.length}');
      
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Validate input
      if (email.isEmpty || password.isEmpty) {
        print('❌ Validation failed: Empty fields');
        _errorMessage = 'Email dan password harus diisi';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Get user from Firestore
      print('🔍 Searching user in Firestore...');
      final user = await _firestoreService.getUserByEmail(email);

      if (user == null) {
        print('❌ User not found in Firestore');
        print('⚠️  PASTIKAN sudah buat admin di Firestore Console!');
        _errorMessage = 'Email tidak ditemukan. Pastikan admin sudah dibuat di Firestore Console.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('✅ User found!');
      print('User data:');
      print('  - Email: ${user.email}');
      print('  - Nama: ${user.nama}');
      print('  - Role: ${user.role}');
      print('  - Status: ${user.status}');
      print('  - Password from DB: ${user.password}');
      print('  - Password input: $password');

      // Verify password
      if (user.password != password) {
        print('❌ Password tidak cocok!');
        print('   DB password: "${user.password}"');
        print('   Input password: "$password"');
        _errorMessage = 'Password salah';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('✅ Password cocok!');

      // Check if user status is approved
      if (user.status != 'approved') {
        print('❌ Status bukan approved: ${user.status}');
        if (user.status == 'pending') {
          _errorMessage = 'Akun Anda masih menunggu persetujuan admin';
        } else if (user.status == 'rejected') {
          _errorMessage = 'Akun Anda ditolak oleh admin';
        } else {
          _errorMessage = 'Akun Anda tidak aktif (status: ${user.status})';
        }
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('✅ Status approved!');
      print('🎉 LOGIN BERHASIL!');
      print('===================\n');

      _userModel = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      print('\n❌ LOGIN ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      print('==================\n');
      _errorMessage = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up / Register
  Future<bool> signUp({
    required String email,
    required String password,
    required String nama,
    String? nik,
    String? jenisKelamin,
    String? noTelepon,
    String? alamat,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('=== START REGISTRATION ===');
      print('Email: $email');
      print('Nama: $nama');

      // Validate input
      if (email.isEmpty || password.isEmpty || nama.isEmpty) {
        _errorMessage = 'Email, password, dan nama harus diisi';
        _isLoading = false;
        notifyListeners();
        print('Validation failed: Empty fields');
        return false;
      }

      print('Checking if email exists...');
      // Check if user already exists
      final exists = await _firestoreService.userExistsByEmail(email);
      print('Email exists: $exists');

      if (exists) {
        _errorMessage = 'Email sudah terdaftar';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('Creating user model...');
      // Create new ADMIN user with APPROVED status (no verification needed)
      final newUser = UserModel(
        id: '', // Will be set by Firestore
        email: email,
        nama: nama,
        nik: nik,
        jenisKelamin: jenisKelamin,
        noTelepon: noTelepon,
        alamat: alamat,
        role: 'admin', // Changed to 'admin'
        status: 'approved', // Changed to 'approved'
        password: password,
        createdAt: DateTime.now(),
      );

      print('Saving to Firestore...');
      final userId = await _firestoreService.createUser(newUser);
      print('User ID: $userId');

      if (userId == null) {
        _errorMessage = 'Gagal menyimpan data ke database';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('=== REGISTRATION SUCCESS ===');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      print('=== REGISTRATION ERROR ===');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      _errorMessage = 'Terjadi kesalahan: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _userModel = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  // Check authentication status
  Future<bool> checkAuthStatus() async {
    // For now, we just return the current authentication status
    // In a real app, you might want to check for a stored session token
    return _isAuthenticated;
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

