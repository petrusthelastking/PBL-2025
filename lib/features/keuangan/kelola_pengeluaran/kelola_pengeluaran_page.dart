// Clean Architecture - Presentation Layer with Firebase Integration
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/pengeluaran_provider.dart';
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

        return Scaffold(
          backgroundColor: const Color(0xFF2988EA),
          body: Column(
            children: [
              PengeluaranHeader(
                totalItems: provider.pengeluaranList.length,
                totalAmount: totalAmount,
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
                                          provider.refresh();
                                        },
                                        child: ListView.builder(
                                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                          itemCount: filteredList.length,
                                          itemBuilder: (context, index) {
                                            final item = filteredList[index];
                                            final isExpanded = _expandedIndex == index;
                                            return PengeluaranCard(
                                              pengeluaran: item,
                                              isExpanded: isExpanded,
                                              onTap: () {
                                                setState(() {
                                                  _expandedIndex = isExpanded ? null : index;
                                                });
                                              },
                                              onEdit: () => _navigateToEditPengeluaran(item),
                                              onDelete: () => _showDeleteConfirmation(item),
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
          floatingActionButton: _buildFAB(),
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
              onPressed: () {
                Provider.of<PengeluaranProvider>(context, listen: false).refresh();
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

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: const Color(0xFF2988EA).withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10), spreadRadius: 2),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: _navigateToTambahPengeluaran,
        backgroundColor: const Color(0xFF2988EA),
        elevation: 0,
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: Text('Tambah', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
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
      Provider.of<PengeluaranProvider>(context, listen: false).refresh();
      _showSuccessSnackBar('Pengeluaran berhasil ditambahkan');
    }
  }

  void _navigateToEditPengeluaran(PengeluaranModel pengeluaran) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPengeluaranPage(pengeluaran: pengeluaran)));
    if (result == true && mounted) {
      Provider.of<PengeluaranProvider>(context, listen: false).refresh();
      _showSuccessSnackBar('Pengeluaran berhasil diperbarui');
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
      SnackBar(content: Text(message, style: GoogleFonts.poppins()), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.poppins()), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
    );
  }
}

