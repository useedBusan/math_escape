import 'package:flutter/cupertino.dart';
import '../../../core/utils/model/hint_model.dart';

@immutable
class ElementaryLowMissionModel {
  final int id;
  final String title;
  final String question;
  final List<String> choices;
  final int answerIndex;
  final String? questionImage;
  final List<HintEntry> hints;

  const ElementaryLowMissionModel({
    required this.id,
    required this.title,
    required this.question,
    required this.choices,
    required this.answerIndex,
    required this.hints,
    this.questionImage,
  });

  factory ElementaryLowMissionModel.fromJson(Map<String, dynamic> json) {
    final hintText  = (json['hintText'] as String?) ?? '';
    final hintImage = json['hintImage'] as String?;
    final hintVideo = json['hintVideo'] as String?;

    final entry = (text: hintText, image: hintImage, video: hintVideo);
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
      'hintImage': first?.image,
      'hintVideo': first?.video,
    };
  }

  HintEntry? get firstHint => hints.isNotEmpty ? hints.first : null;

  static bool _isEmptyHint(HintEntry e) =>
      e.text.trim().isEmpty && e.image == null && e.video == null;
}