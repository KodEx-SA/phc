import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

/// The app's persistent navigation shell. Home, Progress, and Settings
/// live as tabs here; Reader and Quiz screens still push on top via
/// Navigator from within the Home tab, since those are a "drill into
/// a chapter" flow rather than top-level destinations.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _screens = [HomeScreen(), ProgressScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps all three screens alive in memory rather than
      // rebuilding them on every tab switch — so Home's loaded content
      // and scroll position survive switching to Progress and back.
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
