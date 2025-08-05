class MiddleMissionQuestion {
  final int id;
  final String description;
  final String level;
  final String title;
  final String question;
  final String questionImage;
  final List<String> answer;
  final String hint1;
  final String hint2;

  MiddleMissionQuestion({
    required this.id,
    required this.description,
    required this.level,
    required this.title,
    required this.question,
    required this.questionImage,
    required this.answer,
    required this.hint1,
    required this.hint2,
  });

  factory MiddleMissionQuestion.fromJson(Map<String, dynamic> json) {
    return MiddleMissionQuestion(
      id: json['id'] as int,
      description: json['description'] as String,
      level: json['level'] as String,
      title: json['title'] as String,
      question: json['question'] as String,
      questionImage: json['questionImage'] as String,
      answer: List<String>.from(json['answer'] as List),
      hint1: json['hint1'] as String,
      hint2: json['hint2'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'level': level,
      'title': title,
      'question': question,
      'questionImage': questionImage,
      'answer': answer,
      'hint1': hint1,
      'hint2': hint2,
    };
  }
}
