// ============================================================================
// ACTIVITY SECTION WIDGET
// ============================================================================
// Section untuk kegiatan (Total Activities & Top Penanggung Jawab)
// ============================================================================

import 'package:flutter/material.dart';

import 'dashboard_constants.dart';
import 'dashboard_reusable_widgets.dart';
import '../activity_detail_page.dart';
import '../penanggung_jawab_detail_page.dart';

/// Section kegiatan dengan list tiles
class ActivitySection extends StatelessWidget {
  const ActivitySection({
    super.key,
    this.totalActivities = '25',
    this.topPenanggungJawab = '25',
  });

  final String totalActivities;
  final String topPenanggungJawab;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DashboardSectionHeader(
          icon: Icons.fact_check_outlined,
          title: 'Kegiatan',
        ),
        const SizedBox(height: 18),
        ActivityListTile(
          title: 'Total Activities',
          value: totalActivities,
          subtitle: 'Lihat total kegiatan dibulan ini',
          onTap: () => _showActivityDetail(context),
        ),
        const SizedBox(height: 14),
        ActivityListTile(
          title: 'Top Penanggung Jawab',
          value: topPenanggungJawab,
          subtitle: 'Check penanggung jawab nya',
          onTap: () => _showPenanggungJawabDetail(context),
        ),
      ],
    );
  }

  void _showActivityDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ActivityDetailPage(),
    );
  }

  void _showPenanggungJawabDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const PenanggungJawabDetailPage(),
    );
  }
}

/// List tile untuk activity
class ActivityListTile extends StatelessWidget {
  const ActivityListTile({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String value;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: _ActivityInfo(
              title: title,
              subtitle: subtitle,
            ),
          ),
          const SizedBox(width: DashboardSpacing.lg),
          DashboardValueBadge(value: value),
        ],
      ),
    );
  }
}

/// Info activity dengan title & subtitle
class _ActivityInfo extends StatelessWidget {
  const _ActivityInfo({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: DashboardColors.textPrimary,
            letterSpacing: -0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: DashboardColors.textTertiary,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

