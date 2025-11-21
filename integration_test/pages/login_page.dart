// ============================================================================
// LOGIN PAGE OBJECT
// ============================================================================
// Page Object Model untuk Login Page
// Mempermudah interaksi dengan Login Page dalam test
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Login Page Object
/// Encapsulate interaksi dengan Login Page
class LoginPageObject {
  final WidgetTester tester;

  LoginPageObject(this.tester);

  // ============================================================================
  // FINDERS - Element locators
  // ============================================================================

  /// Email TextField finder
  Finder get emailField => find.byType(TextField).first;

  /// Password TextField finder
  Finder get passwordField => find.byType(TextField).at(1);

  /// Login button finder (by text)
  Finder get loginButton => find.widgetWithText(ElevatedButton, 'Masuk');

  /// Register link finder
  Finder get registerLink => find.text('Daftar');

  /// Forgot password link finder
  Finder get forgotPasswordLink => find.textContaining('Lupa Password');

  /// Show password icon finder
  Finder get showPasswordIcon => find.byIcon(Icons.visibility);

  /// Hide password icon finder
  Finder get hidePasswordIcon => find.byIcon(Icons.visibility_off);

  // ============================================================================
  // ACTIONS - User interactions
  // ============================================================================

  /// Enter email
  Future<void> enterEmail(String email) async {
    print('  📝 Entering email: $email');
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();
  }

  /// Enter password
  Future<void> enterPassword(String password) async {
    print('  📝 Entering password: ${'*' * password.length}');
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();
  }

  /// Tap login button
  Future<void> tapLoginButton() async {
    print('  👆 Tapping login button...');

    expect(loginButton, findsOneWidget, reason: 'Login button should exist');
    await tester.tap(loginButton);

    // Wait for authentication process
    await tester.pumpAndSettle(const Duration(seconds: 5));
    print('  ✅ Login button tapped');
  }

  /// Tap register link
  Future<void> tapRegisterLink() async {
    print('  👆 Tapping register link...');
    await tester.tap(registerLink);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// Tap forgot password link
  Future<void> tapForgotPasswordLink() async {
    print('  👆 Tapping forgot password link...');
    await tester.tap(forgotPasswordLink);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// Toggle password visibility
  Future<void> togglePasswordVisibility() async {
    print('  👁️  Toggling password visibility...');

    // Try to find visibility icon (password is hidden)
    if (showPasswordIcon.evaluate().isNotEmpty) {
      await tester.tap(showPasswordIcon);
    } else if (hidePasswordIcon.evaluate().isNotEmpty) {
      await tester.tap(hidePasswordIcon);
    }

    await tester.pumpAndSettle();
  }

  /// Complete login flow (email + password + submit)
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
  // VERIFICATIONS - Assertions
  // ============================================================================

  /// Verify we are on login page
  void verifyOnLoginPage() {
    print('  🔍 Verifying Login page...');

    // Check for login page elements
    expect(emailField, findsOneWidget, reason: 'Email field should exist');
    expect(passwordField, findsOneWidget, reason: 'Password field should exist');
    expect(loginButton, findsOneWidget, reason: 'Login button should exist');

    print('  ✅ On Login page confirmed');
  }

  /// Verify email field is empty
  void verifyEmailFieldEmpty() {
    final widget = tester.widget<TextField>(emailField);
    expect(widget.controller?.text ?? '', isEmpty);
  }

  /// Verify password field is empty
  void verifyPasswordFieldEmpty() {
    final widget = tester.widget<TextField>(passwordField);
    expect(widget.controller?.text ?? '', isEmpty);
  }

  /// Verify error message appears
  void verifyErrorMessage(String expectedMessage) {
    print('  🔍 Verifying error message: "$expectedMessage"');

    // Error message can appear in various ways:
    // 1. As SnackBar
    // 2. As Text widget below field
    // 3. As Dialog
    final errorFinder = find.textContaining(expectedMessage);

    expect(
      errorFinder,
      findsOneWidget,
      reason: 'Error message "$expectedMessage" should be displayed',
    );

    print('  ✅ Error message verified');
  }

  /// Verify login button is enabled
  void verifyLoginButtonEnabled() {
    final button = tester.widget<ElevatedButton>(loginButton);
    expect(button.enabled, true);
  }

  /// Verify login button is disabled
  void verifyLoginButtonDisabled() {
    final button = tester.widget<ElevatedButton>(loginButton);
    expect(button.enabled, false);
  }

  /// Verify loading indicator appears
  void verifyLoadingIndicator() {
    print('  🔍 Verifying loading indicator...');
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    print('  ✅ Loading indicator found');
  }

  /// Verify successfully navigated to Dashboard
  Future<void> verifyNavigatedToDashboard() async {
    print('  🔍 Verifying navigation to Dashboard...');

    // Wait a bit for navigation animation
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Check for Dashboard elements
    // Adjust these based on your actual Dashboard page
    final dashboardTitle = find.text('Dashboard');
    final kasMasuk = find.text('Kas Masuk');
    final kasKeluar = find.text('Kas Keluar');

    // At least one of these should exist
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

  /// Verify still on login page (login failed)
  void verifyStillOnLoginPage() {
    print('  🔍 Verifying still on Login page...');
    verifyOnLoginPage();
    print('  ✅ Still on Login page (as expected)');
  }

  // ============================================================================
  // WAIT HELPERS
  // ============================================================================

  /// Wait for login process to complete
  Future<void> waitForLoginComplete() async {
    print('  ⏳ Waiting for login process...');
    await tester.pumpAndSettle(const Duration(seconds: 5));
    print('  ✅ Login process completed');
  }
}

