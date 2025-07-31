class MissionQuestion {
  final int id;
  final String level;
  final String title;
  final String question;
  final String? questionImage;
  final List<String> answer;
  final String hint;
  final String description;

  MissionQuestion({
    required this.id,
    required this.level,
    required this.title,
    required this.question,
    this.questionImage,
    required this.answer,
    required this.hint,
    required this.description,
  });

  factory MissionQuestion.fromJson(Map<String, dynamic> json) {
    return MissionQuestion(
      id: json['id'],
      level: json['level'],
      title: json['title'],
      question: json['question'],
      questionImage: json['questionImage'],
      answer: (json['answer'] as List<dynamic>).map((e) => e.toString()).toList(),
      hint: json['hint'],
      description: json['description'],
    );
  }
}