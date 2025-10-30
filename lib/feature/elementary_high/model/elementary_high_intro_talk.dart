class IntroTalkItem {
  final int id;
  final String talk;
  final String answer;
  final String furiImage;
  final String backImage;
  final String? voice;

  IntroTalkItem({
    required this.id,
    required this.talk,
    required this.answer,
    required this.furiImage,
    required this.backImage,
    this.voice,
  });

  factory IntroTalkItem.fromJson(Map<String, dynamic> json) {
    return IntroTalkItem(
      id: json['id'],
      talk: json['talk'],
      answer: json['answer'],
      furiImage: json['furiImage'],
      backImage: json['backImage'] ?? '',
      voice: json['voice'] as String?,
    );
  }
}
