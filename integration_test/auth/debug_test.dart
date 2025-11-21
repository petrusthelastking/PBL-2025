// ============================================================================
// DEBUG TEST - CHECK FIREBASE CONNECTION & DATA
// ============================================================================
// Test ini untuk debugging - check koneksi Firebase dan data user
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import main app
import 'package:jawara/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    '🔍 DEBUG: Check Firestore Connection & User Data',
    (WidgetTester tester) async {
      print('\n' + '=' * 80);
      print('  🔍 DEBUG TEST - Checking Firestore');
      print('=' * 80 + '\n');

      try {
        // Start app first
        print('🔵 Starting application...');
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));
        print('  ✅ Application started\n');

        // ======================================================================
        // CHECK 1: Firestore Connection
        // ======================================================================
        print('🔍 CHECK 1: Testing Firestore Connection...');

        final firestore = FirebaseFirestore.instance;
        print('  ✅ Firestore instance created');

        // ======================================================================
        // CHECK 2: Query Users Collection
        // ======================================================================
        print('\n🔍 CHECK 2: Querying users collection...');

        try {
          final usersSnapshot = await firestore.collection('users').get();
          print('  ✅ Query successful!');
          print('  📊 Total documents in users collection: ${usersSnapshot.docs.length}');

          if (usersSnapshot.docs.isEmpty) {
            print('\n  ❌ PROBLEM FOUND: users collection is EMPTY!');
            print('  📝 ACTION: Add user document to Firestore');
          } else {
            print('\n  ✅ Users collection has data');

            // ======================================================================
            // CHECK 3: List All Users
            // ======================================================================
            print('\n🔍 CHECK 3: Listing all users...\n');

            for (var doc in usersSnapshot.docs) {
              final data = doc.data();
              print('  📄 Document ID: ${doc.id}');
              print('     Email: ${data['email'] ?? '(not set)'}');
              print('     Nama: ${data['nama'] ?? '(not set)'}');
              print('     Status: ${data['status'] ?? '(not set)'}');
              print('     Role: ${data['role'] ?? '(not set)'}');
              print('     Password length: ${(data['password'] ?? '').toString().length} chars');
              print('');
            }

            // ======================================================================
            // CHECK 4: Find Specific User
            // ======================================================================
            print('🔍 CHECK 4: Looking for user "admin@jawara.com"...\n');

            final adminQuery = await firestore
                .collection('users')
                .where('email', isEqualTo: 'admin@jawara.com')
                .get();

            if (adminQuery.docs.isEmpty) {
              print('  ❌ PROBLEM FOUND: User "admin@jawara.com" NOT FOUND!');
              print('\n  📝 Possible reasons:');
              print('     1. Email typo (check lowercase/uppercase)');
              print('     2. User in different collection');
              print('     3. Field name different (e.g., "Email" vs "email")');

              // Check with case-insensitive
              print('\n  🔍 Checking all emails (case-insensitive)...');
              for (var doc in usersSnapshot.docs) {
                final email = (doc.data()['email'] ?? '').toString().toLowerCase();
                print('     - Found: "$email"');
                if (email.contains('admin')) {
                  print('       ^ This looks like admin email!');
                }
              }
            } else {
              print('  ✅ User "admin@jawara.com" FOUND!');

              final userData = adminQuery.docs.first.data();

              print('\n  📋 User Details:');
              print('     Document ID: ${adminQuery.docs.first.id}');
              print('     Email: ${userData['email']}');
              print('     Password: ${userData['password']}');
              print('     Status: ${userData['status']}');
              print('     Role: ${userData['role']}');
              print('     Nama: ${userData['nama'] ?? '(not set)'}');

              // ======================================================================
              // CHECK 5: Validate Fields
              // ======================================================================
              print('\n🔍 CHECK 5: Validating fields...\n');

              bool allValid = true;

              // Check email
              if (userData['email'] == 'admin@jawara.com') {
                print('  ✅ Email is correct');
              } else {
                print('  ❌ Email mismatch!');
                print('     Expected: admin@jawara.com');
                print('     Found: ${userData['email']}');
                allValid = false;
              }

              // Check password
              if (userData['password'] == 'admin123') {
                print('  ✅ Password is correct');
              } else {
                print('  ❌ Password mismatch!');
                print('     Expected: admin123');
                print('     Found: ${userData['password']}');
                allValid = false;
              }

              // Check status
              if (userData['status'] == 'approved') {
                print('  ✅ Status is "approved"');
              } else {
                print('  ❌ Status is NOT "approved"!');
                print('     Expected: approved');
                print('     Found: ${userData['status']}');
                allValid = false;
              }

              // Check role
              if (userData['role'] == 'admin') {
                print('  ✅ Role is "admin"');
              } else {
                print('  ⚠️  Role is not "admin"');
                print('     Expected: admin');
                print('     Found: ${userData['role']}');
              }

              print('');

              if (allValid) {
                print('═' * 80);
                print('  ✅ ALL CHECKS PASSED!');
                print('  ✅ User setup is CORRECT');
                print('  ℹ️  If login test still fails, problem is elsewhere');
                print('═' * 80);
              } else {
                print('═' * 80);
                print('  ❌ PROBLEMS FOUND!');
                print('  📝 Fix the fields marked with ❌ above');
                print('═' * 80);
              }
            }
          }

        } catch (e) {
          print('  ❌ Error querying Firestore: $e');
          print('\n  📝 Possible reasons:');
          print('     1. No internet connection');
          print('     2. Firestore rules blocking read');
          print('     3. Firebase not initialized properly');
        }

        print('\n' + '=' * 80);
        print('  🔍 DEBUG TEST COMPLETED');
        print('=' * 80 + '\n');

      } catch (e, stackTrace) {
        print('\n❌ ERROR IN DEBUG TEST:');
        print('Error: $e');
        print('StackTrace: $stackTrace');
      }

      // Test always passes - this is just for debugging
      expect(true, true);
    },
  );
}

