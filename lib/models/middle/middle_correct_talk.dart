class CorrectTalkItem {
  final int id;
  final String talk;
  final String puri_image;
  final String back_image;
  final String answer;
  final int? nextId;

  CorrectTalkItem({
    required this.id,
    required this.talk,
    required this.puri_image,
    required this.back_image,
    required this.answer,
    this.nextId
  });

  factory CorrectTalkItem.fromJson(Map<String, dynamic> json) {
    return CorrectTalkItem(
      id: json['id'],
      talk: json['talk'],
      puri_image: json['puri_image'],
      back_image: json['back_image'] ?? '',
      answer: json['answer'],
      nextId: json['next_id'],
    );
  }
}
