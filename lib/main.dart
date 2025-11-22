import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'app/app.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/warga_provider.dart';
import 'core/providers/rumah_provider.dart';
import 'core/providers/keluarga_provider.dart';
import 'core/providers/jenis_iuran_provider.dart';
import 'core/providers/agenda_provider.dart';
import 'core/providers/pemasukan_lain_provider.dart';
import 'core/providers/pengeluaran_provider.dart';
import 'core/providers/laporan_keuangan_detail_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ============================================================================
  // CONNECTION TEST DISABLED
  // Reason: Causes permission-denied error in production
  // Only enable for debugging if needed
  // ============================================================================
  /*
  print('\n🔥 ========== FIRESTORE CONNECTION TEST ==========');
  try {
    final firestore = FirebaseFirestore.instance;

    print('🔵 Testing write to Firestore...');
    final testDoc = await firestore.collection('_connection_test').add({
      'test': true,
      'timestamp': FieldValue.serverTimestamp(),
      'from': 'main.dart startup',
    });
    print('✅ CONNECTION TEST SUCCESS! Doc ID: ${testDoc.id}');

    print('🔵 Testing write to tagihan collection...');
    final tagihanDoc = await firestore.collection('tagihan').add({
      'kodeTagihan': 'TEST_MAIN_${DateTime.now().millisecondsSinceEpoch}',
      'jenisIuranId': 'test',
      'jenisIuranName': 'Test dari Main',
      'keluargaId': 'test_001',
      'keluargaName': 'Test Keluarga Main',
      'nominal': 99999,
      'periode': 'Test Main Startup',
      'periodeTanggal': Timestamp.now(),
      'status': 'Belum Dibayar',
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('✅ TAGIHAN TEST SUCCESS! Doc ID: ${tagihanDoc.id}');
    print('🔥 ========== ALL TESTS PASSED! ==========\n');
  } catch (e, stackTrace) {
    print('❌ ========== CONNECTION TEST FAILED! ==========');
    print('❌ Error: $e');
    print('❌ StackTrace: $stackTrace');
    print('❌ ==========================================\n');
  }
  */

  print('✅ Firebase initialized successfully');

  // Initialize Indonesian locale for date formatting
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WargaProvider()),
        ChangeNotifierProvider(create: (_) => RumahProvider()),
        ChangeNotifierProvider(create: (_) => KeluargaProvider()),
        ChangeNotifierProvider(create: (_) => JenisIuranProvider()),
        ChangeNotifierProvider(create: (_) => AgendaProvider()),
        ChangeNotifierProvider(create: (_) => PemasukanLainProvider()),
        ChangeNotifierProvider(create: (_) => PengeluaranProvider()),
        ChangeNotifierProvider(create: (_) => LaporanKeuanganDetailProvider()),
      ],
      child: const JawaraApp(),
    ),
  );
}
