class IntroTalkItem {
  final int id;
  final String talk;
  final String answer;
  final String puri_image;
  final String back_image;

  IntroTalkItem({
    required this.id,
    required this.talk,
    required this.answer,
    required this.puri_image,
    required this.back_image,
  });

  factory IntroTalkItem.fromJson(Map<String, dynamic> json) {
    return IntroTalkItem(
      id: json['id'],
      talk: json['talk'],
      answer: json['answer'],
      puri_image: json['puri_image'],
      back_image: json['back_image'] ?? '',
    );
  }
}
