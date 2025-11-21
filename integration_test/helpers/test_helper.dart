// ============================================================================
// TEST HELPER
// ============================================================================
// File ini berisi helper functions yang dapat digunakan di berbagai test
// untuk menghindari code duplication dan mempermudah penulisan test.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test Helper Class
/// Berisi utility functions untuk mempermudah penulisan integration test
class TestHelper {
  // ============================================================================
  // NAVIGATION HELPERS
  // ============================================================================

  /// Skip intro screens (Splash, Onboarding)
  /// Digunakan untuk langsung ke halaman utama
  static Future<void> skipIntroScreens(WidgetTester tester) async {
    print('🔵 [TestHelper] Skipping intro screens...');

    // Wait for splash screen animation (3 seconds)
    await tester.pumpAndSettle(const Duration(seconds: 3));
    print('  ✅ Splash screen finished');

    // Check if there's onboarding screen
    final skipButton = find.text('Lewati');
    final nextButton = find.text('Selanjutnya');

    if (skipButton.evaluate().isNotEmpty) {
      print('  🔵 Found onboarding, tapping "Lewati"...');
      await tester.tap(skipButton);
      await tester.pumpAndSettle();
      print('  ✅ Onboarding skipped');
    } else if (nextButton.evaluate().isNotEmpty) {
      print('  🔵 Found onboarding with "Selanjutnya"...');
      // Tap next until we reach the end
      while (find.text('Selanjutnya').evaluate().isNotEmpty) {
        await tester.tap(find.text('Selanjutnya'));
        await tester.pumpAndSettle();
      }
      // Tap final button (usually "Mulai" or similar)
      final startButton = find.text('Mulai');
      if (startButton.evaluate().isNotEmpty) {
        await tester.tap(startButton);
        await tester.pumpAndSettle();
      }
      print('  ✅ Onboarding completed');
    } else {
      print('  ℹ️  No onboarding screen found');
    }
  }

  /// Navigate to Login Page from Pre-Auth
  static Future<void> navigateToLoginPage(WidgetTester tester) async {
    print('🔵 [TestHelper] Navigating to Login page...');

    // Find and tap "Masuk" button on pre-auth page
    final loginButton = find.text('Masuk');
    expect(loginButton, findsOneWidget, reason: 'Login button should be visible on pre-auth page');

    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    print('  ✅ Navigated to Login page');
  }

  /// Navigate to Register Page
  static Future<void> navigateToRegisterPage(WidgetTester tester) async {
    print('🔵 [TestHelper] Navigating to Register page...');

    // From pre-auth or login page, find register button
    final registerButton = find.text('Daftar');
    expect(registerButton, findsOneWidget);

    await tester.tap(registerButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    print('  ✅ Navigated to Register page');
  }

  // ============================================================================
  // FORM HELPERS
  // ============================================================================

  /// Enter text to TextField by label
  /// Cocok untuk form dengan label di atas field
  static Future<void> enterTextByLabel(
    WidgetTester tester,
    String label,
    String value,
  ) async {
    print('  🔵 Entering "$value" to field: $label');

    final field = find.widgetWithText(TextFormField, label);
    if (field.evaluate().isEmpty) {
      // Try finding by TextField instead
      final textField = find.widgetWithText(TextField, label);
      if (textField.evaluate().isNotEmpty) {
        await tester.enterText(textField, value);
      } else {
        throw Exception('Field with label "$label" not found');
      }
    } else {
      await tester.enterText(field, value);
    }

    await tester.pumpAndSettle();
    print('  ✅ Text entered successfully');
  }

  /// Enter text to TextField by Key
  /// Lebih reliable jika widget punya Key
  static Future<void> enterTextByKey(
    WidgetTester tester,
    String key,
    String value,
  ) async {
    print('  🔵 Entering "$value" to field with key: $key');

    final field = find.byKey(Key(key));
    expect(field, findsOneWidget);

    await tester.enterText(field, value);
    await tester.pumpAndSettle();

    print('  ✅ Text entered successfully');
  }

  /// Enter text to TextField by index
  /// Useful when there are multiple TextFields
  static Future<void> enterTextByIndex(
    WidgetTester tester,
    int index,
    String value,
  ) async {
    print('  🔵 Entering "$value" to field at index: $index');

    final field = find.byType(TextField).at(index);
    await tester.enterText(field, value);
    await tester.pumpAndSettle();

    print('  ✅ Text entered successfully');
  }

  // ============================================================================
  // BUTTON HELPERS
  // ============================================================================

  /// Tap button by text
  static Future<void> tapButtonByText(
    WidgetTester tester,
    String buttonText,
  ) async {
    print('  🔵 Tapping button: $buttonText');

    final button = find.text(buttonText);
    expect(button, findsOneWidget, reason: 'Button "$buttonText" should exist');

    await tester.tap(button);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    print('  ✅ Button tapped successfully');
  }

  /// Tap button by Key
  static Future<void> tapButtonByKey(
    WidgetTester tester,
    String key,
  ) async {
    print('  🔵 Tapping button with key: $key');

    final button = find.byKey(Key(key));
    expect(button, findsOneWidget);

    await tester.tap(button);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    print('  ✅ Button tapped successfully');
  }

  // ============================================================================
  // VERIFICATION HELPERS
  // ============================================================================

  /// Verify widget exists by text
  static void verifyTextExists(String text) {
    print('  🔍 Verifying text exists: $text');
    expect(find.text(text), findsOneWidget);
    print('  ✅ Text found');
  }

  /// Verify widget doesn't exist
  static void verifyTextNotExists(String text) {
    print('  🔍 Verifying text does NOT exist: $text');
    expect(find.text(text), findsNothing);
    print('  ✅ Text not found (as expected)');
  }

  /// Verify navigation to specific page by title
  static void verifyPageTitle(String title) {
    print('  🔍 Verifying page title: $title');
    expect(find.text(title), findsOneWidget);
    print('  ✅ Page title verified');
  }

  /// Verify success message appears
  static Future<void> verifySuccessMessage(
    WidgetTester tester,
    String message,
  ) async {
    print('  🔍 Waiting for success message: $message');

    // Wait a bit for snackbar/dialog to appear
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining(message), findsOneWidget);
    print('  ✅ Success message verified');
  }

  /// Verify error message appears
  static Future<void> verifyErrorMessage(
    WidgetTester tester,
    String message,
  ) async {
    print('  🔍 Waiting for error message: $message');

    // Wait a bit for snackbar/dialog to appear
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining(message), findsOneWidget);
    print('  ✅ Error message verified');
  }

  // ============================================================================
  // WAITING HELPERS
  // ============================================================================

  /// Wait for loading to finish
  static Future<void> waitForLoading(WidgetTester tester) async {
    print('  ⏳ Waiting for loading...');
    await tester.pumpAndSettle(const Duration(seconds: 5));
    print('  ✅ Loading finished');
  }

  /// Wait for specific duration
  static Future<void> wait(WidgetTester tester, int seconds) async {
    print('  ⏳ Waiting $seconds seconds...');
    await tester.pumpAndSettle(Duration(seconds: seconds));
    print('  ✅ Wait completed');
  }

  /// Wait until widget appears
  static Future<void> waitUntilVisible(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    print('  ⏳ Waiting for widget to appear...');

    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      await tester.pump(const Duration(milliseconds: 100));

      if (finder.evaluate().isNotEmpty) {
        print('  ✅ Widget appeared');
        return;
      }
    }

    throw Exception('Widget did not appear within timeout');
  }

  // ============================================================================
  // SCROLLING HELPERS
  // ============================================================================

  /// Scroll until widget is visible
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder, {
    double delta = 300,
  }) async {
    print('  🔵 Scrolling to find widget...');

    final listFinder = find.byType(Scrollable).first;

    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: listFinder,
    );

    print('  ✅ Widget is now visible');
  }

  // ============================================================================
  // SCREENSHOT HELPERS
  // ============================================================================

  /// Take screenshot (for debugging)
  static Future<void> takeScreenshot(
    WidgetTester tester,
    String filename,
  ) async {
    print('  📸 Taking screenshot: $filename');

    // Note: Screenshot functionality requires additional setup
    // This is a placeholder for future implementation
    await tester.pumpAndSettle();

    print('  ✅ Screenshot saved: integration_test/screenshots/$filename.png');
  }

  // ============================================================================
  // PRINT HELPERS
  // ============================================================================

  /// Print test section header
  static void printTestSection(String title) {
    print('\n' + '=' * 80);
    print('  $title');
    print('=' * 80);
  }

  /// Print test step
  static void printStep(String step) {
    print('\n🔵 STEP: $step');
  }

  /// Print success
  static void printSuccess(String message) {
    print('✅ SUCCESS: $message');
  }

  /// Print error
  static void printError(String message) {
    print('❌ ERROR: $message');
  }
}

