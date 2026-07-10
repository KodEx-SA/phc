import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../widgets/phc_empty_state.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<AppState>().history;

    return Scaffold(
      appBar: AppBar(title: const Text('Your progress')),
      body: history.isEmpty
          ? const PhcEmptyState(
              symbol: '†',
              title: 'No attempts yet',
              message: 'Complete a quiz from any chapter and your results will appear here.',
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
