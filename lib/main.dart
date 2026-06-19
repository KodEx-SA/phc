import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/app_state.dart';
import 'data/content_repository.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PHCStudyApp());
}

class PHCStudyApp extends StatelessWidget {
  const PHCStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()..load()),
        // Swap LocalJsonContentRepository for a RemoteContentRepository
        // here in Phase 3 — nothing else in the app needs to change.
        Provider<ContentRepository>(
          create: (_) => LocalJsonContentRepository(),
        ),
      ],
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'PHC Study',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: appState.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
