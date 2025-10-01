import '../../../constants/enum/image_enums.dart';
import '../../../core/utils/qr_answer_validator.dart';

class CorrectTalkItem {
  final int id;
  final List<TalkItem> talks;

  CorrectTalkItem({required this.id, required this.talks});

  factory CorrectTalkItem.fromJson(Map<String, dynamic> json) {
    return CorrectTalkItem(
      id: json['id'],
      talks: (json['talks'] as List)
          .map((talk) => TalkItem.fromJson(talk))
          .toList(),
    );
  }
}

class TalkItem {
  final String talk;
  final String furiImage;
  final String backImage;

  TalkItem({
    required this.talk,
    required this.furiImage,
    required this.backImage,
  });

  factory TalkItem.fromJson(Map<String, dynamic> json) {
    return TalkItem(
      talk: json['talk'],
      furiImage: json['furiImage'] as String? ?? ImageAssets.furiGood.path,
      backImage: json['backImage'] as String? ?? ImageAssets.background.path,
    );
  }
}

class MissionItem {
  final int id;
  final String title;
  final String question;
  final List<String> answer;
  final List<String>? options;
  final String hint1;
  final String hint2;
  final String backImage;
  final String questionImage;
  final bool isqr;

  MissionItem({
    required this.id,
    required this.title,
    required this.question,
    required this.answer,
    this.options,
    required this.hint1,
    required this.hint2,
    required this.backImage,
    required this.questionImage,
    this.isqr = false,
  });

  factory MissionItem.fromJson(Map<String, dynamic> json) {
    List<String> parsedAnswer;
    if (json['answer'] is List) {
      parsedAnswer = List<String>.from(json['answer']);
    } else if (json['answer'] is String) {
      parsedAnswer = [json['answer'].toString().trim()];
    } else {
      parsedAnswer = [''];
    }

    List<String> parsedOptions;
    if (json['options'] is List) {
      parsedOptions = List<String>.from(json['options']);
    } else {
      parsedOptions = [];
    }

    return MissionItem(
      id: json['id'],
      title: json['title'],
      question: json['question'],
      answer: parsedAnswer,
      options: parsedOptions,
      hint1: json['hint1'],
      hint2: json['hint2'],
      backImage: json['backImage'] ?? '',
      questionImage: json['questionImage'] ?? '',
      isqr: json['isqr'] as bool? ?? false,
    );
  }

  /// QR 정답 제공자로 변환
  QRAnswerProvider toQRAnswerProvider() {
    return MiddleQRAnswerProvider(
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