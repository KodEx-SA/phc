import 'package:flutter/material.dart';
import '../models/content_models.dart';

class ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final bool english;
  final VoidCallback onRead;
  final VoidCallback onQuiz;
  final double? bestScore;

  const ChapterCard({
    super.key,
    required this.chapter,
    required this.english,
    required this.onRead,
    required this.onQuiz,
    this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: scheme.secondary, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                english ? chapter.labelEn : chapter.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                chapter.title(english),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (bestScore != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 16,
                      color: scheme.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Best quiz score: ${(bestScore! * 100).round()}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRead,
                      icon: const Icon(Icons.menu_book_outlined),
                      label: const Text('Read'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onQuiz,
                      icon: const Icon(Icons.quiz_outlined),
                      label: const Text('Quiz'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
