/// 이미지 에셋 경로를 관리하는 enum
/// 
/// 사용법:
/// ```dart
/// Image.asset(ImageAssets.background.path)
/// ```
enum ImageAssets {
  // ===== Common Images =====
  /// 공통 배경 이미지
  background('assets/images/common/bsbackground.png'),
  
  /// 푸리 기본 서있는 모습
  furiStanding('assets/images/common/furiStanding.png'),
  
  /// 푸리 책 읽는 모습
  furiReading('assets/images/common/furiReading.png'),
  
  /// 푸리 만세하는 모습
  furiHurray('assets/images/common/furiHurray.png'),
  
  /// 푸리 좋아하는 모습
  furiGood('assets/images/common/furiGood.png'),
  
  /// 푸리 놀라는 모습
  furiSurprised('assets/images/common/furiSurprised.png'),
  
  /// 푸리 설명하는 모습
  furiExplaining('assets/images/common/furiExplaining.png'),
  
  /// 푸리 연필 든 모습
  furiPencil('assets/images/common/furiPencil.png'),
  
  /// 푸리 반짝이는 모습
  furiBlingBling('assets/images/common/furiBlingBling.png'),
  
  /// 푸리 힌트 주는 모습
  hintFuri('assets/images/common/hintFuri.png'),
  
  /// 푸리 성공 모습
  successFuri('assets/images/common/successFuri.png'),
  
  /// 푸리 실패 모습
  failFuri('assets/images/common/failFuri.png'),
  
  /// 매매 기본 서있는 모습
  maemaeStanding('assets/images/common/maemaeStanding.png'),
  
  /// 매매 책 든 모습
  maemaeBook('assets/images/common/maemaeBook.png'),
  
  /// 매매 만세하는 모습
  maemaeHurray('assets/images/common/maemaeHurray.png'),
  
  /// 매매 자잔 모습
  maemaeJajan('assets/images/common/maemaeJajan.png'),
  
  /// 메인 배너
  bannerMain('assets/images/common/bannerMain.png'),

  // ===== Elementary Low Images =====
  /// 초등 저학년 배너
  elemLowBanner('assets/images/elementary_low/bannerElemLow.png'),
  
  /// 초등 저학년 배경 1
  elemLowBg1('assets/images/elementary_low/elemBG1.png'),
  
  /// 초등 저학년 배경 2
  elemLowBg2('assets/images/elementary_low/elemBG2.png'),
  
  /// 초등 저학년 배경 3
  elemLowBg3('assets/images/elementary_low/elemBG3.png'),
  
  /// 초등 저학년 배경 4
  elemLowBg4('assets/images/elementary_low/elemBG4.png'),
  
  /// 초등 저학년 배경 5
  elemLowBg5('assets/images/elementary_low/elemBG5.png'),
  
  /// 초등 저학년 배경 6
  elemLowBg6('assets/images/elementary_low/elemBG6.png'),
  
  /// 초등 저학년 종료 배경
  elemLowBgEnd('assets/images/elementary_low/elemBGEnd.png'),
  
  /// 초등 저학년 힌트 1
  elemLowHint1('assets/images/elementary_low/elemLowHint1.png'),
  
  /// 초등 저학년 힌트 2
  elemLowHint2('assets/images/elementary_low/elemLowHint2.png'),
  
  /// 초등 저학년 힌트 3
  elemLowHint3('assets/images/elementary_low/elemLowHint3.png'),
  
  /// 초등 저학년 힌트 4
  elemLowHint4('assets/images/elementary_low/elemLowHint4.png'),
  
  /// 초등 저학년 힌트 5
  elemLowHint5('assets/images/elementary_low/elemLowHint5.png'),
  
  /// 초등 저학년 힌트 6
  elemLowHint6('assets/images/elementary_low/elemLowHint6.png'),
  
  /// 초등 저학년 문제 5
  elemLowQuestion5('assets/images/elementary_low/elemLowQuestion5.png'),
  
  /// 초등 저학년 문제 6
  elemLowQuestion6('assets/images/elementary_low/elemLowQuestion6.png'),
  
  /// 초등 저학년 푸리+매매 함께
  elemLowBoth('assets/images/elementary_low/elemLowBoth.png'),
  
  /// 초등 저학년 푸리 숫자 세는 모습
  elemLowFuriCount('assets/images/elementary_low/elemLowFuriCount.png'),
  
  /// 초등 저학년 푸리 피보나치 모습
  elemLowFuriFibonacci('assets/images/elementary_low/elemLowFuriFibonacci.png'),

  // ===== Elementary High Images =====
  /// 초등 고학년 배너
  elemHighBanner('assets/images/elementary_high/bannerElemHigh.png'),
  
  /// 초등 고학년 푸리+판다
  elemHighFuriPanda('assets/images/elementary_high/elemHighFuriPanda.png'),
  
  /// 초등 고학년 푸리+수사모
  elemHighFuriSSM('assets/images/elementary_high/elemHighFuriSSM.png'),
  
  /// 초등 고학년 완료 이미지
  elemHighFinish('assets/images/elementary_high/elemHighFinish.png'),
  
  /// 초등 고학년 배경 이미지들 (뒤의 숫자가 문항번호에 대응)
  elemHigh5('assets/images/elementary_high/elemHigh5.png'),
  elemHigh17('assets/images/elementary_high/elemHigh17.png'),
  elemHigh23('assets/images/elementary_high/elemHigh23.png'),
  elemHigh49('assets/images/elementary_high/elemHigh49.png'),
  elemHigh68('assets/images/elementary_high/elemHigh68.png'),

  // ===== Middle Images =====
  /// 중학교 배경 1-3
  middleBg123('assets/images/middle/middleBG123.png'),
  
  /// 중학교 배경 4-6
  middleBg456('assets/images/middle/middleBG456.png'),
  
  /// 중학교 배경 7-9
  middleBg789('assets/images/middle/middleBG789.png'),
  
  /// 중학교 일기장
  middleDiary('assets/images/middle/middleDiary.png'),
  
  /// 중학교 힌트
  middleHint('assets/images/middle/middleHint.png'),
  
  /// 중학교 문제 1
  middleQuestion1('assets/images/middle/middleQuestion1.png'),
  
  /// 중학교 문제 9
  middleQuestion9('assets/images/middle/middleQuestion9.png'),

  // ===== High Images =====
  /// 고등학교 문제 이미지들
  high2('assets/images/high/high2.png'),
  high3('assets/images/high/high3.png'),
  high4('assets/images/high/high4.png'),
  high5('assets/images/high/high5.png'),
  high6('assets/images/high/high6.png'),
  high7('assets/images/high/high7.png'),
  high8('assets/images/high/high8.png'),
  high9('assets/images/high/high9.png'),
  highA('assets/images/high/highA.png'),
  highB('assets/images/high/highB.png'),
  highC('assets/images/high/highC.png'),
  
  /// 고등학교 완료 이미지
  highComplete('assets/images/high/highComplete.png'),
  
  /// 고등학교 푸리
  highFuri('assets/images/high/highFuri.png');

  const ImageAssets(this.path);
  
  /// 이미지 파일의 경로
  final String path;
  
  /// 이미지 파일명만 반환 (확장자 포함)
  String get fileName => path.split('/').last;
  
  /// 이미지 파일명만 반환 (확장자 제외)
  String get nameWithoutExtension => fileName.split('.').first;
  
  /// 학년별 기본 배너 이미지 반환
  static String getBannerForGrade(String grade) {
    switch (grade.toLowerCase()) {
      case 'elementary_low':
      case 'elem_low':
        return ImageAssets.elemLowBanner.path;
      case 'elementary_high':
      case 'elem_high':
        return ImageAssets.elemHighBanner.path;
      case 'middle':
        return ImageAssets.middleBg123.path;
      case 'high':
        return ImageAssets.high2.path;
      default:
        return ImageAssets.bannerMain.path;
    }
  }
  
  /// 스피커별 기본 이미지 반환
  static String getDefaultSpeakerImage(String speaker) {
    switch (speaker.toLowerCase()) {
      case 'puri':
        return ImageAssets.furiStanding.path;
      case 'maemae':
        return ImageAssets.maemaeStanding.path;
      case 'book':
        return ImageAssets.maemaeBook.path;
      case 'both':
        return ImageAssets.elemLowBoth.path;
      default:
        return ImageAssets.furiStanding.path;
    }
  }
}
