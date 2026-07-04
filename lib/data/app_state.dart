import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizAttempt {
  final String chapterId;
  final String chapterLabel;
  final int correct;
  final int total;
  final DateTime takenAt;

  QuizAttempt({
    required this.chapterId,
    required this.chapterLabel,
    required this.correct,
    required this.total,
    required this.takenAt,
  });

  double get percent => total == 0 ? 0 : correct / total;

  Map<String, dynamic> toJson() => {
    'chapterId': chapterId,
    'chapterLabel': chapterLabel,
    'correct': correct,
    'total': total,
    'takenAt': takenAt.toIso8601String(),
  };

  factory QuizAttempt.fromJson(Map<String, dynamic> json) => QuizAttempt(
    chapterId: json['chapterId'],
    chapterLabel: json['chapterLabel'],
    correct: json['correct'],
    total: json['total'],
    takenAt: DateTime.parse(json['takenAt']),
  );
}

class AppState extends ChangeNotifier {
  static const _kLangKey = 'phc_lang_is_english';
  static const _kThemeKey = 'phc_theme_is_dark';
  static const _kHistoryKey = 'phc_quiz_history';

  bool _isEnglish = false;
  bool _isDark = false;
  List<QuizAttempt> _history = [];

  bool get isEnglish => _isEnglish;
  bool get isDark => _isDark;
  List<QuizAttempt> get history => List.unmodifiable(_history);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnglish = prefs.getBool(_kLangKey) ?? false;
    _isDark = prefs.getBool(_kThemeKey) ?? false;
    final historyRaw = prefs.getStringList(_kHistoryKey) ?? [];
    _history =
        historyRaw.map((s) => QuizAttempt.fromJson(jsonDecode(s))).toList()
          ..sort((a, b) => b.takenAt.compareTo(a.takenAt));
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _isEnglish = !_isEnglish;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLangKey, _isEnglish);
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kThemeKey, _isDark);
  }

  Future<void> recordQuizAttempt(QuizAttempt attempt) async {
    _history.insert(0, attempt);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final historyRaw = _history.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList(_kHistoryKey, historyRaw);
  }

  /// Best score - as a percentage.
  double? bestScoreFor(String chapterId) {
    final attempts = _history.where((a) => a.chapterId == chapterId);
    if (attempts.isEmpty) return null;
    return attempts.map((a) => a.percent).reduce((a, b) => a > b ? a : b);
  }
}
