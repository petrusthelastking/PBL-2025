// ============================================================================
// TEST HELPER (LIB VERSION)
// ============================================================================
// File ini adalah copy dari integration_test/helpers/test_helper.dart
// Dipindahkan ke lib/ agar bisa di-import dengan package path
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
  static Future<void> skipIntroScreens(WidgetTester tester) async {
    print('🔵 [TestHelper] Skipping intro screens...');

    await tester.pumpAndSettle(const Duration(seconds: 3));
    print('  ✅ Splash screen finished');

    final skipButton = find.text('Lewati');
    final nextButton = find.text('Selanjutnya');

    if (skipButton.evaluate().isNotEmpty) {
      print('  🔵 Found onboarding, tapping "Lewati"...');
      await tester.tap(skipButton);
      await tester.pumpAndSettle();
      print('  ✅ Onboarding skipped');
    } else if (nextButton.evaluate().isNotEmpty) {
      print('  🔵 Found onboarding with "Selanjutnya"...');
      while (find.text('Selanjutnya').evaluate().isNotEmpty) {
        await tester.tap(find.text('Selanjutnya'));
        await tester.pumpAndSettle();
      }
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

    final loginButton = find.text('Masuk');
    expect(loginButton, findsOneWidget, reason: 'Login button should be visible on pre-auth page');

    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    print('  ✅ Navigated to Login page');
  }

  // ============================================================================
  // FORM HELPERS
  // ============================================================================

  /// Enter text to TextField by index
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

  // ============================================================================
  // VERIFICATION HELPERS
  // ============================================================================

  /// Verify widget exists by text
  static void verifyTextExists(String text) {
    print('  🔍 Verifying text exists: $text');
    expect(find.text(text), findsOneWidget);
    print('  ✅ Text found');
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
}

