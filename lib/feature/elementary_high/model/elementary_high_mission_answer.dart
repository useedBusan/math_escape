class ElementaryHighMissionAnswer {
  final int id;
  final String title;
  final String answer;
  final String description;
  final String? answerImage;

  ElementaryHighMissionAnswer({
    required this.id,
    required this.title,
    required this.answer,
    required this.description,
    this.answerImage,
  });

  factory ElementaryHighMissionAnswer.fromJson(Map<String, dynamic> json) {
    return ElementaryHighMissionAnswer(
      id: json['id'],
      title: json['title'],
      answer: json['answer'],
      description: json['description'],
      answerImage: json['answerImage'],
    );
  }
} 