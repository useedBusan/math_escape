class MissionAnswer {
  final int id;
  final String level;
  final String title;
  final String explanation;
  final String clueTitle;
  final String? answerImage;
  final String description;
  final String clue;

  MissionAnswer({
    required this.id,
    required this.level,
    required this.title,
    required this.explanation,
    required this.clueTitle,
    this.answerImage,
    required this.description,
    required this.clue,
  });

  factory MissionAnswer.fromJson(Map<String, dynamic> json) {
    return MissionAnswer(
      id: json['id'],
      level: json['level'],
      title: json['title'],
      explanation: json['explanation'],
      clueTitle: json['clueTitle'],
      answerImage: json['answerImage'],
      description: json['description'],
      clue: json['clue'],
    );
  }
}