// ============================================================================
// FINANCE OVERVIEW WIDGET
// ============================================================================
// Section untuk overview keuangan (Kas Masuk, Kas Keluar, Total Transaksi)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'dashboard_constants.dart';
import 'dashboard_reusable_widgets.dart';

/// Model data untuk finance card
class FinanceData {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const FinanceData({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.onTap,
  });
}

/// Overview keuangan dengan 3 cards
class FinanceOverview extends StatelessWidget {
  const FinanceOverview({
    super.key,
    this.kasMasuk = '500JT',
    this.kasKeluar = '50JT',
    this.totalTransaksi = '100',
    this.onKasMasukTap,
    this.onKasKeluarTap,
    this.onTotalTransaksiTap,
  });

  final String kasMasuk;
  final String kasKeluar;
  final String totalTransaksi;
  final VoidCallback? onKasMasukTap;
  final VoidCallback? onKasKeluarTap;
  final VoidCallback? onTotalTransaksiTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: FinanceSmallCard(
                title: 'Kas Masuk',
                value: kasMasuk,
                icon: Icons.account_balance_wallet_outlined,
                backgroundColor: DashboardColors.financeKasMasuk,
                onTap: onKasMasukTap,
              ),
            ),
            const SizedBox(width: DashboardSpacing.lg),
            Expanded(
              child: FinanceSmallCard(
                title: 'Kas Keluar',
                value: kasKeluar,
                icon: Icons.account_balance_wallet_outlined,
                backgroundColor: DashboardColors.financeKasKeluar,
                onTap: onKasKeluarTap,
              ),
            ),
          ],
        ),
        const SizedBox(width: DashboardSpacing.lg),
        FinanceWideCard(
          title: 'Total Transaksi',
          subtitle: 'Lihat catatan transaksi keseluruhan',
          value: totalTransaksi,
          icon: Icons.receipt_long_outlined,
          onTap: onTotalTransaksiTap,
        ),
      ],
    );
  }
}

/// Card kecil untuk Kas Masuk & Kas Keluar
class FinanceSmallCard extends StatelessWidget {
  const FinanceSmallCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DashboardRadius.xxxl),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor,
              backgroundColor.withValues(alpha: 0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(DashboardRadius.xxxl),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconBox(icon: icon),
            const SizedBox(height: DashboardSpacing.xl),
            AutoSizeText(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: DashboardColors.textSecondary,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              minFontSize: 10,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: DashboardSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AutoSizeText(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: DashboardColors.textPrimary,
                      letterSpacing: -1,
                    ),
                    maxLines: 1,
                    minFontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _ArrowButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Card lebar untuk Total Transaksi
class FinanceWideCard extends StatelessWidget {
  const FinanceWideCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DashboardRadius.xxxl),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DashboardColors.financeKasMasuk,
              DashboardColors.financeTotal,
            ],
          ),
          borderRadius: BorderRadius.circular(DashboardRadius.xxxl),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: DashboardShadow.cardLarge(),
        ),
        child: Row(
          children: [
            DashboardIconContainer(
              icon: icon,
              size: 68,
              iconSize: DashboardIconSize.xxl,
            ),
            const SizedBox(width: DashboardSpacing.xl),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: DashboardColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  AutoSizeText(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: DashboardColors.textLight,
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
            const SizedBox(width: DashboardSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                gradient: DashboardColors.primaryGradient,
                borderRadius: BorderRadius.circular(DashboardRadius.xxl),
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon box putih dengan shadow
class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(DashboardRadius.lg),
        boxShadow: [
          BoxShadow(
            color: DashboardColors.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: DashboardColors.primaryBlue,
        size: DashboardIconSize.xl,
      ),
    );
  }
}

/// Arrow button kecil
class _ArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(DashboardRadius.md),
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
        size: DashboardIconSize.sm,
      ),
    );
  }
}

