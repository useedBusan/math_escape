import '../../../constants/enum/speaker_enums.dart';
import '../../../constants/enum/image_enums.dart';

class Talk {
  final int id;
  final int? stage; // stage 필드 추가 (optional)
  final Speaker speaker;
  final String speakerImg;
  final String backImg;
  final String talk;
  final String? voice; // 보이스 오버 자산 경로 (optional)

  Talk({
    required this.id,
    this.stage,
    required this.speaker,
    required this.speakerImg,
    required this.backImg,
    required this.talk,
    this.voice,
  });

  factory Talk.fromJson(Map<String, dynamic> json) {
    Speaker speaker;
    
    // 초등고학년 데이터 구조 처리 (speaker 필드가 없는 경우)
    if (json['speaker'] == null) {
      // puri_image가 있으면 푸리로 간주
      speaker = Speaker.puri;
    } else {
      // 초등저학년 데이터 구조 처리
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
    }

    return Talk(
      id: json['id'],
      stage: json['stage'] as int?,
      speaker: speaker,
      speakerImg: json['speakerImg'] as String? ?? json['furiImage'] as String? ?? ImageAssets.furiStanding.path,
      backImg: json['backImg'] as String? ?? json['backImage'] as String? ?? ImageAssets.background.path,
      talk: json['talk'],
      voice: json['voice'] as String?,
    );
  }
}