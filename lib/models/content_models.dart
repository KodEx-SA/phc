library;

enum BlockType { heading, qa, listAnswer, text }

abstract class ContentBlock {
  final String id;
  final BlockType type;
  final bool quizzable;

  const ContentBlock({
    required this.id,
    required this.type,
    this.quizzable = true,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'heading':
        return HeadingBlock.fromJson(json);
      case 'qa':
        return QABlock.fromJson(json);
      case 'list_answer':
        return ListAnswerBlock.fromJson(json);
      case 'text':
        return TextBlock.fromJson(json);
      default:
        throw FormatException('Unknown block type: ${json['type']}');
    }
  }
  String question(bool english) => '';
  String answer(bool english) => '';
}

class HeadingBlock extends ContentBlock {
  final String labelTn;
  final String labelEn;

  const HeadingBlock({
    required super.id,
    required this.labelTn,
    required this.labelEn,
  }) : super(type: BlockType.heading, quizzable: false);

  factory HeadingBlock.fromJson(Map<String, dynamic> json) => HeadingBlock(
    id: json['id'],
    labelTn: json['label_tn'],
    labelEn: json['label_en'],
  );
}

class QABlock extends ContentBlock {
  final String questionTn;
  final String answerTn;
  final String questionEn;
  final String answerEn;

  const QABlock({
    required super.id,
    required this.questionTn,
    required this.answerTn,
    required this.questionEn,
    required this.answerEn,
    super.quizzable = true,
  }) : super(type: BlockType.qa);

  factory QABlock.fromJson(Map<String, dynamic> json) => QABlock(
    id: json['id'],
    questionTn: json['question_tn'],
    answerTn: json['answer_tn'],
    questionEn: json['question_en'] ?? '',
    answerEn: json['answer_en'] ?? '',
    quizzable: json['quizzable'] ?? true,
  );
  
  @override
  String answer(bool english) => english ? answerEn : answerTn;
  @override
  String question(bool english) => english ? questionEn : questionTn;
}

class ListAnswerBlock extends ContentBlock {
  final String questionTn;
  final String questionEn;
  final String answerLabelTn;
  final String answerLabelEn;
  final int count;
  final List<String> itemsTn;
  final List<String> itemsEn;

  const ListAnswerBlock({
    required super.id,
    required this.questionTn,
    required this.questionEn,
    required this.answerLabelTn,
    required this.answerLabelEn,
    required this.count,
    required this.itemsTn,
    required this.itemsEn,
    super.quizzable = true,
  }) : super(type: BlockType.listAnswer);

  factory ListAnswerBlock.fromJson(Map<String, dynamic> json) =>
      ListAnswerBlock(
        id: json['id'],
        questionTn: json['question_tn'],
        questionEn: json['question_en'] ?? '',
        answerLabelTn: json['answer_label_tn'],
        answerLabelEn: json['answer_label_en'],
        count: json['count'],
        itemsTn: List<String>.from(json['items_tn']),
        itemsEn: List<String>.from(json['items_en']),
        quizzable: json['quizzable'] ?? true,
      );

  @override
  String question(bool english) => english ? questionEn : questionTn;
  String answerLabel(bool english) => english ? answerLabelEn : answerLabelTn;
  List<String> items(bool english) => english ? itemsEn : itemsTn;

  @override
  String answer(bool english) {
    final label = answerLabel(english);
    final list = items(english).join(', ');
    return '$label ($count): $list';
  }
}

class TextBlock extends ContentBlock {
  final String contentTn;
  final String contentEn;

  const TextBlock({
    required super.id,
    required this.contentTn,
    required this.contentEn,
    super.quizzable = false,
  }) : super(type: BlockType.text);

  factory TextBlock.fromJson(Map<String, dynamic> json) => TextBlock(
    id: json['id'],
    contentTn: json['content_tn'],
    contentEn: json['content_en'] ?? '',
    quizzable: json['quizzable'] ?? false,
  );

  String content(bool english) => english ? contentEn : contentTn;
}

class Chapter {
  final String id;
  final String label;
  final String labelEn;
  final String titleTn;
  final String titleEn;
  final List<ContentBlock> blocks;

  const Chapter({
    required this.id,
    required this.label,
    required this.labelEn,
    required this.titleTn,
    required this.titleEn,
    required this.blocks,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json['id'],
    label: json['label'],
    labelEn: json['label_en'],
    titleTn: json['title_tn'],
    titleEn: json['title_en'],
    blocks: (json['blocks'] as List)
        .map((b) => ContentBlock.fromJson(b))
        .toList(),
  );

  String title(bool english) => english ? titleEn : titleTn;

  /// All quizzable QA/list-answer blocks in this chapter.
  List<ContentBlock> get quizzableBlocks =>
      blocks.where((b) => b.quizzable).toList();
}

class StudyContent {
  final String titleTn;
  final String titleEn;
  final List<Chapter> chapters;

  const StudyContent({
    required this.titleTn,
    required this.titleEn,
    required this.chapters,
  });

  factory StudyContent.fromJson(Map<String, dynamic> json) => StudyContent(
    titleTn: json['title_tn'],
    titleEn: json['title_en'],
    chapters: (json['chapters'] as List)
        .map((c) => Chapter.fromJson(c))
        .toList(),
  );

  String title(bool english) => english ? titleEn : titleTn;
  List<ContentBlock> get allQuizzableBlocks =>
      chapters.expand((c) => c.quizzableBlocks).toList();
}
