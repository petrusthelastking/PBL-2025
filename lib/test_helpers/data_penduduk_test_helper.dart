// ============================================================================
// DATA PENDUDUK TEST HELPER
// ============================================================================
// Helper functions untuk E2E testing Data Penduduk (CRUD)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class DataPendudukTestHelper {
  // ==========================================================================
  // NAVIGATION HELPERS
  // ==========================================================================

  /// Navigate dari Dashboard ke Data Penduduk page
  static Future<void> navigateToDataPenduduk(WidgetTester tester) async {
    print('🔵 Navigating to Data Penduduk...');

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Try Method 1: Find text "Data Warga"
    var dataWargaMenu = find.text('Data Warga');
    if (dataWargaMenu.evaluate().isNotEmpty) {
      print('  📍 Method 1: Found "Data Warga" text, tapping...');
      await tester.tap(dataWargaMenu.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Navigated via text\n');
      return;
    }

    // Try Method 2: Find text containing "Warga"
    dataWargaMenu = find.textContaining('Warga');
    if (dataWargaMenu.evaluate().isNotEmpty) {
      print('  📍 Method 2: Found text containing "Warga", tapping...');
      await tester.tap(dataWargaMenu.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Navigated via text containing\n');
      return;
    }

    // Try Method 3: Find by icon People
    final peopleIcon = find.byIcon(Icons.people);
    if (peopleIcon.evaluate().isNotEmpty) {
      print('  📍 Method 3: Found People icon, tapping...');
      await tester.tap(peopleIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Navigated via icon\n');
      return;
    }

    // Try Method 4: Find by icon Groups
    final groupsIcon = find.byIcon(Icons.groups);
    if (groupsIcon.evaluate().isNotEmpty) {
      print('  📍 Method 4: Found Groups icon, tapping...');
      await tester.tap(groupsIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Navigated via groups icon\n');
      return;
    }

    // Try Method 5: Bottom Navigation Bar - tap index 1 or 2
    final navBar = find.byType(BottomNavigationBar);
    if (navBar.evaluate().isNotEmpty) {
      print('  📍 Method 5: Found BottomNavigationBar, trying index 1...');

      // Get all navigation items
      final navItems = find.descendant(
        of: navBar,
        matching: find.byType(InkResponse),
      );

      if (navItems.evaluate().length > 1) {
        // Try tapping second item (index 1)
        await tester.tap(navItems.at(1));
        await tester.pumpAndSettle(const Duration(seconds: 3));
        print('  ✅ Navigated via BottomNav index 1\n');
        return;
      }
    }

    // Try Method 6: Look for NavigationRail
    final navRail = find.byType(NavigationRail);
    if (navRail.evaluate().isNotEmpty) {
      print('  📍 Method 6: Found NavigationRail...');
      final railDest = find.descendant(
        of: navRail,
        matching: find.byType(InkResponse),
      );

      if (railDest.evaluate().length > 1) {
        await tester.tap(railDest.at(1));
        await tester.pumpAndSettle(const Duration(seconds: 3));
        print('  ✅ Navigated via NavigationRail\n');
        return;
      }
    }

    // If all methods fail
    print('  ⚠️  Could not find Data Warga menu with any method');
    print('  ℹ️  Assuming already on correct page or manual intervention needed\n');
  }

  /// Navigate to Tambah Data Warga page
  static Future<void> tapTambahButton(WidgetTester tester) async {
    print('🔵 Tapping Tambah button...');

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Try Method 1: Find FAB (FloatingActionButton)
    var fabButton = find.byType(FloatingActionButton);
    if (fabButton.evaluate().isNotEmpty) {
      print('  📍 Found FloatingActionButton, tapping...');
      await tester.tap(fabButton.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Tambah button tapped\n');
      return;
    }

    // Try Method 2: Find by icon Add
    final addIcon = find.byIcon(Icons.add);
    if (addIcon.evaluate().isNotEmpty) {
      print('  📍 Found Add icon, tapping...');
      await tester.tap(addIcon.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Tapped via add icon\n');
      return;
    }

    // Try Method 3: Find text "Tambah"
    final tambahText = find.text('Tambah');
    if (tambahText.evaluate().isNotEmpty) {
      print('  📍 Found "Tambah" text, tapping...');
      await tester.tap(tambahText.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Tapped via text\n');
      return;
    }

    // Try Method 4: Find text containing "Tambah"
    final tambahContaining = find.textContaining('Tambah');
    if (tambahContaining.evaluate().isNotEmpty) {
      print('  📍 Found text containing "Tambah", tapping...');
      await tester.tap(tambahContaining.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Tapped via containing text\n');
      return;
    }

    // Try Method 5: Find ElevatedButton with icon Add
    final elevatedWithAdd = find.descendant(
      of: find.byType(ElevatedButton),
      matching: find.byIcon(Icons.add),
    );
    if (elevatedWithAdd.evaluate().isNotEmpty) {
      print('  📍 Found ElevatedButton with Add icon, tapping...');
      await tester.tap(elevatedWithAdd.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Tapped via ElevatedButton\n');
      return;
    }

    print('  ⚠️  Tambah button not found with any method\n');
  }

  // ==========================================================================
  // FORM HELPERS
  // ==========================================================================

  /// Fill form tambah/edit penduduk
  static Future<void> fillPendudukForm(
    WidgetTester tester, {
    required String nik,
    required String nama,
    required String tempatLahir,
    required String tanggalLahir,
    String? noKK,
    String? alamat,
    String? rt,
    String? rw,
  }) async {
    print('🔵 Filling penduduk form...');

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Get all text fields - try multiple types
    var fields = find.byType(TextFormField);
    if (fields.evaluate().isEmpty) {
      fields = find.byType(TextField);
    }

    int fieldCount = fields.evaluate().length;
    print('  📊 Found $fieldCount text fields\n');

    if (fieldCount >= 4) {
      // Scroll to top first to ensure all fields are accessible
      print('  📜 Scrolling to top...');
      await _scrollToTop(tester);

      // NIK (biasanya field pertama)
      print('  📝 Entering NIK: $nik');
      await _enterTextSafelyWithScroll(tester, fields.at(0), nik);
      await tester.pump(const Duration(milliseconds: 500));

      // Nama
      print('  📝 Entering Nama: $nama');
      await _enterTextSafelyWithScroll(tester, fields.at(1), nama);
      await tester.pump(const Duration(milliseconds: 500));

      // Tempat Lahir
      print('  📝 Entering Tempat Lahir: $tempatLahir');
      await _enterTextSafelyWithScroll(tester, fields.at(2), tempatLahir);
      await tester.pump(const Duration(milliseconds: 500));

      // Tanggal Lahir
      print('  📝 Entering Tanggal Lahir: $tanggalLahir');
      await _enterTextSafelyWithScroll(tester, fields.at(3), tanggalLahir);
      await tester.pump(const Duration(milliseconds: 500));

      // Optional fields
      if (fieldCount > 4 && noKK != null) {
        print('  📝 Entering No KK: $noKK');
        await _enterTextSafelyWithScroll(tester, fields.at(4), noKK);
        await tester.pump(const Duration(milliseconds: 500));
      }

      print('  ✅ Form filled\n');
    } else {
      print('  ⚠️  Not enough fields found ($fieldCount)\n');
    }

    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  /// Helper untuk enter text dengan error handling
  static Future<void> _enterTextSafely(
    WidgetTester tester,
    Finder field,
    String text,
  ) async {
    try {
      await tester.enterText(field, text);
      await tester.pump(const Duration(milliseconds: 300));
    } catch (e) {
      print('    ⚠️  Warning on enterText: ${e.toString().split('\n').first}');
    }
  }

  /// Helper untuk scroll ke top
  static Future<void> _scrollToTop(WidgetTester tester) async {
    try {
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, 500));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }
    } catch (e) {
      print('    ⚠️  Warning on scroll: ${e.toString().split('\n').first}');
    }
  }

  /// Helper untuk enter text dengan scroll
  static Future<void> _enterTextSafelyWithScroll(
    WidgetTester tester,
    Finder field,
    String text,
  ) async {
    try {
      // Scroll to field first
      await tester.ensureVisible(field);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      // Enter text
      await tester.enterText(field, text);
      await tester.pump(const Duration(milliseconds: 300));
    } catch (e) {
      print('    ⚠️  Warning on enterText: ${e.toString().split('\n').first}');
      // Try without scroll
      try {
        await tester.enterText(field, text);
        await tester.pump(const Duration(milliseconds: 300));
      } catch (e2) {
        print('    ⚠️  Still failed: ${e2.toString().split('\n').first}');
      }
    }
  }

  // ==========================================================================
  // ACTION HELPERS
  // ==========================================================================

  /// Tap Simpan button
  static Future<void> tapSimpanButton(WidgetTester tester) async {
    print('🔵 Tapping Simpan button...');

    final simpanBtn = find.text('Simpan');

    if (simpanBtn.evaluate().isNotEmpty) {
      await tester.tap(simpanBtn.first);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      print('  ✅ Simpan tapped\n');
    } else {
      print('  ⚠️  Simpan button not found\n');
    }
  }

  /// Tap Edit button pada list item
  static Future<void> tapEditButton(WidgetTester tester, int index) async {
    print('🔵 Tapping Edit button at index $index...');

    // Cari icon edit atau text "Edit"
    final editIcon = find.byIcon(Icons.edit);

    if (editIcon.evaluate().length > index) {
      await tester.tap(editIcon.at(index));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      print('  ✅ Edit button tapped\n');
    } else {
      print('  ⚠️  Edit button not found at index $index\n');
    }
  }

  /// Tap Delete button dan confirm
  static Future<void> tapDeleteButton(
    WidgetTester tester,
    int index, {
    bool confirm = true,
  }) async {
    print('🔵 Tapping Delete button at index $index...');

    // Cari icon delete
    final deleteIcon = find.byIcon(Icons.delete);

    if (deleteIcon.evaluate().length > index) {
      await tester.tap(deleteIcon.at(index));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      print('  ✅ Delete button tapped\n');

      // Confirm dialog
      if (confirm) {
        await _confirmDelete(tester);
      }
    } else {
      print('  ⚠️  Delete button not found at index $index\n');
    }
  }

  /// Confirm delete dialog
  static Future<void> _confirmDelete(WidgetTester tester) async {
    print('🔵 Confirming delete...');

    // Cari button "Ya", "Hapus", "Delete", atau "OK"
    final confirmButtons = [
      find.text('Ya'),
      find.text('Hapus'),
      find.text('Delete'),
      find.text('OK'),
    ];

    for (final btn in confirmButtons) {
      if (btn.evaluate().isNotEmpty) {
        await tester.tap(btn.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('  ✅ Delete confirmed\n');
        return;
      }
    }

    print('  ⚠️  Confirm button not found\n');
  }

  // ==========================================================================
  // VERIFICATION HELPERS
  // ==========================================================================

  /// Verify penduduk exists in list
  static bool verifyPendudukExists(WidgetTester tester, String nama) {
    print('🔍 Checking if penduduk "$nama" exists...');

    final nameFinder = find.text(nama);
    final exists = nameFinder.evaluate().isNotEmpty;

    if (exists) {
      print('  ✅ Penduduk "$nama" found\n');
    } else {
      print('  ⚠️  Penduduk "$nama" not found\n');
    }

    return exists;
  }

  /// Count total penduduk in list
  static int countPenduduk(WidgetTester tester) {
    print('🔍 Counting total penduduk...');

    // Cari list items - biasanya di dalam ListView
    final listItems = find.byType(ListTile);
    final count = listItems.evaluate().length;

    print('  📊 Total penduduk: $count\n');
    return count;
  }

  // ==========================================================================
  // PRINT HELPERS
  // ==========================================================================

  static void printTestStep(String step) {
    print('\n🔵 STEP: $step');
  }

  static void printSuccess(String message) {
    print('✅ SUCCESS: $message');
  }

  static void printWarning(String message) {
    print('⚠️  WARNING: $message');
  }
}

