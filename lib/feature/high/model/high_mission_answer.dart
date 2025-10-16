class MissionAnswer {
  final int id;
  final int stage;
  final String level;
  final String title;
  final String explanation;
  final String clueTitle;
  final String? answerImage;
  final String clue;

  MissionAnswer({
    required this.id,
    required this.stage,
    required this.level,
    required this.title,
    required this.explanation,
    required this.clueTitle,
    this.answerImage,
    required this.clue,
  });

  factory MissionAnswer.fromJson(Map<String, dynamic> json) {
    return MissionAnswer(
      id: json['id'],
      stage: json['stage'],
      level: json['level'],
      title: json['title'],
      explanation: json['explanation'],
      clueTitle: json['clueTitle'],
      answerImage: json['answerImage'],
      clue: json['clue'],
    );
  }
}