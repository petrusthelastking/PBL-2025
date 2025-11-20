import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PengeluaranEmptyState extends StatelessWidget {
  const PengeluaranEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2988EA).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: const Color(0xFF2988EA).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Laporan',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada laporan pengeluaran dari RT/RW.\nLaporan akan muncul di sini setelah ditambahkan.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

