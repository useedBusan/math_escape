class HighQRAnswer {
  final int id;
  final String title;
  final String correctAnswer;
  final String qrImagePath;
  final String description;

  HighQRAnswer({
    required this.id,
    required this.title,
    required this.correctAnswer,
    required this.qrImagePath,
    required this.description,
  });

  factory HighQRAnswer.fromJson(Map<String, dynamic> json) {
    return HighQRAnswer(
      id: json['id'] as int,
      title: json['title'] as String,
      correctAnswer: json['correctAnswer'] as String,
      qrImagePath: json['qrImagePath'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'correctAnswer': correctAnswer,
      'qrImagePath': qrImagePath,
      'description': description,
    };
  }
}
