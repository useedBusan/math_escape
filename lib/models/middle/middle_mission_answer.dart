class MiddleMissionAnswer {
  final int id;
  final String description;
  final String level;
  final String title;
  final String explanation;
  final String clueTitle;
  final String answerImage;
  final String clue;

  MiddleMissionAnswer({
    required this.id,
    required this.description,
    required this.level,
    required this.title,
    required this.explanation,
    required this.clueTitle,
    required this.answerImage,
    required this.clue,
  });

  factory MiddleMissionAnswer.fromJson(Map<String, dynamic> json) {
    return MiddleMissionAnswer(
      id: json['id'] as int,
      description: json['description'] as String,
      level: json['level'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      clueTitle: json['clueTitle'] as String,
      answerImage: json['answerImage'] as String,
      clue: json['clue'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'level': level,
      'title': title,
      'explanation': explanation,
      'clueTitle': clueTitle,
      'answerImage': answerImage,
      'clue': clue,
    };
  }
}

