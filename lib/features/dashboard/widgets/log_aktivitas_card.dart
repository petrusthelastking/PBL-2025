// ============================================================================
// LOG AKTIVITAS CARD
// ============================================================================
// Card untuk menampilkan log aktivitas terbaru
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_constants.dart';
import 'dashboard_reusable_widgets.dart';
import '../log_aktivitas_page.dart';

/// Card log aktivitas terbaru
class LogAktivitasCard extends StatelessWidget {
  const LogAktivitasCard({super.key});

  // Mock data - nanti bisa diambil dari service
  static final List<ActivityLog> _activities = [
    ActivityLog(
      description: 'Menambah data warga baru',
      actor: 'Admin Diana',
      time: '2 jam yang lalu',
      icon: Icons.person_add_rounded,
      color: DashboardColors.success,
    ),
    ActivityLog(
      description: 'Menambah pemasukan Rp 500.000',
      actor: 'Admin Diana',
      time: '3 jam yang lalu',
      icon: Icons.add_card_rounded,
      color: DashboardColors.primaryBlue,
    ),
    ActivityLog(
      description: 'Mengedit metode pembayaran',
      actor: 'Admin Diana',
      time: '5 jam yang lalu',
      icon: Icons.edit_rounded,
      color: DashboardColors.warning,
    ),
    ActivityLog(
      description: 'Membuat kegiatan baru',
      actor: 'Admin Diana',
      time: '1 hari yang lalu',
      icon: Icons.event_rounded,
      color: Color(0xFF7C6FFF),
    ),
    ActivityLog(
      description: 'Menghapus data warga',
      actor: 'Admin Diana',
      time: '2 hari yang lalu',
      icon: Icons.delete_rounded,
      color: DashboardColors.error,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardSectionHeader(
            icon: Icons.history_rounded,
            title: 'Log Aktivitas Terbaru',
          ),
          const SizedBox(height: DashboardSpacing.xl),

          // List aktivitas
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _activities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final activity = _activities[index];
              return ActivityItem(activity: activity);
            },
          ),

          const SizedBox(height: DashboardSpacing.lg),

          // Button lihat semua
          _ViewAllButton(),
        ],
      ),
    );
  }
}

/// Model untuk activity log
class ActivityLog {
  final String description;
  final String actor;
  final String time;
  final IconData icon;
  final Color color;

  const ActivityLog({
    required this.description,
    required this.actor,
    required this.time,
    required this.icon,
    required this.color,
  });
}

/// Item activity dalam list
class ActivityItem extends StatelessWidget {
  const ActivityItem({
    super.key,
    required this.activity,
  });

  final ActivityLog activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DashboardColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              activity.icon,
              color: activity.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: DashboardColors.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activity.actor,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: Color(0xFF9CA3AF))),
                    const SizedBox(width: 8),
                    Text(
                      activity.time,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Button untuk lihat semua log
class _ViewAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LogAktivitasPage(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF7C6FFF).withValues(alpha: 0.1),
              const Color(0xFF9D8FFF).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF7C6FFF).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lihat Semua Log Aktivitas',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF7C6FFF),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFF7C6FFF),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

