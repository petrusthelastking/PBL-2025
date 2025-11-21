// ============================================================================
// LOGIN PAGE OBJECT (LIB VERSION)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Login Page Object
class LoginPageObject {
  final WidgetTester tester;

  LoginPageObject(this.tester);

  // ============================================================================
  // FINDERS
  // ============================================================================

  Finder get emailField => find.byType(TextField).first;
  Finder get passwordField => find.byType(TextField).at(1);
  Finder get loginButton => find.widgetWithText(ElevatedButton, 'Masuk');
  Finder get registerLink => find.text('Daftar');

  // ============================================================================
  // ACTIONS
  // ============================================================================

  Future<void> enterEmail(String email) async {
    print('  📝 Entering email: $email');
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
  }

  Future<void> enterPassword(String password) async {
    print('  📝 Entering password: ${'*' * password.length}');
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
  }

  Future<void> tapLoginButton() async {
    print('  👆 Tapping login button...');

    expect(loginButton, findsOneWidget, reason: 'Login button should exist');
    await tester.tap(loginButton);

    await tester.pumpAndSettle(const Duration(seconds: 5));
    print('  ✅ Login button tapped');
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    print('\n🔐 Performing login...');
    print('  Email: $email');
    print('  Password: ${'*' * password.length}');

    await enterEmail(email);
    await enterPassword(password);
    await tapLoginButton();

    print('✅ Login flow completed');
  }

  // ============================================================================
  // VERIFICATIONS
  // ============================================================================

  void verifyOnLoginPage() {
    print('  🔍 Verifying Login page...');

    expect(emailField, findsOneWidget, reason: 'Email field should exist');
    expect(passwordField, findsOneWidget, reason: 'Password field should exist');
    expect(loginButton, findsOneWidget, reason: 'Login button should exist');

    print('  ✅ On Login page confirmed');
  }

  void verifyErrorMessage(String expectedMessage) {
    print('  🔍 Verifying error message: "$expectedMessage"');

    final errorFinder = find.textContaining(expectedMessage);

    expect(
      errorFinder,
      findsOneWidget,
      reason: 'Error message "$expectedMessage" should be displayed',
    );

    print('  ✅ Error message verified');
  }

  Future<void> verifyNavigatedToDashboard() async {
    print('  🔍 Verifying navigation to Dashboard...');

    await tester.pumpAndSettle(const Duration(seconds: 2));

    final dashboardTitle = find.text('Dashboard');
    final kasMasuk = find.text('Kas Masuk');
    final kasKeluar = find.text('Kas Keluar');

    final hasDashboardElements =
        dashboardTitle.evaluate().isNotEmpty ||
        kasMasuk.evaluate().isNotEmpty ||
        kasKeluar.evaluate().isNotEmpty;

    expect(
      hasDashboardElements,
      true,
      reason: 'Should navigate to Dashboard after successful login',
    );

    print('  ✅ Successfully navigated to Dashboard');
  }

  void verifyStillOnLoginPage() {
    print('  🔍 Verifying still on Login page...');
    verifyOnLoginPage();
    print('  ✅ Still on Login page (as expected)');
  }
}

