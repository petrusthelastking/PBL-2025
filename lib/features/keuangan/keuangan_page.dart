import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/app_bottom_navigation.dart';
import '../../core/widgets/export_dialog.dart';
import '../../core/services/keuangan_summary_service.dart';
import '../dashboard/dashboard_page.dart';
import '../data_warga/data_penduduk/data_penduduk_page.dart';
import '../agenda/kegiatan/kegiatan_page.dart';
import 'kelola_pemasukan/kelola_pemasukan_page.dart';
import 'kelola_pengeluaran/kelola_pengeluaran_page.dart';
import 'daftar_metode_page.dart';
import 'tambah_metode_pembayaran_sheet.dart';

class KeuanganPage extends StatefulWidget {
  const KeuanganPage({super.key});

  @override
  State<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage> {
  bool _isAssetVisible = true;
  String _searchQuery = '';
  DateTime _selectedDate = DateTime.now();
  int? _expandedIndex;
  bool _showPengeluaran = false;

  // State untuk modal cetak laporan
  DateTime _printStartDate = DateTime.now();
  DateTime _printEndDate = DateTime.now();
  String _selectedReportType = 'Semua';
  final List<String> _reportTypes = ['Semua', 'Pemasukan', 'Pengeluaran'];

  // Data Pemasukan
  final List<Map<String, dynamic>> _mockPemasukan = [
    {
      'id': 1,
      'title': 'Kerja Bakti',
      'subtitle': 'Pemeliharaan Fasilitas',
      'date': '19 Oct 2025 20:26',
      'nik': '3201234567890123',
      'jumlah': 'Rp 50.000,00',
      'nominal': 'Rp 50.000,00',
      'kategori': 'Pemeliharaan Fasilitas',
      'verifikator': 'Admin Jawara'
    },
    {
      'id': 2,
      'title': 'Iuran Warga Bulanan',
      'subtitle': 'Iuran Rutin',
      'date': '18 Oct 2025 10:00',
      'nik': '3201234567890124',
      'jumlah': 'Rp 200.000,00',
      'nominal': 'Rp 200.000,00',
      'kategori': 'Iuran Warga',
      'verifikator': 'Admin Jawara'
    },
    {
      'id': 3,
      'title': 'Donasi Pembangunan',
      'subtitle': 'Dana Pembangunan',
      'date': '17 Oct 2025 14:30',
      'nik': '3201234567890125',
      'jumlah': 'Rp 500.000,00',
      'nominal': 'Rp 500.000,00',
      'kategori': 'Donasi',
      'verifikator': 'Admin Jawara'
    },
  ];

  // Data Pengeluaran
  final List<Map<String, dynamic>> _mockPengeluaran = [
    {
      'id': 1,
      'title': 'Joki by firman',
      'subtitle': 'Pendapatan Lainnya',
      'date': '15 Okt 2025 14:23',
      'nik': '3201234567890126',
      'jumlah': 'Rp 11.000',
      'nominal': 'Rp 11.000',
      'kategori': 'Dana Bantuan Pemerintah',
      'verifikator': 'Admin Jawara'
    },
    {
      'id': 2,
      'title': 'Joki by firman',
      'subtitle': 'Pendapatan Lainnya',
      'date': '14 Okt 2025 10:15',
      'nik': '3201234567890127',
      'jumlah': 'Rp 50.000',
      'nominal': 'Rp 50.000',
      'kategori': 'Iuran Warga',
      'verifikator': 'Admin Jawara'
    },
    {
      'id': 3,
      'title': 'Joki by firman',
      'subtitle': 'Pendapatan Lainnya',
      'date': '13 Okt 2025 16:45',
      'nik': '3201234567890128',
      'jumlah': 'Rp 25.000',
      'nominal': 'Rp 25.000',
      'kategori': 'Dana Kegiatan',
      'verifikator': 'Admin Jawara'
    },
    {
      'id': 4,
      'title': 'Joki by firman',
      'subtitle': 'Pendapatan Lainnya',
      'date': '12 Okt 2025 09:30',
      'nik': '3201234567890129',
      'jumlah': 'Rp 100.000',
      'nominal': 'Rp 100.000',
      'kategori': 'Donasi',
      'verifikator': 'Admin Jawara'
    },
    {
      'id': 5,
      'title': 'Joki by firman',
      'subtitle': 'Pendapatan Lainnya',
      'date': '11 Okt 2025 13:20',
      'nik': '3201234567890130',
      'jumlah': 'Rp 75.000',
      'nominal': 'Rp 75.000',
      'kategori': 'Iuran Bulanan',
      'verifikator': 'Admin Jawara'
    },
  ];

  // Dynamic data from Firebase
  final KeuanganSummaryService _keuanganService = KeuanganSummaryService();
  bool _isLoadingKeuangan = true;
  double _totalPemasukan = 0;
  double _totalPengeluaran = 0;
  double _totalAsset = 0;
  int _pemasukanPercentage = 0;
  int _pengeluaranPercentage = 0;
  double _growthPercentage = 0;

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  List<Map<String, dynamic>> get _filteredReports {
    // Pilih data berdasarkan tombol yang aktif
    final sourceData = _showPengeluaran ? _mockPengeluaran : _mockPemasukan;

    return sourceData.where((report) {
      final matchesSearch = _searchQuery.isEmpty ||
          report['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report['subtitle'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report['kategori'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadKeuanganData();
  }

  Future<void> _loadKeuanganData() async {
    setState(() {
      _isLoadingKeuangan = true;
    });

    try {
      final summary = await _keuanganService.getKeuanganSummary();

      if (mounted) {
        setState(() {
          _totalPemasukan = summary['totalPemasukan'] ?? 0;
          _totalPengeluaran = summary['totalPengeluaran'] ?? 0;
          _totalAsset = summary['totalAsset'] ?? 0;
          _pemasukanPercentage = summary['pemasukanPercentage'] ?? 0;
          _pengeluaranPercentage = summary['pengeluaranPercentage'] ?? 0;
          _growthPercentage = summary['growthPercentage'] ?? 0;
          _isLoadingKeuangan = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingKeuangan = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2988EA),
      body: Stack(
        children: [
          SizedBox(
            child: Column(
              children: [
                // AppBar di area biru
                _buildAppBar(),
                // Content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        // Cards di area biru
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _buildTotalAssetCard(),
                              const SizedBox(height: 16),
                              _buildKPICards(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        // Content di area putih dengan rounded corner
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildKelolaButtons(),
                                const SizedBox(height: 20),
                                _buildTotalPills(),
                                const SizedBox(height: 20),
                                _buildLaporanSection(),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: const AppBottomNavigation(currentIndex: 2))
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keuangan',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kelola finansial dengan mudah',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            _buildAppBarIcon(Icons.search_rounded),
            const SizedBox(width: 10),
            _buildAppBarIcon(Icons.notifications_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarIcon(IconData icon) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildTotalAssetCard() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF8FAFF),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2988EA).withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 10),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2988EA).withOpacity(0.1),
                        const Color(0xFF2988EA).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF2988EA).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 16,
                        color: const Color(0xFF2988EA),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Total Nilai Aset',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF2988EA),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAssetVisible = !_isAssetVisible;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2988EA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF2988EA).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _isAssetVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    size: 20,
                    color: const Color(0xFF2988EA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _isAssetVisible ? 'Rp 100.000.000' : '••••••••••',
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F2937),
              letterSpacing: -1,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+12.5%',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'dari bulan lalu',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showTambahMetodePembayaranSheet(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2988EA),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2988EA).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF2988EA)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Tambah Opsi',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2988EA),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print('Daftar Metode button clicked!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaftarMetodePage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2988EA),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2988EA).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.list_alt_outlined, size: 18, color: Color(0xFF2988EA)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Daftar Metode',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2988EA),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards() {
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            title: 'Total Pengeluaran',
            amount: _isLoadingKeuangan ? 'Memuat...' : currencyFormat.format(_totalPengeluaran),
            percentage: _pengeluaranPercentage,
            color: const Color(0xFFEF4444),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildKPICard(
            title: 'Total Pemasukan',
            amount: _isLoadingKeuangan ? 'Memuat...' : currencyFormat.format(_totalPemasukan),
            percentage: _pemasukanPercentage,
            color: const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String amount,
    required int percentage,
    required Color color,
  }) {
    // Tentukan apakah ini card pemasukan atau pengeluaran
    final isPemasukan = title.contains('Pemasukan');
    final lightColor = isPemasukan ? const Color(0xFFEBF5FF) : const Color(0xFFFEE2E2);
    final iconData = isPemasukan ? Icons.trending_up_rounded : Icons.trending_down_rounded;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            lightColor.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Circular Progress (Donut) dengan design lebih modern
          SizedBox(
            width: 95,
            height: 95,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow effect
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                // Background Circle (Track)
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightColor,
                  ),
                ),
                // Progress Circle dengan gradient
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Center content dengan icon dan percentage
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        iconData,
                        color: color,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$percentage%',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Caption (Title)
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          // Amount (Nominal) dengan style lebih bold
          Text(
            amount,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F2937),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          // Cetak Button dengan design lebih modern
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () => _showPrintModal(isPemasukan: isPemasukan),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: color.withOpacity(0.4),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return color.withOpacity(0.8);
                    }
                    return color;
                  },
                ),
                elevation: MaterialStateProperty.resolveWith<double>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return 2;
                    }
                    return 4;
                  },
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.print_rounded, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Cetak',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKelolaButtons() {
    return Column(
      children: [
        // Row pertama: Kelola Pemasukan & Pengeluaran
        Row(
          children: [
            Expanded(
              child: _buildKelolaButton(
                icon: Icons.account_balance_wallet,
                label: 'Kelola\nPemasukan',
                iconColor: const Color(0xFF4ADE80), // Green icon
                backgroundColor1: const Color(0xFF2988EA), // Biru
                backgroundColor2: const Color(0xFF2988EA), // Biru
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KelolaPemasukanPage()),
                  );
                },
                height: 130,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKelolaButton(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Kelola\nPengeluaran',
                iconColor: const Color(0xFFEF4444), // Red icon
                backgroundColor1: const Color(0xFF2988EA), // Biru
                backgroundColor2: const Color(0xFF2988EA), // Biru
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const KelolaPengeluaranPage()),
                  );
                },
                height: 130,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Row kedua: Kelola Agenda (FULL WIDTH dari kiri ke kanan)
        SizedBox(
          width: double.infinity, // Memastikan card lebar penuh
          child: _buildKelolaButton(
            icon: Icons.event_note_rounded,
            label: 'Kelola Agenda',
            iconColor: const Color(0xFFFBBF24), // Yellow/Amber icon
            backgroundColor1: const Color(0xFF2988EA), // Biru
            backgroundColor2: const Color(0xFF2988EA), // Biru
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgendaPage()),
              );
            },
            height: 130, // SAMA TINGGI dengan card Pemasukan & Pengeluaran
          ),
        ),
      ],
    );
  }

  Widget _buildKelolaButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color backgroundColor1,
    required Color backgroundColor2,
    required VoidCallback onTap,
    double height = 130, // Default height 130, bisa diubah
  }) {
    // Tentukan apakah ini tombol pemasukan atau pengeluaran berdasarkan iconColor
    final isPemasukan = iconColor == const Color(0xFF4ADE80);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height, // Gunakan parameter height
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor1,
              backgroundColor2.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: backgroundColor1.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circle background
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: -10,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon dengan background glossy
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                // Label dengan style modern
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.replaceAll('\n', ' '),
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lihat detail',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white.withOpacity(0.85),
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTotalPills() {
    return Row(
      children: [
        Expanded(
          child: _buildPill(
            icon: Icons.arrow_circle_down_outlined,
            label: 'Total Pengeluaran',
            isActive: _showPengeluaran,
            onTap: () {
              setState(() {
                _showPengeluaran = true;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildPill(
            icon: Icons.arrow_circle_up_outlined,
            label: 'Total Pemasukan',
            isActive: !_showPengeluaran,
            onTap: () {
              setState(() {
                _showPengeluaran = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPill({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2988EA),
                    Color(0xFF2988EA),
                  ],
                )
              : null,
          color: isActive ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? const Color(0xFF2988EA) : const Color(0xFFE8EAF2),
            width: isActive ? 1.5 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF2988EA).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ),
            const SizedBox(width: 20), // Balance the icon on left
          ],
        ),
      ),
    );
  }

  Widget _buildLaporanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details Laporan Keuangan',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 16),
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildReportsList(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE8EAF2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Laporan',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => _showDatePicker(),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2988EA),
                  Color(0xFF2988EA),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2988EA).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  DateFormat('d MMM yyyy').format(_selectedDate),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportsList() {
    final reports = _filteredReports;

    if (reports.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: reports.asMap().entries.map((entry) {
        final index = entry.key;
        final report = entry.value;
        return _buildReportItem(report, index);
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada laporan untuk filter ini',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _selectedDate = DateTime.now();
              });
            },
            child: Text(
              'Reset Filter',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2988EA),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report, int index) {
    final isExpanded = _expandedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFFAFAFA),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8EAF2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 6,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2988EA).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF2988EA),
                      child: Text(
                        report['title'].toString().substring(0, 1).toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F1F1F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report['subtitle'],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: const Color(0xFFE8EAF2).withOpacity(0.5),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA).withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('Tanggal', report['date']),
                    const SizedBox(height: 12),
                    _buildDetailRow('NIK', report['nik']),
                    const SizedBox(height: 12),
                    _buildDetailRow('Nominal', report['nominal']),
                    const SizedBox(height: 12),
                    _buildDetailRow('Kategori', report['kategori']),
                    const SizedBox(height: 12),
                    _buildDetailRow('Verifikator', report['verifikator']),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F1F1F),
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2988EA),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showPrintModal({bool isPemasukan = true}) {
    // Set jenis laporan yang sesuai berdasarkan tombol yang diklik
    final availableReportTypes = isPemasukan
        ? ['Semua', 'Pemasukan']
        : ['Semua', 'Pengeluaran'];

    // Reset selected type ke 'Semua' saat modal dibuka
    String currentReportType = 'Semua';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EAF2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cetak Laporan',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Check terlebih dahulu sebelum cetak Laporan',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),
              // Tanggal Mulai
              _buildDatePickerField(
                label: 'Tanggal Mulai',
                date: _printStartDate,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _printStartDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF2988EA),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _printStartDate = picked;
                    });
                    setModalState(() {});
                  }
                },
              ),
              const SizedBox(height: 16),
              // Tanggal Akhir
              _buildDatePickerField(
                label: 'Tanggal Akhir',
                date: _printEndDate,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _printEndDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF2988EA),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _printEndDate = picked;
                    });
                    setModalState(() {});
                  }
                },
              ),
              const SizedBox(height: 16),
              // Jenis Laporan Dropdown
              _buildDropdownField(
                label: 'Jenis Laporan',
                value: currentReportType,
                items: availableReportTypes,
                onChanged: (value) {
                  setModalState(() {
                    currentReportType = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Laporan $currentReportType berhasil dibuat. File siap diunduh.',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2988EA),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cetak Laporan',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8EAF2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d MMM yyyy').format(date),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8EAF2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF6B7280),
              ),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF1F1F1F),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModalOption(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8EAF2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF1F1F1F),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF6B7280),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
