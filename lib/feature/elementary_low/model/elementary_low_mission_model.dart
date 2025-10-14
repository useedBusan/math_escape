import 'package:flutter/cupertino.dart';
import '../../../core/models/hint_model.dart';
import '../../../core/utils/qr_answer_validator.dart';

@immutable
class ElementaryLowMissionModel {
  final int id;
  final String title;
  final String question;
  final List<String> choices;
  final int answerIndex;
  final String? questionImage;
  final List<HintEntry> hints;
  final bool isqr;

  const ElementaryLowMissionModel({
    required this.id,
    required this.title,
    required this.question,
    required this.choices,
    required this.answerIndex,
    required this.hints,
    this.questionImage,
    this.isqr = false,
  });

  factory ElementaryLowMissionModel.fromJson(Map<String, dynamic> json) {
    final hintText  = (json['hintText'] as String?) ?? '';
    final hintImages = (json['hintImage'] as List?)?.map((e) => e.toString()).toList();
    final hintVideos = (json['hintVideo'] as List?)?.map((e) => e.toString()).toList();

    final entry = (text: hintText, images: hintImages, videos: hintVideos);
    final list  = _isEmptyHint(entry) ? <HintEntry>[] : <HintEntry>[entry];

    final rawAnswer = (json['answer'] as num?)?.toInt() ?? 1;
    final zeroBased = (rawAnswer - 1).clamp(0, (json['choices'] as List).length - 1);

    return ElementaryLowMissionModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      question: json['question'] as String,
      choices: (json['choices'] as List).map((e) => e.toString()).toList(),
      answerIndex: zeroBased,
      questionImage: json['images'] as String?,
      hints: list,
      isqr: json['isqr'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final first = hints.isNotEmpty ? hints.first : null;
    return {
      'id': id,
      'title': title,
      'question': question,
      'choices': choices,
      'answer': answerIndex + 1,
      'images': questionImage,
      'hintText': first?.text,
      'hintImage': first?.images ?? [],
      'hintVideo': first?.videos ?? [],
    };
  }

  HintEntry? get firstHint => hints.isNotEmpty ? hints.first : null;

  /// QR 정답 제공자로 변환
  QRAnswerProvider toQRAnswerProvider() {
    return ElementaryLowQRAnswerProvider(
      id: id,
      isqr: isqr,
      choices: choices,
      answerIndex: answerIndex,
    );
  }

  /// QR 스캔 결과 검증
  bool validateQRAnswer(String scannedValue) {
    return QRAnswerValidator.validateQRAnswer(scannedValue, toQRAnswerProvider());
  }

  static bool _isEmptyHint(HintEntry e) =>
      e.text.trim().isEmpty && (e.images == null || e.images!.isEmpty) && (e.videos == null || e.videos!.isEmpty);
}