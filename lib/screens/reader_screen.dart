import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../models/content_models.dart';
import '../widgets/language_toggle.dart';

/// Renders one chapter exactly as it appears in the source booklet:
/// headings, then Potso/Karabo pairs, list-style answers, and explanatory
/// text passages, in the same order as the document.
class ReaderScreen extends StatelessWidget {
  final Chapter chapter;

  const ReaderScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final english = context.watch<AppState>().isEnglish;

    return Scaffold(
      appBar: AppBar(
        title: Text(english ? chapter.labelEn : chapter.label),
        actions: const [LanguageToggle()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            chapter.title(english),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          for (final block in chapter.blocks)
            _buildBlock(context, block, english),
        ],
      ),
    );
  }

  Widget _buildBlock(BuildContext context, ContentBlock block, bool english) {
    final scheme = Theme.of(context).colorScheme;

    if (block is HeadingBlock) {
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(
          english ? block.labelEn : block.labelTn,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      );
    }

    if (block is QABlock) {
      return _QACard(
        question: block.question(english),
        answer: block.answer(english),
      );
    }

    if (block is ListAnswerBlock) {
      return _ListAnswerCard(block: block, english: english);
    }

    if (block is TextBlock) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          block.content(english),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _QACard extends StatelessWidget {
  final String question;
  final String answer;

  const _QACard({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POTSO: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KARABO: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.secondary,
                ),
              ),
              Expanded(
                child: Text(
                  answer,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ListAnswerCard extends StatelessWidget {
  final ListAnswerBlock block;
  final bool english;

  const _ListAnswerCard({required this.block, required this.english});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final items = block.items(english);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POTSO: ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
              Expanded(
                child: Text(
                  block.question(english),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'KARABO: ${block.answerLabel(english)} (${block.count})',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: scheme.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < items.length; i++)
                Chip(label: Text('${i + 1}. ${items[i]}')),
            ],
          ),
        ],
      ),
    );
  }
}
