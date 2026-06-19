import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

/// Shows quiz history stored locally on this device. In Phase 3 this
/// becomes the per-student view of data that an admin panel aggregates
/// across a whole catechism class - same QuizAttempt shape, just synced.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<AppState>().history;

    return Scaffold(
      appBar: AppBar(title: const Text('Your progress')),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No quiz attempts yet — take a quiz from a chapter to see your history here.',
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final a = history[index];
                final percent = (a.percent * 100).round();
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('$percent%')),
                    title: Text(a.chapterLabel),
                    subtitle: Text(
                      '${a.correct}/${a.total} correct · ${_formatDate(a.takenAt)}',
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}
