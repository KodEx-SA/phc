import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhcEmptyState extends StatelessWidget {
  final String symbol;
  final String title;
  final String message;

  const PhcEmptyState({
    super.key,
    required this.symbol,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              symbol,
              style: TextStyle(
                fontSize: 48,
                color: scheme.secondary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 1.5,
              width: 48,
              color: scheme.secondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.ebGaramond(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: scheme.onSurface.withValues(alpha: 0.6),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
