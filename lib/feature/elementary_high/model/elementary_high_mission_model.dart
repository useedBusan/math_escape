class ElementaryHighMissionModel {
  final int id;
  final String title;
  final String question;
  final List<String> choices;
  final List<String> answer;
  final String? questionImage;
  final bool isqr;
  final ElementaryHighMissionHintModel hintModel;

  ElementaryHighMissionModel({
    required this.id,
    required this.title,
    required this.question,
    required this.choices,
    required this.answer,
    this.questionImage,
    this.isqr = false,
    required this.hintModel,
  });

  factory ElementaryHighMissionModel.fromJson(Map<String, dynamic> json) {
    return ElementaryHighMissionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      question: json['question'] as String,
      choices: List<String>.from(json['choices'] ?? const []),
      answer: json['answer'] is List
          ? List<String>.from(json['answer'])
          : [json['answer']?.toString() ?? ''],
      questionImage: json['questionImage'] as String?,
      isqr: json['isqr'] as bool? ?? false,
      hintModel: ElementaryHighMissionHintModel.fromJson(json),
    );
  }
}

typedef HintEntry = ({String text, String? image, String? video});

class ElementaryHighMissionHintModel {
  final List<HintEntry> hints;

  const ElementaryHighMissionHintModel({required this.hints});

  factory ElementaryHighMissionHintModel.fromJson(Map<String, dynamic> json) {
    final List<HintEntry> list = [];

    if (json['hint1'] != null && (json['hint1'] as String).isNotEmpty) {
      list.add((text: json['hint1'], image: null, video: null));
    }
    if (json['hint2'] != null && (json['hint2'] as String).isNotEmpty) {
      list.add((text: json['hint2'], image: null, video: null));
    }

    return ElementaryHighMissionHintModel(hints: list);
  }
}