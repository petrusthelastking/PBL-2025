import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawara/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('✅ Login E2E Test - Stable Version', (tester) async {
    print('\n🔐 Starting Login E2E Test...\n');

    // Start app
    print('🔵 Starting application...');
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));
    print('✅ App started\n');

    // (opsional) skip intro kalau ada
    print('🔵 Checking for intro screen...');
    final lewatiBtn = find.text('Lewati');
    if (lewatiBtn.evaluate().isNotEmpty) {
      print('  Found intro, tapping Lewati...');
      await tester.tap(lewatiBtn);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('✅ Intro skipped\n');
    } else {
      print('  No intro screen found\n');
    }

    // Pindah ke halaman login kalau perlu
    print('🔵 Navigating to login page...');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final masukBtn = find.text('Masuk');
    if (masukBtn.evaluate().isNotEmpty) {
      print('  Tapping Masuk button...');
      await tester.tap(masukBtn.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('✅ On login page\n');
    } else {
      print('  Already on login page\n');
    }

    // Cari field (TextField / TextFormField)
    print('🔵 Looking for login form fields...');
    await tester.pumpAndSettle(const Duration(seconds: 2));
    var fields = find.byType(TextField);
    if (fields.evaluate().isEmpty) {
      print('  TextField not found, trying TextFormField...');
      fields = find.byType(TextFormField);
    }

    // Pastikan minimal 2 field
    print('  Found ${fields.evaluate().length} field(s)\n');
    expect(fields, findsNWidgets(2), reason: 'Should have 2 input fields (email & password)');

    // Fill form
    print('🔵 Filling login form...');
    print('  Entering email...');
    await tester.enterText(fields.at(0), 'admin@jawara.com');
    await tester.pump(const Duration(milliseconds: 500));
    print('✅ Email entered');

    print('  Entering password...');
    await tester.enterText(fields.at(1), 'admin123');
    await tester.pump(const Duration(milliseconds: 500));
    print('✅ Password entered\n');

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap tombol login
    print('🔵 Tapping login button...');
    final loginBtn = find.widgetWithText(ElevatedButton, 'Masuk');
    expect(loginBtn, findsOneWidget, reason: 'Login button should exist');
    await tester.tap(loginBtn);
    print('  Login button tapped');
    print('  Waiting for authentication...\n');
    await tester.pumpAndSettle(const Duration(seconds: 8));

    // Verifikasi sudah di dashboard
    print('🔵 Verifying navigation to dashboard...');
    final dashboard = find.text('Dashboard');
    final kasMasuk = find.text('Kas Masuk');
    final kasKeluar = find.text('Kas Keluar');

    final success = dashboard.evaluate().isNotEmpty ||
        kasMasuk.evaluate().isNotEmpty ||
        kasKeluar.evaluate().isNotEmpty;

    expect(
      success,
      true,
      reason: 'Should be on dashboard after successful login',
    );

    print('✅ Successfully navigated to dashboard!\n');
    print('═' * 60);
    print('🎉 TEST PASSED - Login E2E Test Successful!');
    print('═' * 60 + '\n');
  });
}
