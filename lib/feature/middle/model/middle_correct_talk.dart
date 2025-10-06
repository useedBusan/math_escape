class CorrectTalkItem {
  final int id;
  final String talk;
  final String furiImage;
  final String backImage;
  final String answer;
  final int? nextId;

  CorrectTalkItem({
    required this.id,
    required this.talk,
    required this.furiImage,
    required this.backImage,
    required this.answer,
    this.nextId
  });

  factory CorrectTalkItem.fromJson(Map<String, dynamic> json) {
    return CorrectTalkItem(
      id: json['id'],
      talk: json['talk'],
      furiImage: json['furiImage'],
      backImage: json['backImage'] ?? '',
      answer: json['answer'],
      nextId: json['next_id'],
    );
  }
}
