import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/content_models.dart';
import 'quiz_screen.dart';

class QuizSetupScreen extends StatefulWidget {
  final StudyContent content;
  final Chapter initialChapter;

  const QuizSetupScreen({
    super.key,
    required this.content,
    required this.initialChapter,
  });

  @override
  State<QuizSetupScreen> createState() => _QuizSetupScreenState();
}

class _QuizSetupScreenState extends State<QuizSetupScreen> {
  late bool _cumulative = false;
  int _questionCount = 10;

  @override
  Widget build(BuildContext context) {
    final english = context.watch<AppState>().isEnglish;
    final chapterPool = widget.initialChapter.quizzableBlocks.length;
    final allPool = widget.content.allQuizzableBlocks.length;
    final maxAvailable = _cumulative ? allPool : chapterPool;
    final counts = [5, 10, 15, 20].where((c) => c <= maxAvailable).toList();
    if (counts.isEmpty || !counts.contains(maxAvailable)) {
      counts.add(maxAvailable);
    }
    if (!counts.contains(_questionCount)) {
      _questionCount = counts.last;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Set up quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scope', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            RadioListTile<bool>(
              value: false,
              groupValue: _cumulative,
              title: Text(
                '${widget.initialChapter.title(english)} only ($chapterPool questions available)',
              ),
              onChanged: (v) => setState(() => _cumulative = v!),
            ),
            RadioListTile<bool>(
              value: true,
              groupValue: _cumulative,
              title: Text(
                'All chapters, cumulative ($allPool questions available)',
              ),
              onChanged: (v) => setState(() => _cumulative = v!),
            ),
            const SizedBox(height: 20),
            Text(
              'Number of questions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: [
                for (final c in counts)
                  ChoiceChip(
                    label: Text(c == maxAvailable ? 'All ($c)' : '$c'),
                    selected: _questionCount == c,
                    onSelected: (_) => setState(() => _questionCount = c),
                  ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start quiz'),
                onPressed: maxAvailable == 0
                    ? null
                    : () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              content: widget.content,
                              chapterScope: _cumulative
                                  ? null
                                  : widget.initialChapter,
                              questionCount: _questionCount,
                            ),
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
