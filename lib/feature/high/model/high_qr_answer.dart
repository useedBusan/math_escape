class HighQRAnswer {
  final int id;
  final String title;
  final String correctAnswer;
  final String qrImagePath;

  HighQRAnswer({
    required this.id,
    required this.title,
    required this.correctAnswer,
    required this.qrImagePath,
  });

  factory HighQRAnswer.fromJson(Map<String, dynamic> json) {
    return HighQRAnswer(
      id: json['id'] as int,
      title: json['title'] as String,
      correctAnswer: json['correctAnswer'] as String,
      qrImagePath: json['qrImagePath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'correctAnswer': correctAnswer,
      'qrImagePath': qrImagePath,
    };
  }
}
