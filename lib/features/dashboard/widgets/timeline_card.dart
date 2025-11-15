// ============================================================================
// TIMELINE CARD WIDGET
// ============================================================================
// Card untuk menampilkan timeline kegiatan (Sudah Lewat, Hari ini, Akan Datang)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'dashboard_constants.dart';
import 'dashboard_reusable_widgets.dart';

/// Timeline card dengan 3 progress bars
class TimelineCard extends StatelessWidget {
  const TimelineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DashboardSectionHeader(
            icon: Icons.schedule,
            title: 'Timeline',
          ),
          const SizedBox(height: 22),
          const TimelineProgressRow(
            label: 'Sudah Lewat',
            value: '10 Kegiatan',
            progress: 1.0,
            highlight: DashboardColors.success,
            icon: Icons.check_circle,
          ),
          const SizedBox(height: DashboardSpacing.lg),
          const TimelineProgressRow(
            label: 'Hari ini',
            value: '10 Kegiatan',
            progress: 0.6,
            highlight: DashboardColors.primaryBlue,
            icon: Icons.today,
          ),
          const SizedBox(height: DashboardSpacing.lg),
          const TimelineProgressRow(
            label: 'Akan Datang',
            value: '10 Kegiatan',
            progress: 0.3,
            highlight: DashboardColors.warning,
            icon: Icons.upcoming,
          ),
        ],
      ),
    );
  }
}

/// Row dengan label, value, dan progress bar
class TimelineProgressRow extends StatelessWidget {
  const TimelineProgressRow({
    super.key,
    required this.label,
    required this.value,
    required this.progress,
    required this.highlight,
    required this.icon,
  });

  final String label;
  final String value;
  final double progress;
  final Color highlight;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: highlight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: highlight,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                AutoSizeText(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: DashboardColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                ),
              ],
            ),
            AutoSizeText(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: DashboardColors.textTertiary,
              ),
              maxLines: 1,
              minFontSize: 11,
            ),
          ],
        ),
        const SizedBox(height: 12),
        DashboardProgressBar(
          progress: progress,
          color: highlight,
        ),
      ],
    );
  }
}

