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
  final String puri_image;
  final String back_image;

  TalkItem({
    required this.talk,
    required this.puri_image,
    required this.back_image,
  });

  factory TalkItem.fromJson(Map<String, dynamic> json) {
    return TalkItem(
      talk: json['talk'],
      puri_image: json['puri_image'] as String? ?? ImageAssets.furiGood.path,
      back_image: json['back_image'] as String? ?? ImageAssets.background.path,
    );
  }
}

class MissionItem {
  final int id;
  final String title;
  final String question;
  final List<String> answer;
  final String hint1;
  final String hint2;
  final String back_image;
  final String questionImage;
  final bool isqr;

  MissionItem({
    required this.id,
    required this.title,
    required this.question,
    required this.answer,
    required this.hint1,
    required this.hint2,
    required this.back_image,
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

    return MissionItem(
      id: json['id'],
      title: json['title'],
      question: json['question'],
      answer: parsedAnswer,
      hint1: json['hint1'],
      hint2: json['hint2'],
      back_image: json['back_image'] ?? '',
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