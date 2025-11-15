// ============================================================================
// DASHBOARD CONSTANTS
// ============================================================================
// Konstanta untuk styling dashboard
// Centralized untuk consistency dan mudah di-maintain
// ============================================================================

import 'package:flutter/material.dart';

/// Warna tema dashboard
class DashboardColors {
  // Primary colors
  static const Color primaryBlue = Color(0xFF2F80ED);
  static const Color primaryBlueDark = Color(0xFF1E6FD9);

  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundAlt = Color(0xFFFAFBFF);

  // Border colors
  static const Color border = Color(0xFFE8EAF2);

  // Text colors
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textTertiary = Color(0xFF7A7C89);
  static const Color textLight = Color(0xFF6C6E7E);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFFA755);
  static const Color error = Color(0xFFEB5757);

  // Finance card colors
  static const Color financeKasMasuk = Color(0xFFDDEAFF);
  static const Color financeKasKeluar = Color(0xFFFBE7EA);
  static const Color financeTotal = Color(0xFFE8F0FF);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark],
  );

  static const LinearGradient whiteGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.white, cardBackgroundAlt],
  );
}

/// Ukuran spacing yang digunakan di dashboard
class DashboardSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

/// Border radius yang digunakan di dashboard
class DashboardRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 18.0;
  static const double xxl = 20.0;
  static const double xxxl = 24.0;
  static const double card = 22.0;
  static const double cardLarge = 26.0;
}

/// Ukuran icon yang digunakan di dashboard
class DashboardIconSize {
  static const double xs = 18.0;
  static const double sm = 20.0;
  static const double md = 22.0;
  static const double lg = 24.0;
  static const double xl = 26.0;
  static const double xxl = 32.0;
}

/// Shadow yang sering digunakan
class DashboardShadow {
  static List<BoxShadow> card([Color? color]) => [
    BoxShadow(
      color: (color ?? DashboardColors.primaryBlue).withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> cardLarge([Color? color]) => [
    BoxShadow(
      color: (color ?? DashboardColors.primaryBlue).withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> button([Color? color]) => [
    BoxShadow(
      color: (color ?? DashboardColors.primaryBlue).withValues(alpha: 0.3),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> icon([Color? color]) => [
    BoxShadow(
      color: (color ?? DashboardColors.primaryBlue).withValues(alpha: 0.08),
      offset: const Offset(0, 2),
      blurRadius: 8,
    ),
  ];
}

