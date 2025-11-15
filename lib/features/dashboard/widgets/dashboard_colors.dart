// ============================================================================
// DASHBOARD COLORS - Konstanta warna untuk dashboard
// ============================================================================
// Clean Code Principles:
// ✅ Single Responsibility - hanya menyimpan konstanta warna
// ✅ Mudah di-maintain - semua warna terpusat di satu tempat
// ============================================================================

import 'package:flutter/material.dart';

/// Konstanta warna untuk dashboard
class DashboardColors {
  DashboardColors._(); // Private constructor untuk prevent instantiation

  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;

  // Primary colors
  static const Color primaryBlue = Color(0xFF2F80ED);
  static const Color primaryBlueDark = Color(0xFF1E6FD9);

  // Finance card colors
  static const Color incomeBackground = Color(0xFFDDEAFF);
  static const Color outcomeBackground = Color(0xFFFBE7EA);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFFA755);
  static const Color warningDark = Color(0xFFFF8C42);
  static const Color error = Color(0xFFEB5757);
  static const Color purple = Color(0xFF7C6FFF);
  static const Color purpleLight = Color(0xFF9D8FFF);

  // Text colors
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textTertiary = Color(0xFF7A7C89);
  static const Color textGray = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFF6B7280);

  // Border colors
  static const Color border = Color(0xFFE8EAF2);
  static const Color borderLight = Color(0xFFE0E3EE);
  static const Color divider = Color(0xFFF3F4F6);

  // Gradient colors
  static List<Color> get primaryGradient => [primaryBlue, primaryBlueDark];
  static List<Color> get warningGradient => [warning, warningDark];
  static List<Color> get purpleGradient => [purple, purpleLight];
}

