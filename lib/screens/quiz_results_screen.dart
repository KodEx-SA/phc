import 'package:flutter/material.dart';

class QuizResultsScreen extends StatelessWidget {
  final int correct;
  final int total;
  final String chapterLabel;

  const QuizResultsScreen({
    super.key,
    required this.correct,
    required this.total,
    required this.chapterLabel,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : ((correct / total) * 100).round();
    final scheme = Theme.of(context).colorScheme;

    String message;
    if (percent >= 90) {
      message = 'Excellent — ready for the next chapter.';
    } else if (percent >= 70) {
      message = 'Solid grasp. A bit more review will make it stick.';
    } else if (percent >= 50) {
      message = 'Halfway there — worth reading through this chapter again.';
    } else {
      message = 'This one needs more study time before moving on.';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chapterLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 64,
                backgroundColor: scheme.primaryContainer,
                child: Text(
                  '$percent%',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$correct out of $total correct',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text('Back to chapters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
