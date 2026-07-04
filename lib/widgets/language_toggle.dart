import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SegmentedButton<bool>(
        segments: const [
          ButtonSegment(value: false, label: Text('TN')),
          ButtonSegment(value: true, label: Text('EN')),
        ],
        selected: {appState.isEnglish},
        onSelectionChanged: (selection) {
          if (selection.first != appState.isEnglish) {
            appState.toggleLanguage();
          }
        },
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
      ),
    );
  }
}
