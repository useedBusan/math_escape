import '../../../core/utils/qr_answer_validator.dart';
import '../../../core/models/hint_model.dart';

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

  /// QR 정답 제공자로 변환
  QRAnswerProvider toQRAnswerProvider() {
    return ElementaryHighQRAnswerProvider(
      id: id,
      isqr: isqr,
      answer: answer,
    );
  }

  /// QR 스캔 결과 검증
  bool validateQRAnswer(String scannedValue) {
    return QRAnswerValidator.validateQRAnswer(scannedValue, toQRAnswerProvider());
  }
}

class ElementaryHighMissionHintModel {
  final List<HintEntry> hints;

  const ElementaryHighMissionHintModel({required this.hints});

  factory ElementaryHighMissionHintModel.fromJson(Map<String, dynamic> json) {
    final List<HintEntry> list = [];

    if (json['hint1'] != null && (json['hint1'] as String).isNotEmpty) {
      list.add((text: json['hint1'], images: null, videos: null));
    }
    if (json['hint2'] != null && (json['hint2'] as String).isNotEmpty) {
      list.add((text: json['hint2'], images: null, videos: null));
    }

    return ElementaryHighMissionHintModel(hints: list);
  }
}