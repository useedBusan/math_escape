class IntroTalkItem {
  final int id;
  final String talk;
  final String puriImage;
  final String backImage;
  final int? nextId;
  final String? voice;

  IntroTalkItem({
    required this.id,
    required this.talk,
    required this.puriImage,
    required this.backImage,
    this.nextId,
    this.voice,
  });

  factory IntroTalkItem.fromJson(Map<String, dynamic> json) {
    return IntroTalkItem(
      id: json['id'],
      talk: json['talk'],
      puriImage: json['furiImage'],
      backImage: json['backImage'] ?? '',
      nextId: json['next_id'],
      voice: json['voice'] as String?,
    );
  }
}
