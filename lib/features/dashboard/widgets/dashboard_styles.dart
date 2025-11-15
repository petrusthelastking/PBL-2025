// ============================================================================
// DASHBOARD STYLES - Style constants untuk dashboard
// ============================================================================
// Clean Code Principles:
// ✅ Single Responsibility - hanya menyimpan style constants
// ✅ Reusable - bisa dipakai di semua widget dashboard
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Style constants untuk dashboard
class DashboardStyles {
  DashboardStyles._(); // Private constructor

  // Text Styles
  static TextStyle headerTitle = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.5,
  );

  static TextStyle headerSubtitle = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.white.withValues(alpha: 0.9),
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static TextStyle sectionTitle = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle cardTitle = GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
  );

  static TextStyle cardValue = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  static TextStyle cardLabel = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static TextStyle cardSubtitle = GoogleFonts.poppins(
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  // Border Radius
  static BorderRadius cardRadius = BorderRadius.circular(24);
  static BorderRadius smallCardRadius = BorderRadius.circular(16);
  static BorderRadius buttonRadius = BorderRadius.circular(18);
  static BorderRadius iconRadius = BorderRadius.circular(14);

  // Paddings
  static const EdgeInsets cardPadding = EdgeInsets.all(24);
  static const EdgeInsets smallCardPadding = EdgeInsets.all(16);
  static const EdgeInsets contentPadding = EdgeInsets.fromLTRB(20, 20, 20, 100);

  // Shadows
  static List<BoxShadow> cardShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> iconShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
}

