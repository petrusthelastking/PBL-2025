import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edit_data_mutasi_page.dart';

class DetailDataMutasiPage extends StatelessWidget {
  final Map<String, dynamic>? mutasiData;
  
  const DetailDataMutasiPage({super.key, this.mutasiData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Data Mutasi",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditDataMutasiPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailField("Nama Lengkap", mutasiData?['nama'] ?? "Rendha Putra Rahmadya"),
            _buildDetailField("NIK", mutasiData?['nik'] ?? "3505111512040002"),
            _buildDetailField("Jenis Mutasi", mutasiData?['jenis'] ?? "Mutasi Masuk"),
            _buildDetailField("Tanggal Mutasi", mutasiData?['tanggal'] ?? "21/10/2023"),
            _buildDetailField("Alamat Asal", mutasiData?['alamatAsal'] ?? "Jakarta"),
            _buildDetailField("Alamat Tujuan", mutasiData?['alamatTujuan'] ?? "Surabaya"),
            _buildDetailField("Alasan Mutasi", mutasiData?['alasan'] ?? "Pindah Kerja"),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
            ),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
