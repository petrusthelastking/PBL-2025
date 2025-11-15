// ============================================================================
// PRIMARY ACTION BUTTON
// ============================================================================
// Button besar untuk aksi utama (Selengkapnya)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_constants.dart';
import '../dashboard_detail_page.dart';

/// Button aksi utama di dashboard
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    this.text = 'Selengkapnya',
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: DashboardColors.primaryGradient,
        borderRadius: BorderRadius.circular(DashboardRadius.xl),
        boxShadow: DashboardShadow.button(),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DashboardRadius.xl),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed ?? () => _navigateToDetail(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.dashboard_customize_rounded,
              size: 24,
            ),
            const SizedBox(width: DashboardSpacing.md),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: DashboardSpacing.sm),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardDetailPage(),
      ),
    );
  }
}

