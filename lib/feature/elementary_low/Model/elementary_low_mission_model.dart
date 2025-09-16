
class ElementaryLowMissionModel {
  final int id;
  final String title;
  final String question;
  final List<String> choices;
  final int answerIndex;
  final String hint1;
  final String hint2;
  final String? questionImage;

  const ElementaryLowMissionModel({
    required this.id,
    required this.title,
    required this.question,
    required this.choices,
    required this.answerIndex,
    required this.hint1,
    required this.hint2,
    this.questionImage,
  });

  factory ElementaryLowMissionModel.fromJson(Map<String, dynamic> json) {
    return ElementaryLowMissionModel(
      id: json['id'],
      title: json['title'],
      question: json['question'],
      choices: List<String>.from(json['choices']),
      answerIndex: (json['answer'] as int) - 1,
      hint1: json['hint1'] ?? '',
      hint2: json['hint2'] ?? '',
      questionImage: json['images'] as String?,
    );
  }
}