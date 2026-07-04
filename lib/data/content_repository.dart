import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/content_models.dart';

abstract class ContentRepository {
  Future<StudyContent> loadContent();
}

class LocalJsonContentRepository implements ContentRepository {
  final String assetPath;

  LocalJsonContentRepository({this.assetPath = 'assets/data/content.json'});

  StudyContent? _cache;

  @override
  Future<StudyContent> loadContent() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final content = StudyContent.fromJson(json);
    _cache = content;
    return content;
  }
}

// ==================================== Phase 3 sketch ====================================
//
// class RemoteContentRepository implements ContentRepository {
//   final String branchId;
//   RemoteContentRepository(this.branchId);
//
//   @override
//   Future<StudyContent> loadContent() async {
//     // Fetch the same JSON shape from Supabase for this branchId,
//     // falling back to a bundled copy if offline. The rest of the app
//     // (models, screens, quiz logic) needs zero changes for this to work.
//     throw UnimplementedError();
//   }
// }
