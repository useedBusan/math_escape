class CorrectTalkItem {
  final int id;
  final String talk;
  final String answer;
  final String furiImage;
  final String backImage;
  final int? nextId;

  CorrectTalkItem({
    required this.id,
    required this.talk,
    required this.answer,
    required this.furiImage,
    required this.backImage,
    this.nextId
  });

  factory CorrectTalkItem.fromJson(Map<String, dynamic> json) {
    return CorrectTalkItem(
      id: json['id'],
      talk: json['talk'],
      answer: json['answer'] ?? '',
      furiImage: json['furiImage'],
      backImage: json['backImage'] ?? '',
      nextId: json['next_id'],
    );
  }
}
