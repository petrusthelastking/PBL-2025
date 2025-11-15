import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => buildAppTheme();
}

ThemeData buildAppTheme() {
  final baseTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
  );

  final colorScheme = baseTheme.colorScheme.copyWith(
    primary: const Color(0xFF2F80ED),
    secondary: const Color(0xFF2F80ED),
  );

  return baseTheme.copyWith(
    colorScheme: colorScheme,
    textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1F1F1F),
      elevation: 0,
    ),
  );
}
