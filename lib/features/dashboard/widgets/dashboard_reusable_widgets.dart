// ============================================================================
// REUSABLE WIDGETS - DASHBOARD
// ============================================================================
// Widget-widget kecil yang reusable untuk dashboard
// Menghindari duplikasi kode
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_constants.dart';

/// Icon button dengan background & shadow untuk header
class DashboardIconButton extends StatelessWidget {
  const DashboardIconButton({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: backgroundColor ?? DashboardColors.cardBackground,
        borderRadius: BorderRadius.circular(DashboardRadius.lg),
        border: Border.all(
          color: backgroundColor != null
              ? Colors.white.withValues(alpha: 0.3)
              : DashboardColors.border,
          width: 1.5,
        ),
        boxShadow: DashboardShadow.icon(backgroundColor),
      ),
      child: Icon(
        icon,
        color: iconColor ?? DashboardColors.primaryBlue,
        size: DashboardIconSize.md,
      ),
    );

    if (onTap == null) return widget;

    return GestureDetector(
      onTap: onTap,
      child: showBadge
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                widget,
                const Positioned(
                  right: 2,
                  top: 2,
                  child: _BadgeDot(),
                ),
              ],
            )
          : widget,
    );
  }
}

/// Badge dot merah untuk notifikasi
class _BadgeDot extends StatelessWidget {
  const _BadgeDot();

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

/// Section header dengan icon & title
class DashboardSectionHeader extends StatelessWidget {
  const DashboardSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    this.action,
  });

  final IconData icon;
  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            gradient: DashboardColors.primaryGradient,
            borderRadius: BorderRadius.circular(DashboardRadius.lg),
            boxShadow: [
              BoxShadow(
                color: DashboardColors.primaryBlue.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: DashboardIconSize.lg,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: DashboardColors.textPrimary,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

/// Card wrapper dengan styling konsisten
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      padding: padding ?? const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? DashboardColors.cardBackground : null,
        borderRadius: BorderRadius.circular(DashboardRadius.card),
        border: Border.all(
          color: DashboardColors.border,
          width: 1.5,
        ),
        boxShadow: DashboardShadow.card(),
      ),
      child: child,
    );

    if (onTap == null) return container;

    return InkWell(
      borderRadius: BorderRadius.circular(DashboardRadius.card),
      onTap: onTap,
      child: container,
    );
  }
}

/// Icon container dengan background gradient
class DashboardIconContainer extends StatelessWidget {
  const DashboardIconContainer({
    super.key,
    required this.icon,
    this.size = 48,
    this.iconSize,
    this.gradient,
    this.backgroundColor,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final double size;
  final double? iconSize;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        gradient: gradient ?? DashboardColors.primaryGradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: (gradient != null || backgroundColor == null
                    ? DashboardColors.primaryBlue
                    : backgroundColor!)
                .withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize ?? size * 0.5,
      ),
    );
  }
}

/// Value badge untuk menampilkan angka dengan style konsisten
class DashboardValueBadge extends StatelessWidget {
  const DashboardValueBadge({
    super.key,
    required this.value,
    this.showArrow = true,
    this.gradient,
    this.textColor,
  });

  final String value;
  final bool showArrow;
  final Gradient? gradient;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: gradient ??
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFDDEAFF),
                Color(0xFFE8F0FF),
              ],
            ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: DashboardShadow.icon(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: textColor ?? DashboardColors.primaryBlue,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (showArrow) ...[
            const SizedBox(height: 6),
            Icon(
              Icons.arrow_forward_rounded,
              color: textColor ?? DashboardColors.primaryBlue,
              size: DashboardIconSize.sm,
            ),
          ],
        ],
      ),
    );
  }
}

/// Progress bar dengan label
class DashboardProgressBar extends StatelessWidget {
  const DashboardProgressBar({
    super.key,
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  color,
                  color.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

