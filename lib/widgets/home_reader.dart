import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  final bool english;

  const HomeHeader({super.key, required this.english});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          bottom: BorderSide(
            color: scheme.secondary.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cross ornament
          Text('✛', style: TextStyle(fontSize: 28, color: scheme.secondary)),
          const SizedBox(height: 10),
          // Church name
          Text(
            english
                ? 'Pentecostal Holiness Church'
                : 'Pentekoste ya Boitshepiso',
            textAlign: TextAlign.center,
            style: GoogleFonts.ebGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: scheme.primary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          // Thin gold rule
          Container(height: 1.5, width: 80, color: scheme.secondary),
          const SizedBox(height: 8),
          // Subtitle
          Text(
            english
                ? 'Sunday School Catechism'
                : 'Thuto tsa Sekolo sa Phuthegwana',
            textAlign: TextAlign.center,
            style: GoogleFonts.ebGaramond(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: scheme.onSurface.withValues(alpha: 0.65),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
