enum Speaker { puri, maemae, book }
enum BackImg { first, second }
enum StudentGrade { elementaryLow, middle}

class Talk {
  final int id;
  final Speaker speaker;
  final String speakerImg;
  final String backImg;
  final String talk;

  Talk({
    required this.id,
    required this.speaker,
    required this.speakerImg,
    required this.backImg,
    required this.talk,
  });

  factory Talk.fromJson(Map<String, dynamic> json) {
    Speaker speaker;
    switch (json['speaker']) {
      case 'Puri':
        speaker = Speaker.puri;
        break;
      case 'Maemae':
        speaker = Speaker.maemae;
        break;
      case 'Book':
        speaker = Speaker.book;
        break;
      default:
        throw Exception('Invalid speaker value: ${json['speaker']}');
    }

    return Talk(
      id: json['id'],
      speaker: speaker,
      speakerImg: json['speakerImg'],
      backImg: json['backImg'],
      talk: json['talk'],
    );
  }
}