import '../../../core/utils/qr_answer_validator.dart';

class MissionQuestion {
  final int id;
  final int stage;
  final String level;
  final String title;
  final String question;
  final String? questionImage;
  final List<String> answer;
  final String hint;
  final bool isqr;
  final bool isHint;

  MissionQuestion({
    required this.id,
    required this.stage,
    required this.level,
    required this.title,
    required this.question,
    this.questionImage,
    required this.answer,
    required this.hint,
    required this.isqr,
    required this.isHint,
  });

  factory MissionQuestion.fromJson(Map<String, dynamic> json) {
    return MissionQuestion(
      id: json['id'],
      stage: json['stage'],
      level: json['level'],
      title: json['title'],
      question: json['question'],
      questionImage: json['questionImage'],
      answer: (json['answer'] as List<dynamic>).map((e) => e.toString()).toList(),
      hint: json['hint'],
      isqr: json['isqr'] ?? false,
      isHint: json['isHint'] ?? false,
    );
  }

  /// QR 정답 제공자로 변환
  QRAnswerProvider toQRAnswerProvider() {
    return HighQRAnswerProvider(
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