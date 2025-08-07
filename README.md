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
│   │   ├── high/
│   │   │   ├── high_mission_answer.dart
│   │   │   └── high_mission_question.dart
│   │   └── middle/
│   │       ├── middle_mission_answer.dart
│   │       └── middle_mission_question.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── main_screen.dart
│   │   ├── qr_scan_screen.dart
│   │   └── intro_screen/
│   │       ├── high_intro_screen.dart
│   │       └── middle_intro_screen.dart
│   ├── mission/
│   │   ├── high/
│   │   │   ├── high_mission.dart
│   │   │   ├── high_answer.dart
│   │   │   ├── high_mission_constants.dart
│   │   │   ├── high_answer_constants.dart
│   │   │   ├── widgets.dart
│   │   │   └── answer_widgets.dart
│   │   ├── middle/
│   │   ├── elementary_high/
│   │   └── elementary_low/
│   ├── data/
│   │   ├── high/
│   │   │   ├── high_level_question.json
│   │   │   └── high_level_answer.json
│   │   └── middle/
│   │       ├── middle_question.json
│   │       └── middle_answer.json
│   ├── utils/
│   └── widgets/
│       ├── school_level_card.dart
│       ├── content_card.dart
│       └── answer_popup.dart
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── introduce.png
│   │   ├── correct.png
│   │   ├── wrong.png
│   │   └── pitagoras1-4.png
│   ├── audio/
│   │   └── high_intro_sound.mp3
│   └── fonts/
│       └── Pretendard (9 weights)
└── android/ ios/ web/ windows/ linux/ macos/
```

## 🎯 주요 화면 및 컴포넌트

### 화면 (Screens)
- **SplashScreen**: 앱 시작 로딩, 자동 메인 이동
- **MainScreen**: 학년별 카드(`SchoolLevelCard`), 콘텐츠 카드(`ContentCard`), 홈페이지 바로가기
- **HighIntroScreen**: 고등 미션 소개, 규칙, QR 안내, 오디오 재생
- **MiddleIntroScreen**: 중등 미션 소개 (구현 예정)
- **QRScanScreen**: 카메라 권한, QR 인식

### 미션 (Missions)
- **HighMission**: 문제/타이머/정답입력/힌트, 공통 위젯(`DescriptionLevelBox`, `QuestionBalloon`, `TimerInfoBox`)
- **HighAnswer**: 해설/정답/다음문제, 공통 위젯(`DescriptionLevelBox`, `ExplanationBox`, `ClueBox`, `TimerInfoBox`)
- **MiddleMission**: 중등 미션 (구현 예정)
- **ElementaryMission**: 초등 미션 (구현 예정)

### 공통 위젯 (Widgets)
- **SchoolLevelCard**: 학년별 선택 카드
- **ContentCard**: 기타 콘텐츠 카드
- **AnswerPopup**: 정답/오답 피드백 팝업
- **DescriptionLevelBox**: 설명+레벨 박스
- **QuestionBalloon**: 문제 말풍선
- **TimerInfoBox**: 하단 타이머 박스
- **ExplanationBox**: 해설 박스
- **ClueBox**: 단서 박스

## 📊 데이터 구조

### 고등 미션 데이터
- **HighMissionQuestion**
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

- **HighMissionAnswer**
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

### 중등 미션 데이터
- **MiddleMissionQuestion**: 중등 문제 데이터 모델
- **MiddleMissionAnswer**: 중등 정답 데이터 모델

### 콘텐츠 데이터
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

### 상수 관리
- **AppConstants**: 앱 전역 상수 (타이틀, URL, 이미지 경로 등)
- **high_mission_constants.dart**: 고등 미션 화면 스타일 상수
- **high_answer_constants.dart**: 고등 정답 화면 스타일 상수

### 공통 위젯
- 반복되는 UI는 공통 위젯(`widgets/`, `mission/high/widgets.dart`, `mission/high/answer_widgets.dart`)에서 관리
- 기능별 폴더 분리, 상수/공통 위젯 적극 활용

### 개발 규칙
- 새로운 기능/화면(screen)/위젯(widgets)/상수(constants)/모델(model)/데이터(data)는 각 폴더에 추가
- 색상/폰트/패딩 등은 상수 파일에서 일괄 관리

## 📦 의존성 패키지

- **permission_handler**: 카메라 권한 처리
- **qr_code_scanner**: QR 코드 스캔
- **flutter_spinkit**: 로딩 애니메이션
- **url_launcher**: 외부 링크 열기
- **flutter_math_fork**: 수학 공식 렌더링
- **audioplayers**: 오디오 재생

## 🎵 오디오 및 폰트

### 오디오
- **high_intro_sound.mp3**: 고등 미션 인트로 사운드

### 폰트
- **Pretendard**: 9가지 굵기 (Thin ~ Black)

## 📝 라이선스

이 프로젝트는 부산수학문화관의 교육용 앱입니다.

**버전**: 0.1.1  
**최종 업데이트**: 2025년  
**개발 환경**: Flutter 3.8.1, Dart 3.8.1