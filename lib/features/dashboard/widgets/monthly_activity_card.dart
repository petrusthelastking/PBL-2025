// ============================================================================
// MONTHLY ACTIVITY CARD - PLACEHOLDER
// ============================================================================
// Card untuk menampilkan aktivitas per bulan dengan bar chart
// TODO: Implement chart logic jika diperlukan
// ============================================================================

import 'package:flutter/material.dart';

import 'dashboard_reusable_widgets.dart';

/// Card aktivitas bulanan (sementara placeholder)
class MonthlyActivityCard extends StatelessWidget {
  const MonthlyActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kegiatan per Bulan (Tahun Ini)',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Rekapan kegiatan per bulan untuk di tahun ini',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          // TODO: Implement bar chart here
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Bar Chart'),
            ),
          ),
        ],
      ),
    );
  }
}

