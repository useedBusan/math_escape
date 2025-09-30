class CorrectTalkItem {
  final int id;
  final String talk;
  final String answer;
  final String puri_image;
  final String back_image;
  final int? nextId;

  CorrectTalkItem({
    required this.id,
    required this.talk,
    required this.answer,
    required this.puri_image,
    required this.back_image,
    this.nextId
  });

  factory CorrectTalkItem.fromJson(Map<String, dynamic> json) {
    return CorrectTalkItem(
      id: json['id'],
      talk: json['talk'],
      answer: json['answer'] ?? '',
      puri_image: json['puri_image'],
      back_image: json['back_image'] ?? '',
      nextId: json['next_id'],
    );
  }
}
