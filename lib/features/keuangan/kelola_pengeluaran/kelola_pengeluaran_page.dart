// Clean Architecture - Presentation Layer with Firebase Integration
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/pengeluaran_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/pengeluaran_model.dart';
import 'tambah_pengeluaran_page.dart';
import 'edit_pengeluaran_page.dart';
import 'widgets/pengeluaran_header.dart';
import 'widgets/pengeluaran_search_bar.dart';
import 'widgets/pengeluaran_card.dart';
import 'widgets/pengeluaran_empty_state.dart';

class KelolaPengeluaranPage extends StatefulWidget {
  const KelolaPengeluaranPage({super.key});

  @override
  State<KelolaPengeluaranPage> createState() => _KelolaPengeluaranPageState();
}

class _KelolaPengeluaranPageState extends State<KelolaPengeluaranPage> {
  String _searchQuery = '';
  DateTime _selectedDate = DateTime.now();
  int? _expandedIndex;
  String _selectedStatus = 'Semua';

  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PengeluaranProvider>(context, listen: false);
      provider.loadPengeluaran();
      provider.loadTotalTerverifikasi();
      provider.loadSummary();
    });
  }

  List<PengeluaranModel> _getFilteredList(List<PengeluaranModel> list) {
    var filtered = list;
    if (_selectedStatus != 'Semua') {
      filtered = filtered.where((item) => item.status == _selectedStatus).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (item.penerima?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PengeluaranProvider>(
      builder: (context, provider, child) {
        final filteredList = _getFilteredList(provider.pengeluaranList);
        final totalAmount = currencyFormat.format(provider.totalTerverifikasi);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final userRole = authProvider.userModel?.role;
        final pendingCount = provider.pengeluaranList.where((item) => item.status == 'Menunggu').length;

        // 🚨 DEBUG: PRINT INFORMASI PENTING
        debugPrint('═══════════════════════════════════════════');
        debugPrint('🔍 KELOLA PENGELUARAN PAGE - DEBUG INFO');
        debugPrint('═══════════════════════════════════════════');
        debugPrint('👤 Current User Role: $userRole');
        debugPrint('👤 User Name: ${authProvider.userModel?.nama}');
        debugPrint('📊 Total Pengeluaran: ${provider.pengeluaranList.length}');
        debugPrint('⏳ Menunggu Verifikasi: $pendingCount');
        debugPrint('✅ Terverifikasi: ${provider.pengeluaranList.where((item) => item.status == 'Terverifikasi').length}');
        debugPrint('❌ Ditolak: ${provider.pengeluaranList.where((item) => item.status == 'Ditolak').length}');
        debugPrint('═══════════════════════════════════════════');
        debugPrint('🎯 TOMBOL FAB INFO:');
        debugPrint('   - Akan muncul?: ${userRole == 'Admin' || userRole == 'Bendahara'}');
        debugPrint('   - Role adalah Admin?: ${userRole == 'Admin'}');
        debugPrint('   - Role adalah Bendahara?: ${userRole == 'Bendahara'}');
        debugPrint('   - Ada pending?: $pendingCount > 0');
        debugPrint('═══════════════════════════════════════════');

        // Debug: Check user role
        debugPrint('👤 Current User Role: $userRole');
        debugPrint('👤 User Model: ${authProvider.userModel?.nama}');

        return Scaffold(
          backgroundColor: const Color(0xFF2988EA),
          body: Column(
            children: [
              PengeluaranHeader(
                totalItems: provider.pengeluaranList.length,
                totalAmount: totalAmount,
                userRole: userRole,
                showAddButton: userRole == 'Bendahara',
                onAddPressed: userRole == 'Bendahara' ? _navigateToTambahPengeluaran : null,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      PengeluaranSearchBar(
                        onSearchChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onDateTap: _showDatePicker,
                        filteredCount: filteredList.length,
                      ),
                      _buildStatusFilterChips(),
                      Expanded(
                        child: provider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : provider.error != null
                                ? _buildErrorState(provider.error!)
                                : filteredList.isEmpty
                                    ? const PengeluaranEmptyState()
                                    : RefreshIndicator(
                                        onRefresh: () async {
                                          await provider.refresh();
                                        },
                                        child: ListView.builder(
                                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                          itemCount: filteredList.length,
                                          itemBuilder: (context, index) {
                                            final item = filteredList[index];
                                            final isExpanded = _expandedIndex == index;
                                            final isAdmin = userRole == 'Admin';
                                            final isBendahara = userRole == 'Bendahara';
                                            final isPending = item.status == 'Menunggu';
                                            final canVerify = (isAdmin || isBendahara) && isPending;

                                            // Debug: Print role dan status
                                            debugPrint('🔍 Item ${item.name}:');
                                            debugPrint('   Role=$userRole, Admin=$isAdmin, Bendahara=$isBendahara');
                                            debugPrint('   Status=${item.status}, Pending=$isPending');
                                            debugPrint('   CanVerify=$canVerify');

                                            return PengeluaranCard(
                                              pengeluaran: item,
                                              isExpanded: isExpanded,
                                              currentUserRole: userRole,
                                              onTap: () {
                                                setState(() {
                                                  _expandedIndex = isExpanded ? null : index;
                                                });
                                              },
                                              // Hanya Bendahara yang bisa edit/hapus
                                              onEdit: isBendahara ? () => _navigateToEditPengeluaran(item) : null,
                                              onDelete: isBendahara ? () => _showDeleteConfirmation(item) : null,
                                              // PENTING: Admin dan Bendahara HARUS bisa verifikasi/tolak
                                              onVerify: canVerify ? () {
                                                debugPrint('✅ Verifikasi clicked by $userRole');
                                                _showVerifyConfirmation(item, true);
                                              } : null,
                                              onReject: canVerify ? () {
                                                debugPrint('❌ Tolak clicked by $userRole');
                                                _showVerifyConfirmation(item, false);
                                              } : null,
                                            );
                                          },
                                        ),
                                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: _buildFAB(userRole, provider.pengeluaranList),
        );
      },
    );
  }

  Widget _buildStatusFilterChips() {
    final statuses = ['Semua', 'Menunggu', 'Terverifikasi', 'Ditolak'];
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedStatus = status;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: const Color(0xFF2988EA).withValues(alpha: 0.2),
              labelStyle: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF2988EA) : Colors.grey[700],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Terjadi Kesalahan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800])),
            const SizedBox(height: 8),
            Text(
              error.length > 200 ? '${error.substring(0, 200)}...' : error,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await Provider.of<PengeluaranProvider>(context, listen: false).refresh();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2988EA), foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFAB(String? userRole, List<PengeluaranModel> pengeluaranList) {
    // Hitung jumlah pengeluaran yang menunggu verifikasi
    final pendingCount = pengeluaranList.where((item) => item.status == 'Menunggu').length;

    // 🚨 TOMBOL VERIFIKASI MUNCUL UNTUK SEMUA ROLE (Admin, Bendahara, RT, RW, Warga)
    // Selalu tampilkan tombol verifikasi
    if (true) {  // FORCE SHOW - Ganti dengan kondisi role nanti jika perlu
      debugPrint('');
      debugPrint('🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯');
      debugPrint('✅ TOMBOL FAB VERIFIKASI AKAN DITAMPILKAN!');
      debugPrint('📍 Lokasi: KANAN BAWAH (Floating Action Button)');
      debugPrint('🎨 Warna: HIJAU (#10B981)');
      debugPrint('📊 Badge: $pendingCount pengeluaran menunggu');
      debugPrint('👤 User Role: $userRole');
      debugPrint('🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯');
      debugPrint('');

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2988EA).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _showQuickVerifyDialog,
          backgroundColor: const Color(0xFF2988EA),
          elevation: 0,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.task_alt_rounded, color: Colors.white, size: 26),
              if (pendingCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      pendingCount > 99 ? '99+' : '$pendingCount',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          label: Text(
            pendingCount > 0 ? 'Verifikasi ($pendingCount)' : 'Verifikasi',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }

    return null;
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF2988EA))),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      final provider = Provider.of<PengeluaranProvider>(context, listen: false);
      provider.loadByDateRange(DateTime(_selectedDate.year, _selectedDate.month, 1), DateTime(_selectedDate.year, _selectedDate.month + 1, 0));
    }
  }

  void _navigateToTambahPengeluaran() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahPengeluaranPage()));
    if (result == true && mounted) {
      final provider = Provider.of<PengeluaranProvider>(context, listen: false);
      await provider.refresh();
      if (mounted) {
        _showSuccessSnackBar('Pengeluaran berhasil ditambahkan');
      }
    }
  }

  void _navigateToEditPengeluaran(PengeluaranModel pengeluaran) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPengeluaranPage(pengeluaran: pengeluaran)));
    if (result == true && mounted) {
      final provider = Provider.of<PengeluaranProvider>(context, listen: false);
      await provider.refresh();
      if (mounted) {
        _showSuccessSnackBar('Pengeluaran berhasil diperbarui');
      }
    }
  }

  void _showVerifyConfirmation(PengeluaranModel pengeluaran, bool approve) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: approve
                    ? const Color(0xFF10B981).withValues(alpha: 0.1)
                    : const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Icon(
                approve ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: approve ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                approve ? 'Verifikasi Pengeluaran?' : 'Tolak Pengeluaran?',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              approve
                  ? 'Anda akan memverifikasi pengeluaran berikut:'
                  : 'Anda akan menolak pengeluaran berikut:',
              style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pengeluaran.name,
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kategori: ${pengeluaran.category}',
                    style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Nominal: ${currencyFormat.format(pengeluaran.nominal)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2988EA),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (approve)
              Text(
                '💡 Total pengeluaran akan bertambah setelah verifikasi',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF10B981),
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: const Color(0xFF6B7280), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _verifyPengeluaran(pengeluaran.id, approve);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: approve ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              approve ? 'Verifikasi' : 'Tolak',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickVerifyDialog() {
    final provider = Provider.of<PengeluaranProvider>(context, listen: false);
    final pendingList = provider.pengeluaranList.where((item) => item.status == 'Menunggu').toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              // Header dengan handle bar terintegrasi
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2988EA), Color(0xFF1E6FD8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    // Handle bar (sekarang berwarna putih transparan di atas biru)
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Header content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.task_alt_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verifikasi Pengeluaran',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF59E0B).withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.pending_actions, color: Colors.white, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${pendingList.length} Menunggu',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                  ),
                ),
                    ),
                  ],
                ),
              ),
              // List
              Expanded(
                child: pendingList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Tidak Ada Pengeluaran',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Semua pengeluaran sudah diverifikasi',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        itemCount: pendingList.length,
                        itemBuilder: (context, index) {
                          final item = pendingList[index];
                          return _buildQuickVerifyCard(item);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickVerifyCard(PengeluaranModel pengeluaran) {
    Color getCategoryColor(String category) {
      switch (category.toLowerCase()) {
        case 'operasional':
          return const Color(0xFFEB5757);
        case 'infrastruktur':
          return const Color(0xFFF59E0B);
        case 'utilitas':
          return const Color(0xFF3B82F6);
        case 'kegiatan':
          return const Color(0xFF8B5CF6);
        case 'administrasi':
          return const Color(0xFF10B981);
        default:
          return const Color(0xFF6B7280);
      }
    }

    IconData getCategoryIcon(String category) {
      switch (category.toLowerCase()) {
        case 'operasional':
          return Icons.business_center_rounded;
        case 'infrastruktur':
          return Icons.construction_rounded;
        case 'utilitas':
          return Icons.electrical_services_rounded;
        case 'kegiatan':
          return Icons.event_rounded;
        case 'administrasi':
          return Icons.description_rounded;
        default:
          return Icons.attach_money_rounded;
      }
    }

    final categoryColor = getCategoryColor(pengeluaran.category);
    final categoryIcon = getCategoryIcon(pengeluaran.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon kategori
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
                  ),
                  child: Icon(categoryIcon, color: categoryColor, size: 26),
                ),
                const SizedBox(width: 14),
                // Info pengeluaran
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              pengeluaran.category,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: categoryColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd MMM yyyy', 'id_ID').format(pengeluaran.tanggal),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        pengeluaran.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              categoryColor.withValues(alpha: 0.1),
                              categoryColor.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: categoryColor.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.payments_rounded, size: 18, color: categoryColor),
                            const SizedBox(width: 8),
                            Text(
                              currencyFormat.format(pengeluaran.nominal),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: categoryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (pengeluaran.penerima != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Penerima: ${pengeluaran.penerima}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (pengeluaran.deskripsi != null && pengeluaran.deskripsi!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.note_alt_outlined, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  pengeluaran.deskripsi!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xFF6B7280),
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _verifyPengeluaran(pengeluaran.id, true);
                    },
                    icon: const Icon(Icons.check_circle_rounded, size: 20),
                    label: Text(
                      'Verifikasi',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2988EA),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: const Color(0xFF2988EA).withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _verifyPengeluaran(pengeluaran.id, false);
                    },
                    icon: const Icon(Icons.cancel_rounded, size: 20),
                    label: Text(
                      'Tolak',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444), width: 2),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyPengeluaran(String id, bool approve) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: approve
                        ? [const Color(0xFF2988EA).withValues(alpha: 0.2), const Color(0xFF2988EA).withValues(alpha: 0.1)]
                        : [const Color(0xFFEF4444).withValues(alpha: 0.2), const Color(0xFFEF4444).withValues(alpha: 0.1)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  color: approve ? const Color(0xFF2988EA) : const Color(0xFFEF4444),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                approve ? 'Memverifikasi...' : 'Menolak...',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mohon tunggu sebentar',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final provider = Provider.of<PengeluaranProvider>(context, listen: false);
    final success = await provider.verifikasiPengeluaran(id, approve);

    // Close loading dialog
    if (mounted) Navigator.pop(context);

    if (mounted) {
      if (success) {
        _showSuccessSnackBar(
          approve
              ? '✅ Pengeluaran berhasil diverifikasi! Total akan diperbarui.'
              : '❌ Pengeluaran berhasil ditolak'
        );
      } else {
        _showErrorSnackBar('⚠️ Gagal memproses verifikasi. Silakan coba lagi.');
      }
    }
  }

  void _showDeleteConfirmation(PengeluaranModel pengeluaran) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.warning_rounded, color: Color(0xFFF59E0B), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Hapus Data?', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18))),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${pengeluaran.name}"? Data yang sudah dihapus tidak dapat dikembalikan.',
          style: GoogleFonts.poppins(fontSize: 14, height: 1.5, color: const Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.poppins(color: const Color(0xFF6B7280), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deletePengeluaran(pengeluaran.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Hapus', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePengeluaran(String id) async {
    final provider = Provider.of<PengeluaranProvider>(context, listen: false);
    final success = await provider.deletePengeluaran(id);
    if (mounted) {
      if (success) {
        _showSuccessSnackBar('Laporan berhasil dihapus');
      } else {
        _showErrorSnackBar('Gagal menghapus laporan');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2988EA),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

