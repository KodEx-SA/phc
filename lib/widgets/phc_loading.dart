import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhcLoading extends StatelessWidget {
  const PhcLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '✛',
            style: TextStyle(
              fontSize: 36,
              color: scheme.secondary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: scheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: GoogleFonts.ebGaramond(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
