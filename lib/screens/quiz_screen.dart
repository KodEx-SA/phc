import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/content_models.dart';
import 'quiz_results_screen.dart';
import '../widgets/phc_empty_state.dart';

class _QuizQuestion {
  final ContentBlock source;
  final String questionText;
  final String correctAnswer;
  final List<String> options;

  _QuizQuestion({
    required this.source,
    required this.questionText,
    required this.correctAnswer,
    required this.options,
  });
}

class QuizScreen extends StatefulWidget {
  final StudyContent content;
  final Chapter? chapterScope; // null means cumulative, all chapters
  final int questionCount;

  const QuizScreen({
    super.key,
    required this.content,
    required this.chapterScope,
    required this.questionCount,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<_QuizQuestion> _questions;
  int _index = 0;
  int _correct = 0;
  String? _selected;
  bool _answered = false;
  final List<bool> _resultsPerQuestion = [];
  late bool _english;

  @override
  void initState() {
    super.initState();
    _english = context.read<AppState>().isEnglish;
    _questions = _generateQuestions();
  }

  List<_QuizQuestion> _generateQuestions() {
    final rng = Random();
    final pool =
        (widget.chapterScope?.quizzableBlocks ??
                widget.content.allQuizzableBlocks)
            .toList()
          ..shuffle(rng);
    final globalPool = widget.content.allQuizzableBlocks;

    final chosen = pool.take(widget.questionCount).toList();
    final questions = <_QuizQuestion>[];

    for (final block in chosen) {
      final correct = block.answer(_english);
      final distractorSource = pool.length >= 4 ? pool : globalPool;
      final distractors =
          distractorSource
              .where((b) => b.id != block.id && b.answer(_english) != correct)
              .toList()
            ..shuffle(rng);
      final options = <String>{
        correct,
        ...distractors.take(3).map((b) => b.answer(_english)),
      }.toList()..shuffle(rng);

      questions.add(
        _QuizQuestion(
          source: block,
          questionText: block.question(_english),
          correctAnswer: correct,
          options: options,
        ),
      );
    }
    return questions;
  }

  void _selectOption(String option) {
    if (_answered) return;
    setState(() {
      _selected = option;
      _answered = true;
      final isCorrect = option == _questions[_index].correctAnswer;
      if (isCorrect) _correct++;
      _resultsPerQuestion.add(isCorrect);
    });
  }

  void _next() {
    if (_index + 1 >= _questions.length) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _answered = false;
    });
  }

  Future<void> _finish() async {
    final appState = context.read<AppState>();
    final chapterId = widget.chapterScope?.id ?? 'all';
    final chapterLabel = widget.chapterScope != null
        ? widget.chapterScope!.title(_english)
        : 'All chapters';
    await appState.recordQuizAttempt(
      QuizAttempt(
        chapterId: chapterId,
        chapterLabel: chapterLabel,
        correct: _correct,
        total: _questions.length,
        takenAt: DateTime.now(),
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizResultsScreen(
          correct: _correct,
          total: _questions.length,
          chapterLabel: chapterLabel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const PhcEmptyState(
        symbol: '†',
        title: 'Not enough questions',
        message: 'This chapter does not have enough content to generate a quiz.',
      ),
      );
    }

    final q = _questions[_index];
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_index + 1} of ${_questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_index) / _questions.length,
                minHeight: 6,
                backgroundColor: scheme.secondary.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(scheme.secondary),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_index + 1} of ${_questions.length}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(color: scheme.primary, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'POTSO',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: scheme.primary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    q.questionText,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  for (final option in q.options) _buildOption(option, q),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _answered ? _next : null,
                child: Text(
                  _index + 1 >= _questions.length
                      ? 'See results'
                      : 'Next question',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String option, _QuizQuestion q) {
    final scheme = Theme.of(context).colorScheme;
    final isCorrect = option == q.correctAnswer;
    final isSelected = option == _selected;

    Color bgColor;
    Color borderColor;
    Widget? trailingIcon;

    if (_answered) {
      if (isCorrect) {
        bgColor = const Color(0xFFE8F5E9);
        borderColor = Colors.green.shade700;
        trailingIcon = Icon(
          Icons.check_circle,
          color: Colors.green.shade700,
          size: 22,
        );
      } else if (isSelected) {
        bgColor = const Color(0xFFFFEBEE);
        borderColor = scheme.error;
        trailingIcon = Icon(Icons.cancel, color: scheme.error, size: 22);
      } else {
        bgColor = scheme.surface;
        borderColor = scheme.outlineVariant;
        trailingIcon = null;
      }
    } else {
      bgColor = scheme.surface;
      borderColor = scheme.secondary.withValues(alpha: 0.5);
      trailingIcon = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () => _selectOption(option),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  option,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: 10),
                trailingIcon,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
