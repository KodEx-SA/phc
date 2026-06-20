import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A warm, "printed study Bible" identity - parchment/ivory surfaces in
/// light mode, deep leather-brown in dark mode, maroon and antique gold
/// as the two accent colors, and one serif typeface (EB Garamond) used
/// consistently for both headings and body text rather than splitting
/// serif headings against sans-serif body"
class AppTheme {
  static const _primarySeed = Color(0xFF6B1F2A); // deep maroon
  static const _gold = Color(0xFFB8860B); // antique gold
  static const _parchment = Color(0xFFFBF3E2); // warm ivory
  static const _leather = Color(0xFF2B1E18); // deep espresso brown

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: Brightness.light,
      secondary: _gold,
      surface: _parchment,
    );
    return _build(scheme);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: Brightness.dark,
      secondary: _gold,
      surface: _leather,
    );
    return _build(scheme);
  }

  static ThemeData _build(ColorScheme scheme) {
    final textTheme = GoogleFonts.ebGaramondTextTheme().copyWith(
      bodyLarge: GoogleFonts.ebGaramond(fontSize: 18, height: 1.6),
      bodyMedium: GoogleFonts.ebGaramond(fontSize: 16, height: 1.6),
      bodySmall: GoogleFonts.ebGaramond(fontSize: 14, height: 1.5),
      titleLarge: GoogleFonts.ebGaramond(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.ebGaramond(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.ebGaramond(
        fontSize: 26,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.ebGaramond(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: GoogleFonts.ebGaramond(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.3,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme.apply(
        bodyColor: scheme.onSurface,
        displayColor: scheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.ebGaramond(
          fontSize: 21,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        // A thin gold rule under the app bar instead of a Material
        // elevation shadow — reads as a page edge, not app chrome.
        shape: Border(
          bottom: BorderSide(
            color: scheme.secondary.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: scheme.secondary.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.secondary.withValues(alpha: 0.25),
        elevation: 2,
      ),
    );
  }
}
