class IntroTalkItem {
  final int id;
  final String talk;
  final String puriImage;
  final String backImage;
  final int? nextId;

  IntroTalkItem({
    required this.id,
    required this.talk,
    required this.puriImage,
    required this.backImage,
    this.nextId
  });

  factory IntroTalkItem.fromJson(Map<String, dynamic> json) {
    return IntroTalkItem(
      id: json['id'],
      talk: json['talk'],
      puriImage: json['puri_image'],
      backImage: json['back_image'] ?? '',
      nextId: json['next_id'],
    );
  }
}
