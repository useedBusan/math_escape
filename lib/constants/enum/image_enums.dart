/// 이미지 에셋 경로를 관리하는 enum
/// 
/// 사용법:
/// ```dart
/// Image.asset(ImageAssets.background.path)
/// ```
enum ImageAssets {
  // ===== Common Images =====
  /// 공통 배경 이미지
  background('assets/images/common/bsbackground.webp'),
  
  /// 푸리 기본 서있는 모습
  furiStanding('assets/images/common/furiStanding.webp'),
  
  /// 푸리 책 읽는 모습
  furiReading('assets/images/common/furiReading.webp'),
  
  /// 푸리 만세하는 모습
  furiHurray('assets/images/common/furiHurray.webp'),
  
  /// 푸리 좋아하는 모습
  furiGood('assets/images/common/furiGood.webp'),
  
  /// 푸리 놀라는 모습
  furiSurprised('assets/images/common/furiSurprised.webp'),
  
  /// 푸리 설명하는 모습
  furiExplaining('assets/images/common/furiExplaining.webp'),
  
  /// 푸리 연필 든 모습
  furiPencil('assets/images/common/furiPencil.webp'),
  
  /// 푸리 반짝이는 모습
  furiBlingBling('assets/images/common/furiBlingBling.webp'),
  
  /// 푸리 힌트 주는 모습
  hintFuri('assets/images/common/hintFuri.webp'),
  
  /// 푸리 성공 모습
  successFuri('assets/images/common/successFuri.webp'),
  
  /// 푸리 실패 모습
  failFuri('assets/images/common/failFuri.webp'),
  
  /// 매매 기본 서있는 모습
  maemaeStanding('assets/images/common/maemaeStanding.webp'),
  
  /// 매매 책 든 모습
  maemaeBook('assets/images/common/maemaeBook.webp'),
  
  /// 매매 만세하는 모습
  maemaeHurray('assets/images/common/maemaeHurray.webp'),
  
  /// 매매 자잔 모습
  maemaeJajan('assets/images/common/maemaeJajan.webp'),
  
  /// 메인 배너
  bannerMain('assets/images/common/bannerMain.webp'),

  // ===== Elementary Low Images =====
  /// 초등 저학년 배너
  elemLowBanner('assets/images/elementary_low/bannerElemLow.webp'),
  
  /// 초등 저학년 배경 1
  elemLowBg1('assets/images/elementary_low/elemBG1.webp'),
  
  /// 초등 저학년 배경 2
  elemLowBg2('assets/images/elementary_low/elemBG2.webp'),
  
  /// 초등 저학년 배경 3
  elemLowBg3('assets/images/elementary_low/elemBG3.webp'),
  
  /// 초등 저학년 배경 4
  elemLowBg4('assets/images/elementary_low/elemBG4.webp'),
  
  /// 초등 저학년 배경 5
  elemLowBg5('assets/images/elementary_low/elemBG5.webp'),
  
  /// 초등 저학년 배경 6
  elemLowBg6('assets/images/elementary_low/elemBG6.webp'),
  
  /// 초등 저학년 종료 배경
  elemLowBgEnd('assets/images/elementary_low/elemBGEnd.webp'),
  
  /// 초등 저학년 힌트 1
  elemLowHint1('assets/images/elementary_low/elemLowHint1.webp'),
  
  /// 초등 저학년 힌트 2
  elemLowHint2('assets/images/elementary_low/elemLowHint2.webp'),
  
  /// 초등 저학년 힌트 3
  elemLowHint3('assets/images/elementary_low/elemLowHint3.webp'),
  
  /// 초등 저학년 힌트 4
  elemLowHint4('assets/images/elementary_low/elemLowHint4.webp'),
  
  /// 초등 저학년 힌트 5
  elemLowHint5('assets/images/elementary_low/elemLowHint5.webp'),
  
  /// 초등 저학년 힌트 6
  elemLowHint6('assets/images/elementary_low/elemLowHint6.webp'),
  
  /// 초등 저학년 문제 5
  elemLowQuestion5('assets/images/elementary_low/elemLowQuestion5.webp'),
  
  /// 초등 저학년 문제 6
  elemLowQuestion6('assets/images/elementary_low/elemLowQuestion6.webp'),
  
  /// 초등 저학년 푸리+매매 함께
  elemLowBoth('assets/images/elementary_low/elemLowBoth.webp'),
  
  /// 초등 저학년 푸리 숫자 세는 모습
  elemLowFuriCount('assets/images/elementary_low/elemLowFuriCount.webp'),
  
  /// 초등 저학년 푸리 피보나치 모습
  elemLowFuriFibonacci('assets/images/elementary_low/elemLowFuriFibonacci.webp'),

  // ===== Elementary High Images =====
  /// 초등 고학년 배너
  elemHighBanner('assets/images/elementary_high/bannerElemHigh.webp'),
  
  /// 초등 고학년 푸리+판다
  elemHighFuriPanda('assets/images/elementary_high/elemHighFuriPanda.webp'),
  
  /// 초등 고학년 푸리+수사모
  elemHighFuriSSM('assets/images/elementary_high/elemHighFuriSSM.webp'),
  
  /// 초등 고학년 완료 이미지
  elemHighFinish('assets/images/elementary_high/elemHighFinish.webp'),
  
  /// 초등 고학년 배경 이미지들 (뒤의 숫자가 문항번호에 대응)
  elemHigh5('assets/images/elementary_high/elemHigh5.webp'),
  elemHigh17('assets/images/elementary_high/elemHigh17.webp'),
  elemHigh23('assets/images/elementary_high/elemHigh23.webp'),
  elemHigh49('assets/images/elementary_high/elemHigh49.webp'),
  elemHigh68('assets/images/elementary_high/elemHigh68.webp'),

  // ===== Middle Images =====
  /// 중학교 배경 1-3
  middleBg123('assets/images/middle/middleBG123.webp'),
  
  /// 중학교 배경 4-6
  middleBg456('assets/images/middle/middleBG456.webp'),
  
  /// 중학교 배경 7-9
  middleBg789('assets/images/middle/middleBG789.webp'),
  
  /// 중학교 일기장
  middleDiary('assets/images/middle/middleDiary.webp'),
  
  /// 중학교 힌트
  middleHint('assets/images/middle/middleHint.webp'),
  
  /// 중학교 문제 1
  middleQuestion1('assets/images/middle/middleQuestion1.webp'),
  
  /// 중학교 문제 9
  middleQuestion9('assets/images/middle/middleQuestion9.webp'),

  // ===== High Images =====
  /// 고등학교 문제 이미지들
  high2('assets/images/high/high2.webp'),
  high3('assets/images/high/high3.webp'),
  high4('assets/images/high/high4.webp'),
  high5('assets/images/high/high5.webp'),
  high6('assets/images/high/high6.webp'),
  high7('assets/images/high/high7.webp'),
  high8('assets/images/high/high8.webp'),
  high9('assets/images/high/high9.webp'),
  highA('assets/images/high/highA.webp'),
  highB('assets/images/high/highB.webp'),
  highC('assets/images/high/highC.webp'),
  
  /// 고등학교 완료 이미지
  highComplete('assets/images/high/highComplete.webp'),
  
  /// 고등학교 푸리
  highFuri('assets/images/high/highFuri.webp');

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
