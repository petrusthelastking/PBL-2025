import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'generate_dummy_kegiatan.dart';

/// Quick generator untuk dummy kegiatan
/// Run: flutter run lib/quick_generate_kegiatan.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GeneratorApp());
}

class GeneratorApp extends StatelessWidget {
  const GeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generate Dummy Kegiatan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GeneratorHomePage(),
    );
  }
}

class GeneratorHomePage extends StatefulWidget {
  const GeneratorHomePage({super.key});

  @override
  State<GeneratorHomePage> createState() => _GeneratorHomePageState();
}

class _GeneratorHomePageState extends State<GeneratorHomePage> {
  final GenerateDummyKegiatan _generator = GenerateDummyKegiatan();
  bool _isLoading = false;
  String _message = 'Siap generate dummy kegiatan';
  Color _messageColor = Colors.black;

  Future<void> _generateKegiatan() async {
    setState(() {
      _isLoading = true;
      _message = 'Generating kegiatan...';
      _messageColor = Colors.blue;
    });

    try {
      await _generator.generateKegiatan();
      setState(() {
        _isLoading = false;
        _message = '✅ Berhasil generate 15 kegiatan!';
        _messageColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Error: $e';
        _messageColor = Colors.red;
      });
    }
  }

  Future<void> _deleteAllKegiatan() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus semua kegiatan?\nTindakan ini tidak bisa dibatalkan!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _message = 'Deleting kegiatan...';
      _messageColor = Colors.orange;
    });

    try {
      await _generator.deleteAllKegiatan();
      setState(() {
        _isLoading = false;
        _message = '✅ Semua kegiatan berhasil dihapus!';
        _messageColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Error: $e';
        _messageColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Dummy Kegiatan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_note,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              Text(
                _message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _messageColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (_isLoading)
                const CircularProgressIndicator()
              else ...[
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _generateKegiatan,
                    icon: const Icon(Icons.add_circle),
                    label: const Text(
                      'Generate 15 Kegiatan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _deleteAllKegiatan,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text(
                      'Hapus Semua Kegiatan',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Dummy Data Kegiatan:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 15 kegiatan realistis\n'
                '• Tanggal: Nov 2025 - Feb 2026\n'
                '• Kategori: Sosial, Kesehatan, Keagamaan, dll\n'
                '• Lokasi bervariasi\n'
                '• Deskripsi lengkap',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

