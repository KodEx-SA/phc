import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A calm, reverent theme - deep blue/maroon accent (common in PHC
/// regalia and Pentecostal church branding generally), generous text
/// sizing for readability during study, and a serif display font for
/// headings to feel a little less "default app" and a little more
/// "printed booklet."
class AppTheme {
  static const _seed = Color(0xFF6B1F2A); // deep maroon

  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );
    return _build(base);
  }

  static ThemeData dark() {
    final base = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );
    return _build(base);
  }

  static ThemeData _build(ColorScheme scheme) {
    final textTheme = GoogleFonts.loraTextTheme().copyWith(
      bodyLarge: GoogleFonts.notoSans(fontSize: 17, height: 1.5),
      bodyMedium: GoogleFonts.notoSans(fontSize: 15, height: 1.5),
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
        titleTextStyle: GoogleFonts.lora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
