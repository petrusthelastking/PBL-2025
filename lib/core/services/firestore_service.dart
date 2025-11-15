import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== USER OPERATIONS ====================

  // Get user by email
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      print('\n=== FirestoreService.getUserByEmail ===');
      print('Input email: "$email"');
      print('Querying collection: users');
      
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      print('Query completed');
      print('Documents found: ${querySnapshot.docs.length}');

      if (querySnapshot.docs.isEmpty) {
        print('❌ No documents found with email: $email');
        print('📝 Pastikan di Firestore Console:');
        print('   - Collection name: "users" (huruf kecil)');
        print('   - Field name: "email" (huruf kecil)');
        print('   - Email value: "$email" (exact match, case sensitive)');
        return null;
      }

      final doc = querySnapshot.docs.first;
      print('✅ Document found!');
      print('Document ID: ${doc.id}');
      print('Document data keys: ${doc.data().keys.toList()}');
      print('Email from doc: ${doc.data()['email']}');
      print('Password from doc: ${doc.data()['password']}');
      print('Status from doc: ${doc.data()['status']}');
      print('Role from doc: ${doc.data()['role']}');
      
      final user = UserModel.fromMap(doc.data(), doc.id);
      print('✅ UserModel created successfully');
      print('=====================================\n');
      return user;
    } catch (e, stackTrace) {
      print('\n❌ ERROR in getUserByEmail ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('StackTrace: $stackTrace');
      print('================================\n');
      return null;
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  // Create new user
  Future<String?> createUser(UserModel user) async {
    try {
      print('=== FirestoreService: createUser START ===');
      print('Email: ${user.email}');
      print('Nama: ${user.nama}');
      print('NIK: ${user.nik}');
      print('Role: ${user.role}');
      print('Status: ${user.status}');

      // Test Firestore connection first
      print('Testing Firestore connection...');
      final testRef = _firestore.collection('users');
      print('Collection reference created: ${testRef.path}');

      print('Creating user map...');
      final userMap = user.toMap();
      print('User map created successfully');
      print('Map keys: ${userMap.keys.toList()}');
      print('Map values preview: email=${userMap['email']}, nama=${userMap['nama']}');

      print('Adding document to Firestore...');
      final docRef = await _firestore.collection('users').add(userMap);
      print('SUCCESS! Document created with ID: ${docRef.id}');
      print('=== FirestoreService: createUser END ===');

      return docRef.id;
    } catch (e, stackTrace) {
      print('=== FirestoreService: createUser ERROR ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('StackTrace: $stackTrace');
      print('===========================================');
      return null;
    }
  }

  // Update user
  Future<bool> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  // Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // Check if user exists by email
  Future<bool> userExistsByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }

  // ==================== GENERIC OPERATIONS ====================

  // Get collection with optional ordering
  Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query query = _firestore.collection(collection);

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error getting collection $collection: $e');
      return [];
    }
  }

  // Create document
  Future<String?> createDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      final docRef = await _firestore.collection(collection).add(data);
      return docRef.id;
    } catch (e) {
      print('Error creating document in $collection: $e');
      return null;
    }
  }

  // Update document
  Future<bool> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
      return true;
    } catch (e) {
      print('Error updating document in $collection: $e');
      return false;
    }
  }

  // Delete document
  Future<bool> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
      return true;
    } catch (e) {
      print('Error deleting document in $collection: $e');
      return false;
    }
  }

  // Get document by ID
  Future<Map<String, dynamic>?> getDocumentById({
    required String collection,
    required String docId,
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(docId).get();
      if (!doc.exists) {
        return null;
      }
      return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
    } catch (e) {
      print('Error getting document from $collection: $e');
      return null;
    }
  }

  // Search warga by query
  Future<List<Map<String, dynamic>>> searchWarga(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection('warga')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error searching warga: $e');
      return [];
    }
  }

  // Query collection with where clause
  Future<List<Map<String, dynamic>>> queryCollection({
    required String collection,
    required String field,
    required dynamic value,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query query = _firestore.collection(collection).where(field, isEqualTo: value);

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      print('Error querying collection $collection: $e');
      return [];
    }
  }
}

