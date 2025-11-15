// ============================================================================
// CATEGORY PERFORMANCE CARD - PLACEHOLDER
// ============================================================================
// Card untuk menampilkan performance per kategori dengan gauge chart
// TODO: Implement chart logic jika diperlukan
// ============================================================================

import 'package:flutter/material.dart';

import 'dashboard_reusable_widgets.dart';

/// Card performance kategori (sementara placeholder)
class CategoryPerformanceCard extends StatelessWidget {
  const CategoryPerformanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(26),
      child: Column(
        children: [
          const Text(
            'Kegiatan per Kategori',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          // TODO: Implement gauge chart here
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Chart Performance'),
            ),
          ),
        ],
      ),
    );
  }
}

