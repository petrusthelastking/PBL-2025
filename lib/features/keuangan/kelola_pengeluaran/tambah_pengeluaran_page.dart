// Clean Architecture - Tambah Pengeluaran dengan Firebase Integration
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/providers/pengeluaran_provider.dart';
import '../../../core/models/pengeluaran_model.dart';
import 'widgets/tambah_pengeluaran_header.dart';

class TambahPengeluaranPage extends StatefulWidget {
  const TambahPengeluaranPage({super.key});

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaPengeluaranController = TextEditingController();
  final _nominalController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _penerimaController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedKategori;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _kategoriList = [
    {'value': 'Operasional', 'label': 'Operasional', 'icon': Icons.business_center_rounded, 'color': const Color(0xFFEB5757)},
    {'value': 'Infrastruktur', 'label': 'Infrastruktur', 'icon': Icons.construction_rounded, 'color': const Color(0xFFF59E0B)},
    {'value': 'Utilitas', 'label': 'Utilitas', 'icon': Icons.electrical_services_rounded, 'color': const Color(0xFF3B82F6)},
    {'value': 'Kegiatan', 'label': 'Kegiatan', 'icon': Icons.event_rounded, 'color': const Color(0xFF8B5CF6)},
    {'value': 'Administrasi', 'label': 'Administrasi', 'icon': Icons.description_rounded, 'color': const Color(0xFF10B981)},
    {'value': 'Lainnya', 'label': 'Lainnya', 'icon': Icons.more_horiz_rounded, 'color': const Color(0xFF6B7280)},
  ];

  @override
  void dispose() {
    _namaPengeluaranController.dispose();
    _nominalController.dispose();
    _deskripsiController.dispose();
    _penerimaController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF2988EA), onPrimary: Colors.white, onSurface: Color(0xFF1F2937))),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedKategori == null) {
      _showErrorSnackBar('Pilih kategori pengeluaran');
      return;
    }
    if (_selectedDate == null) {
      _showErrorSnackBar('Pilih tanggal pengeluaran');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final pengeluaran = PengeluaranModel(
        id: '',
        name: _namaPengeluaranController.text.trim(),
        category: _selectedKategori!,
        nominal: double.parse(_nominalController.text.replaceAll('.', '')),
        deskripsi: _deskripsiController.text.trim().isEmpty ? null : _deskripsiController.text.trim(),
        tanggal: _selectedDate!,
        status: 'Menunggu',
        penerima: _penerimaController.text.trim().isEmpty ? null : _penerimaController.text.trim(),
        createdBy: currentUser?.email ?? 'unknown',
      );

      final provider = Provider.of<PengeluaranProvider>(context, listen: false);
      final success = await provider.createPengeluaran(pengeluaran);

      if (mounted) {
        if (success) {
          Navigator.pop(context, true);
        } else {
          _showErrorSnackBar('Gagal menambahkan pengeluaran');
        }
      }
    } catch (e) {
      if (mounted) _showErrorSnackBar('Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2988EA),
      body: Column(
        children: [
          const TambahPengeluaranHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _buildTextField(
                      controller: _namaPengeluaranController,
                      label: 'Nama Pengeluaran',
                      hint: 'Contoh: Pembelian Alat Kebersihan',
                      icon: Icons.text_fields_rounded,
                      validator: (value) => value == null || value.isEmpty ? 'Nama pengeluaran harus diisi' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildKategoriDropdown(),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _nominalController,
                      label: 'Nominal',
                      hint: 'Contoh: 500000',
                      icon: Icons.payments_rounded,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, _ThousandsSeparatorInputFormatter()],
                      validator: (value) => value == null || value.isEmpty ? 'Nominal harus diisi' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildDatePicker(),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _penerimaController,
                      label: 'Penerima (Opsional)',
                      hint: 'Contoh: Toko Makmur Jaya',
                      icon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _deskripsiController,
                      label: 'Deskripsi (Opsional)',
                      hint: 'Jelaskan detail pengeluaran...',
                      icon: Icons.description_rounded,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1F2937))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF6B7280)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2988EA), width: 2)),
            filled: true,
            fillColor: Colors.white,
          ),
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildKategoriDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kategori', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1F2937))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedKategori,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.category_rounded, color: Color(0xFF6B7280)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2988EA), width: 2)),
            filled: true,
            fillColor: Colors.white,
          ),
          hint: Text('Pilih kategori', style: GoogleFonts.poppins(color: const Color(0xFF9CA3AF))),
          items: _kategoriList.map<DropdownMenuItem<String>>((kategori) {
            return DropdownMenuItem<String>(
              value: kategori['value'] as String,
              child: Row(
                children: [
                  Icon(kategori['icon'] as IconData, size: 20, color: kategori['color'] as Color),
                  const SizedBox(width: 12),
                  Text(kategori['label'] as String, style: GoogleFonts.poppins(fontSize: 14)),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedKategori = value),
          validator: (value) => value == null ? 'Pilih kategori' : null,
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tanggal', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1F2937))),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: Color(0xFF6B7280)),
                const SizedBox(width: 12),
                Text(
                  _selectedDate != null ? DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!) : 'Pilih tanggal',
                  style: GoogleFonts.poppins(fontSize: 14, color: _selectedDate != null ? const Color(0xFF1F2937) : const Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2988EA),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: _isLoading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
          : Text('Simpan Laporan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.poppins()), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating),
    );
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');
    final number = int.tryParse(newValue.text.replaceAll('.', ''));
    if (number == null) return oldValue;
    final formatter = NumberFormat('#,###', 'id_ID');
    final newText = formatter.format(number).replaceAll(',', '.');
    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}

