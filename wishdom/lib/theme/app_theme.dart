import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern Palette "Midnight Glass"
  static const Color background = Color(0xFF000000); // True Black
  static const Color surface = Color(0xFF141416); // Soft Dark
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8); // Slate Grey
  
  static const Color accent = Color(0xFF6C5CE7); // Modern Purple
  static const Color accentSecondary = Color(0xFF00CEC9); // Teal

  static ThemeData get modernDark {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: accent,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentSecondary,
        surface: surface,
        onSurface: textPrimary,
        background: background,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          color: textSecondary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: accentSecondary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    );
  }
}
