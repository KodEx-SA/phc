import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../data/content_repository.dart';
import '../models/content_models.dart';
import '../widgets/chapter_card.dart';
import '../widgets/language_toggle.dart';
import 'quiz_setup_screen.dart';
import 'reader_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StudyContent? _content;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final repo = context.read<ContentRepository>();
    final content = await repo.loadContent();
    if (mounted) setState(() => _content = content);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final english = appState.isEnglish;

    return Scaffold(
      appBar: AppBar(
        title: Text(_content?.title(english) ?? 'PHC Study'),

        actions: const [
          LanguageToggle(),
        ],

      ),
      body: _content == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _content!.chapters.length,
              itemBuilder: (context, index) {
                final chapter = _content!.chapters[index];
                return ChapterCard(
                  chapter: chapter,
                  english: english,
                  bestScore: appState.bestScoreFor(chapter.id),
                  onRead: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReaderScreen(chapter: chapter),
                    ),
                  ),
                  onQuiz: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuizSetupScreen(
                        content: _content!,
                        initialChapter: chapter,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
