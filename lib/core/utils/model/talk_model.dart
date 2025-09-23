import '../../../constants/enum/speaker_enums.dart';
import '../../../constants/enum/image_enums.dart';
import '../image_path_validator.dart';

class Talk {
  final int id;
  final int? stage; // stage 필드 추가 (optional)
  final Speaker speaker;
  final String speakerImg;
  final String backImg;
  final String talk;

  Talk({
    required this.id,
    this.stage,
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
      case 'Both':
        speaker = Speaker.both;
        break;
      case 'Book':
        speaker = Speaker.book;
        break;
      default:
        throw Exception('Invalid speaker value: ${json['speaker']}');
    }

    return Talk(
      id: json['id'],
      stage: json['stage'] as int?,
      speaker: speaker,
      speakerImg: ImagePathValidator.validate(
        json['speakerImg'] as String?,
        ImageAssets.furiStanding.path,
        logInvalid: true,
      ),
      backImg: ImagePathValidator.validate(
        json['backImg'] as String?,
        ImageAssets.background.path,
        logInvalid: true,
      ),
      talk: json['talk'],
    );
  }
}