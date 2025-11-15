// ============================================================================
// DASHBOARD PAGE (CLEAN CODE VERSION)
// ============================================================================
// Main dashboard page - fokus pada layout & orchestration
// Widget-widget sudah dipecah untuk maintainability
//
// Clean Code Principles Applied:
// ✅ Fokus pada tampilan & interaksi user (tanpa logic bisnis berat)
// ✅ Gunakan StatelessWidget kalau tidak perlu state
// ✅ Pecah jadi widget kecil (setiap widget < 200 baris)
// ✅ Tidak ada duplikasi kode - gunakan widget reusable
// ✅ Nama variabel & widget yang jelas dan deskriptif
// ✅ Responsif dengan padding yang rapi
// ✅ Tidak panggil API langsung - nanti pakai controller/service
// ============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../core/widgets/app_bottom_navigation.dart';
import 'dashboard_detail_page.dart';
import 'activity_detail_page.dart';
import 'penanggung_jawab_detail_page.dart';
import 'notification_popup.dart';
import 'log_aktivitas_page.dart';
import 'widgets/dashboard_colors.dart';
import 'widgets/dashboard_styles.dart';

/// Dashboard Page - Halaman utama aplikasi
///
/// Menampilkan:
/// - Header dengan profil dan notifikasi
/// - Finance Overview (Kas Masuk, Kas Keluar, Total Transaksi)
/// - Kegiatan (Total Activities, Top Penanggung Jawab)
/// - Timeline (Sudah Lewat, Hari ini, Akan Datang)
/// - Category Performance (Chart per kategori)
/// - Monthly Activity (Bar chart bulanan)
/// - Log Aktivitas (5 aktivitas terakhir)
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header section dengan gradient background
            _buildHeader(),

            // Content sections
            SliverPadding(
              padding: DashboardStyles.contentPadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const _ActivitySection(),
                  const SizedBox(height: 20),
                  const _TimelineCard(),
                  const SizedBox(height: 20),
                  const _CategoryPerformanceCard(),
                  const SizedBox(height: 20),
                  const _MonthlyActivityCard(),
                  const SizedBox(height: 20),
                  const _LogAktivitasCard(),
                  const SizedBox(height: 24),
                  const _PrimaryActionButton(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(
        currentIndex: 0,
      ),
    );
  }

  /// Build header section dengan gradient background
  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: DashboardColors.primaryGradient,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: DashboardColors.primaryBlue.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DashboardHeader(),
              SizedBox(height: 32),
              _FinanceOverview(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DASHBOARD HEADER WIDGET
// ============================================================================
// Menampilkan header dashboard dengan:
// - Avatar user
// - Welcome message & nama admin
// - Icon search & notification
// ============================================================================

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        const SizedBox(width: 16),
        _buildWelcomeText(),
        _buildSearchIcon(context),
        const SizedBox(width: 12),
        _buildNotificationIcon(context),
      ],
    );
  }

  /// Build avatar dengan border dan shadow
  Widget _buildAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: const AssetImage('assets/illustrations/LOGIN.png'),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

  /// Build welcome text dengan nama admin
  Widget _buildWelcomeText() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Selamat Datang 👋',
            style: DashboardStyles.headerSubtitle,
            maxLines: 1,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          AutoSizeText(
            'Admin Diana',
            style: DashboardStyles.headerTitle,
            maxLines: 1,
            minFontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Build search icon button
  Widget _buildSearchIcon(BuildContext context) {
    return _HeaderIcon(
      icon: Icons.search,
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      iconColor: Colors.white,
    );
  }

  /// Build notification icon button dengan badge
  Widget _buildNotificationIcon(BuildContext context) {
    return GestureDetector(
      onTap: () => _showNotificationPopup(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _HeaderIcon(
            icon: Icons.notifications_outlined,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            iconColor: Colors.white,
          ),
          const Positioned(
            right: 2,
            top: 2,
            child: _NotificationDot(),
          ),
        ],
      ),
    );
  }

  /// Show notification popup dialog
  void _showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: 80,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: const NotificationPopup(),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// HEADER ICON WIDGET
// ============================================================================
// Reusable icon button untuk header
// ============================================================================

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: DashboardStyles.smallCardRadius,
        border: Border.all(
          color: _getBorderColor(),
          width: 1.5,
        ),
        boxShadow: DashboardStyles.iconShadow(_getShadowColor()),
      ),
      child: Icon(
        icon,
        color: iconColor ?? DashboardColors.primaryBlue,
        size: 22,
      ),
    );
  }

  Color _getBorderColor() {
    return backgroundColor != null
        ? Colors.white.withValues(alpha: 0.3)
        : DashboardColors.border;
  }

  Color _getShadowColor() {
    return backgroundColor != null
        ? Colors.black
        : DashboardColors.primaryBlue;
  }
}

// ============================================================================
// NOTIFICATION DOT WIDGET
// ============================================================================
// Badge indicator untuk notifikasi baru
// ============================================================================

class _NotificationDot extends StatelessWidget {
  const _NotificationDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: DashboardColors.error,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }
}

// ============================================================================
// FINANCE OVERVIEW WIDGET
// ============================================================================
// Menampilkan overview keuangan:
// - Card Kas Masuk & Kas Keluar (row)
// - Card Total Transaksi (full width)
// ============================================================================

class _FinanceOverview extends StatelessWidget {
  const _FinanceOverview();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row untuk Kas Masuk & Kas Keluar
        Row(
          children: [
            Expanded(
              child: _FinanceCard(
                title: 'Kas Masuk',
                value: '500JT',
                icon: Icons.account_balance_wallet_outlined,
                backgroundColor: DashboardColors.incomeBackground,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _FinanceCard(
                title: 'Kas Keluar',
                value: '50JT',
                icon: Icons.account_balance_wallet_outlined,
                backgroundColor: DashboardColors.outcomeBackground,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        // Card Total Transaksi (full width)
        _FinanceWideCard(
          title: 'Total Transaksi',
          subtitle: 'Lihat catatan transaksi keseluruhan',
          value: '100',
          icon: Icons.receipt_long_outlined,
        ),
      ],
    );
  }
}

// ============================================================================
// FINANCE CARD WIDGET
// ============================================================================
// Card untuk menampilkan informasi keuangan (Kas Masuk/Keluar)
// ============================================================================

class _FinanceCard extends StatelessWidget {
  const _FinanceCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _buildDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconContainer(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 12),
          _buildValueRow(),
        ],
      ),
    );
  }

  /// Build decoration untuk card
  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          backgroundColor,
          backgroundColor.withValues(alpha: 0.6),
        ],
      ),
      borderRadius: DashboardStyles.cardRadius,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.4),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: backgroundColor.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  /// Build icon container dengan shadow
  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: DashboardStyles.smallCardRadius,
        boxShadow: DashboardStyles.iconShadow(DashboardColors.primaryBlue),
      ),
      child: Icon(
        icon,
        color: DashboardColors.primaryBlue,
        size: 26,
      ),
    );
  }

  /// Build title text
  Widget _buildTitle() {
    return AutoSizeText(
      title,
      style: DashboardStyles.cardLabel.copyWith(
        color: DashboardColors.textSecondary,
      ),
      maxLines: 1,
      minFontSize: 10,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Build value dan arrow button row
  Widget _buildValueRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: AutoSizeText(
            value,
            style: DashboardStyles.cardValue.copyWith(
              color: DashboardColors.textPrimary,
            ),
            maxLines: 1,
            minFontSize: 20,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildArrowButton(),
      ],
    );
  }

  /// Build arrow button
  Widget _buildArrowButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: DashboardColors.primaryBlue.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.arrow_forward_rounded,
        color: DashboardColors.primaryBlue,
        size: 20,
      ),
    );
  }
}

// ============================================================================
// FINANCE WIDE CARD WIDGET
// ============================================================================
// Card full-width untuk Total Transaksi
// ============================================================================

class _FinanceWideCard extends StatelessWidget {
  const _FinanceWideCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: DashboardStyles.cardPadding,
      decoration: _buildDecoration(),
      child: Row(
        children: [
          _buildIconContainer(),
          const SizedBox(width: 20),
          _buildTextContent(),
          const SizedBox(width: 12),
          _buildValueBadge(),
        ],
      ),
    );
  }

  /// Build card decoration
  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          DashboardColors.incomeBackground,
          Color(0xFFE8F0FF),
        ],
      ),
      borderRadius: DashboardStyles.cardRadius,
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.6),
        width: 2,
      ),
      boxShadow: [
        BoxShadow(
          color: DashboardColors.primaryBlue.withValues(alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Build icon container dengan gradient
  Widget _buildIconContainer() {
    return Container(
      height: 68,
      width: 68,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: DashboardColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: DashboardColors.primaryBlue.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  /// Build text content (title & subtitle)
  Widget _buildTextContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            title,
            style: DashboardStyles.cardTitle.copyWith(
              fontSize: 18,
              color: DashboardColors.textPrimary,
            ),
            maxLines: 1,
            minFontSize: 14,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          AutoSizeText(
            subtitle,
            style: DashboardStyles.cardSubtitle.copyWith(
              color: DashboardColors.textLight,
            ),
            maxLines: 2,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Build value badge dengan gradient
  Widget _buildValueBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: DashboardColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: DashboardColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AutoSizeText(
        value,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        maxLines: 1,
        minFontSize: 16,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ActivitySection extends StatelessWidget {
  const _ActivitySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2F80ED),
                    Color(0xFF1E6FD9),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2F80ED).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.fact_check_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            AutoSizeText(
              'Kegiatan',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F1F1F),
                letterSpacing: -0.5,
              ),
              maxLines: 1,
              minFontSize: 16,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _ActivityListTile(
          title: 'Total Activities',
          value: '25',
          subtitle: 'Lihat total kegiatan dibulan ini',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const ActivityDetailPage(),
            );
          },
        ),
        const SizedBox(height: 14),
        _ActivityListTile(
          title: 'Top Penanggung Jawab',
          value: '25',
          subtitle: 'Check penanggung jawab nya',
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => const PenanggungJawabDetailPage(),
            );
          },
        ),
      ],
    );
  }
}

class _ActivityListTile extends StatelessWidget {
  const _ActivityListTile({
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
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE8EAF2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2F80ED).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F1F1F),
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  AutoSizeText(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF7A7C89),
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    minFontSize: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFDDEAFF),
                    Color(0xFFE8F0FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2F80ED).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutoSizeText(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2F80ED),
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    minFontSize: 18,
                  ),
                  const SizedBox(height: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF2F80ED),
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFE8EAF2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2F80ED),
                      Color(0xFF1E6FD9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2F80ED).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.schedule,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              AutoSizeText(
                'Timeline',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1F1F),
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                minFontSize: 16,
              ),
            ],
          ),
          const SizedBox(height: 22),
          const _TimelineProgressRow(
            label: 'Sudah Lewat',
            value: '10 Kegiatan',
            progress: 1.0,
            highlight: Color(0xFF10B981),
            icon: Icons.check_circle,
          ),
          const SizedBox(height: 16),
          const _TimelineProgressRow(
            label: 'Hari ini',
            value: '10 Kegiatan',
            progress: 0.6,
            highlight: Color(0xFF2F80ED),
            icon: Icons.today,
          ),
          const SizedBox(height: 16),
          const _TimelineProgressRow(
            label: 'Akan Datang',
            value: '10 Kegiatan',
            progress: 0.3,
            highlight: Color(0xFFFFA755),
            icon: Icons.upcoming,
          ),
        ],
      ),
    );
  }
}

class _TimelineProgressRow extends StatelessWidget {
  const _TimelineProgressRow({
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
                    color: const Color(0xFF1F1F1F),
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
                color: const Color(0xFF7A7C89),
              ),
              maxLines: 1,
              minFontSize: 11,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0, 1),
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      highlight,
                      highlight.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: highlight.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoryPerformanceCard extends StatelessWidget {
  const _CategoryPerformanceCard();

  static const double _completion = 0.46;
  static const int _completionPercent = 46;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFFAFBFF),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8EAF2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C6FFF), Color(0xFF9D8FFF)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.pie_chart,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'Kegiatan per Kategori',
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F1F1F),
                          letterSpacing: -0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E3EE), width: 1.5),
                  color: const Color(0xFFFAFBFF),
                ),
                child: Row(
                  children: [
                    Text(
                      'Komunitas',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF2F80ED),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Color(0xFF2F80ED),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 260,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: CustomPaint(
                      size: const Size(260, 140),
                      painter: _CategoryGaugePainter(progress: _completion),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF9CA3AF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '%$_completionPercent',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1F1F1F),
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "You've completed 46% of your planned sales goal.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13.5,
                color: const Color(0xFF7A7C89),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGaugePainter extends CustomPainter {
  const _CategoryGaugePainter({required this.progress});

  final double progress;

  static const double _strokeWidth = 18.0;
  static const Color _baseColor = Color(0xFFE8EBF4);
  static const List<Color> _gradientColors = [
    Color(0xFF7C6FFF),
    Color(0xFF9D8FFF),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double cappedProgress = progress.clamp(0.0, 1.0);
    final double radius = (size.width - _strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height - 10);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint basePaint = Paint()
      ..color = _baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    const double startAngle = math.pi;
    const double sweepAngle = math.pi;

    canvas.drawArc(rect, startAngle, sweepAngle, false, basePaint);

    if (cappedProgress <= 0) {
      return;
    }

    final SweepGradient gradient = SweepGradient(
      startAngle: math.pi,
      endAngle: math.pi * 2,
      colors: _gradientColors,
      tileMode: TileMode.clamp,
    );

    final Paint progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * cappedProgress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CategoryGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _MonthlyActivityCard extends StatelessWidget {
  const _MonthlyActivityCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8EAF2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA755), Color(0xFFFF8C42)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Kegiatan per Bulan (Tahun Ini)',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1F1F1F),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Rekapan kegiatan per bulan untuk di tahun ini dengan data yang real',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF9CA3AF),
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          // Y-axis labels and chart
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-axis labels
                SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _YAxisLabel('100'),
                      _YAxisLabel('80'),
                      _YAxisLabel('60'),
                      _YAxisLabel('40'),
                      _YAxisLabel('20'),
                      _YAxisLabel('0'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Chart bars
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        // Grid lines
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              6,
                              (index) => Container(
                                height: 1,
                                color: const Color(0xFFF3F4F6),
                              ),
                            ),
                          ),
                        ),
                        // Bars
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ChartBar(height: 0, maxHeight: 200),
                              const SizedBox(width: 12),
                              _ChartBar(height: 0, maxHeight: 200),
                              const SizedBox(width: 12),
                              _ChartBar(height: 100, maxHeight: 200),
                              const SizedBox(width: 12),
                              _ChartBar(height: 0, maxHeight: 200),
                              const SizedBox(width: 12),
                              _ChartBar(height: 0, maxHeight: 200),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '12.07 - 25.07',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA755), Color(0xFFFF8C42)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Kegiatan',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _YAxisLabel extends StatelessWidget {
  const _YAxisLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 11,
        color: const Color(0xFF9CA3AF),
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({required this.height, required this.maxHeight});

  final double height;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: height > 0 ? height : 0,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFA755),
            Color(0xFFFF8C42),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA755).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class _LogAktivitasCard extends StatelessWidget {
  const _LogAktivitasCard();

  // Mock data untuk 5 aktivitas terakhir
  static final List<Map<String, dynamic>> _recentActivities = [
    {
      'deskripsi': 'Menambah data warga baru',
      'aktor': 'Admin Diana',
      'waktu': '2 jam yang lalu',
      'icon': Icons.person_add_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'deskripsi': 'Menambah pemasukan Rp 500.000',
      'aktor': 'Admin Diana',
      'waktu': '3 jam yang lalu',
      'icon': Icons.add_card_rounded,
      'color': Color(0xFF2F80ED),
    },
    {
      'deskripsi': 'Mengedit metode pembayaran',
      'aktor': 'Admin Diana',
      'waktu': '5 jam yang lalu',
      'icon': Icons.edit_rounded,
      'color': Color(0xFFFFA755),
    },
    {
      'deskripsi': 'Membuat kegiatan baru',
      'aktor': 'Admin Diana',
      'waktu': '1 hari yang lalu',
      'icon': Icons.event_rounded,
      'color': Color(0xFF7C6FFF),
    },
    {
      'deskripsi': 'Menghapus data warga',
      'aktor': 'Admin Diana',
      'waktu': '2 hari yang lalu',
      'icon': Icons.delete_rounded,
      'color': Color(0xFFEB5757),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE8EAF2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7C6FFF),
                      Color(0xFF9D8FFF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C6FFF).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Log Aktivitas Terbaru',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1F1F),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Activities List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentActivities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final activity = _recentActivities[index];
              return _ActivityItem(
                deskripsi: activity['deskripsi'],
                aktor: activity['aktor'],
                waktu: activity['waktu'],
                icon: activity['icon'],
                color: activity['color'],
              );
            },
          ),

          const SizedBox(height: 16),

          // Lihat Semua Button
          InkWell(
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
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({
    required this.deskripsi,
    required this.aktor,
    required this.waktu,
    required this.icon,
    required this.color,
  });

  final String deskripsi;
  final String aktor;
  final String waktu;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8EAF2),
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
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
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
                  deskripsi,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F1F1F),
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 12,
                      color: const Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      aktor,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      waktu,
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

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF2F80ED),
            Color(0xFF1E6FD9),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardDetailPage(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.dashboard_customize_rounded,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Selengkapnya',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
