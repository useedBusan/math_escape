class IntroTalkItem {
  final int id;
  final String talk;
  final String puri_image;
  final String back_image;
  final int? nextId;

  IntroTalkItem({
    required this.id,
    required this.talk,
    required this.puri_image,
    required this.back_image,
    this.nextId
  });

  factory IntroTalkItem.fromJson(Map<String, dynamic> json) {
    return IntroTalkItem(
      id: json['id'],
      talk: json['talk'],
      puri_image: json['puri_image'],
      back_image: json['back_image'] ?? '',
      nextId: json['next_id'],
    );
  }
}
