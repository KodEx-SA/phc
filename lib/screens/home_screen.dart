import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../data/content_repository.dart';
import '../models/content_models.dart';
import '../widgets/chapter_card.dart';
import '../widgets/language_toggle.dart';
import '../widgets/home_reader.dart';
import '../widgets/phc_loading.dart';
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
        title: const Text('PHC Study'),
        actions: const [LanguageToggle()],
      ),

      body: _content == null
          ? const PhcLoading()
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: _content!.chapters.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return HomeHeader(english: english);
                }
                final chapter = _content!.chapters[index - 1];
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
