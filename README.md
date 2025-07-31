# Math Escape - 부산수학문화관 앱

## 📱 주요 기능

- 학년별 수학 미션(초등/중/고)
- QR 코드 스캔으로 미션 시작
- 실시간 타이머 및 정답/오답 피드백
- 단계별 진행, 즉시 피드백, 직관적 UI/UX
- 부산수학문화관 홈페이지/인스타그램/프로그램 연동

## 🏗️ 프로젝트 구조

```
math_escape/
├── lib/
│   ├── main.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── models/
│   │   ├── content_item.dart
│   │   ├── mission_question.dart
│   │   └── mission_answer.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── main_screen.dart
│   │   ├── high_intro_screen.dart
│   │   └── qr_scan_screen.dart
│   ├── mission/
│   │   └── high/
│   │       ├── high_mission.dart
│   │       ├── high_answer.dart
│   │       ├── high_mission_constants.dart
│   │       ├── high_answer_constants.dart
│   │       ├── widgets.dart
│   │       └── answer_widgets.dart
│   └── widgets/
│       ├── school_level_card.dart
│       ├── content_card.dart
│       └── answer_popup.dart
├── assets/
│   ├── images/
│   ├── audio/
│   └── fonts/
└── android/ ios/ web/
```

## 🎯 주요 화면 및 컴포넌트

- **SplashScreen**: 앱 시작 로딩, 자동 메인 이동
- **MainScreen**: 학년별 카드(`SchoolLevelCard`), 콘텐츠 카드(`ContentCard`), 홈페이지 바로가기, 상수(`AppConstants`) 활용
- **HighIntroScreen**: 고등 미션 소개, 규칙, QR 안내
- **QRScanScreen**: 카메라 권한, QR 인식
- **HighMission**: 문제/타이머/정답입력/힌트, 공통 위젯(`DescriptionLevelBox`, `QuestionBalloon`, `TimerInfoBox`), 스타일 상수(`high_mission_constants.dart`)
- **HighAnswer**: 해설/정답/다음문제, 공통 위젯(`DescriptionLevelBox`, `ExplanationBox`, `ClueBox`, `TimerInfoBox`), 스타일 상수(`high_answer_constants.dart`)

## 📊 데이터 구조

- **MissionQuestion**
```dart
{
  "id": 1,
  "level": "high",
  "title": "문제 제목",
  "question": "문제 내용",
  "questionImage": "이미지 경로 (선택)",
  "answer": ["정답1", "정답2"],
  "hint": "힌트 내용",
  "description": "문제 설명"
}
```
- **MissionAnswer**
```dart
{
  "id": 1,
  "level": "high",
  "title": "정답 제목",
  "explanation": "정답 해설",
  "clueTitle": "힌트 제목",
  "answerImage": "해설 이미지 (선택)",
  "description": "상세 설명",
  "clue": "힌트 내용"
}
```
- **ContentItem**
```dart
{
  "image": "assets/images/introduce.png",
  "title": "부산수학문화관 소개",
  "description": "저희를 소개합니다~",
  "url": "https://home.pen.go.kr/bmcm/cm/cntnts/cntntsView.do?mi=17592&cntntsId=3823"
}
```

## 🎨 UI/UX 및 개발 가이드

- 색상/폰트/패딩 등은 상수 파일(`constants/`, `mission/high/high_mission_constants.dart`, `mission/high/high_answer_constants.dart`)에서 일괄 관리
- 반복되는 UI는 공통 위젯(`widgets/`, `mission/high/widgets.dart`, `mission/high/answer_widgets.dart`)에서 관리
- 기능별 폴더 분리, 상수/공통 위젯 적극 활용
- 새로운 기능/화면/위젯/상수/모델/데이터는 각 폴더에 추가

## 📝 라이선스

이 프로젝트는 부산수학문화관의 교육용 앱입니다.

**버전**: 0.0.1  
**최종 업데이트**: 2025년  
**개발 환경**: Flutter 3.8.1, Dart 3.8.1