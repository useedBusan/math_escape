# Math Escape - 부산수학문화관 앱

## 📱 주요 기능

- 학년별 수학 미션(초등/중/고) ✅ 구현 완료
- QR 코드 스캔으로 미션 시작 ✅ 구현 완료
- 실시간 타이머 및 정답/오답 피드백 ✅ 구현 완료
- 단계별 진행, 즉시 피드백, 직관적 UI/UX ✅ 구현 완료
- 부산수학문화관 홈페이지/인스타그램/프로그램 연동 ✅ 구현 완료
- 중등 미션 대화 시스템 ✅ 새로 구현 완료

### 진행 현황 개발표
- [학년별 개발 현황 진행 표](https://www.notion.so/mindtrendsetter/4c8b2b62344940d2a432fc19a78810f6?source=copy_link)

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
│   │   ├── middle/
│   │   │   ├── middle_mission_answer.dart
│   │   │   └── middle_mission_question.dart
│   │   └── elementary_high/
│   │       ├── elementary_high_mission_answer.dart
│   │       └── elementary_high_mission_question.dart
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
│   │   │   ├── middle_mission.dart ✅ 새로 구현
│   │   │   └── middle_hint_popup.dart
│   │   ├── elementary_high/
│   │   │   ├── elementary_high_mission.dart
│   │   │   └── elementary_high_talk.dart
│   │   └── elementary_low/
│   ├── data/
│   │   ├── high/
│   │   │   ├── high_level_question.json
│   │   │   └── high_level_answer.json
│   │   ├── middle/
│   │   │   ├── middle_question.json
│   │   │   └── middle_correct_talks.json ✅ 새로 추가
│   │   └── elementary_high/
│   │       ├── elementary_high_question.json
│   │       └── elementary_high_context.json
│   ├── utils/
│   └── widgets/
│       ├── school_level_card.dart
│       ├── content_card.dart
│       ├── answer_popup.dart
│       ├── middle_hint_popup.dart ✅ 새로 추가
│       ├── middle_answer_popup.dart ✅ 새로 추가
│       ├── elementary_high_hint_popup.dart
│       └── elementary_high_answer_popup.dart
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   ├── logo_icon.png
│   │   ├── introduce.png
│   │   ├── introduce_program.png
│   │   ├── insta_logo.png
│   │   ├── visual03.png
│   │   ├── banner.png
│   │   ├── bsbackground.png
│   │   ├── hint_puri.png
│   │   ├── puri_appear.gif
│   │   ├── puri_manse.png
│   │   ├── puri_stand.png
│   │   ├── correct.png
│   │   ├── wrong.png
│   │   ├── pitagoras1.png
│   │   ├── pitagoras2.png
│   │   ├── pitagoras3.png
│   │   ├── pitagoras4.png
│   │   ├── middle_Q1.png ✅ 새로 추가
│   │   ├── middle_Q9.png ✅ 새로 추가
│   │   └── bulb.png ✅ 새로 추가
│   ├── audio/
│   │   └── high_intro_sound.mp3
│   └── fonts/
│       ├── Pretendard (9 weights)
│       └── SBAggro (B, M, L)
└── android/ ios/ web/ windows/ linux/ macos/
```

## 🎯 주요 화면 및 컴포넌트

### 화면 (Screens)
- **SplashScreen**: 앱 시작 로딩, 자동 메인 이동
- **MainScreen**: 학년별 카드(`SchoolLevelCard`), 콘텐츠 카드(`ContentCard`), 홈페이지 바로가기
- **HighIntroScreen**: 고등 미션 소개, 규칙, QR 안내, 오디오 재생
- **MiddleIntroScreen**: 중등 미션 소개 ✅ 구현 완료
- **QRScanScreen**: 카메라 권한, QR 인식
- **ElementaryHighTalkScreen**: 초등 고학년 도입 대화(스토리) 진행
- **ElementaryHighMissionScreen**: 초등 고학년 미션(문제/정답/힌트)
- **MiddleMissionScreen**: 중등 미션 화면 ✅ 새로 구현 완료

### 미션 (Missions)
- **HighMission**: 문제/타이머/정답입력/힌트, 공통 위젯(`DescriptionLevelBox`, `QuestionBalloon`, `TimerInfoBox`)
- **HighAnswer**: 해설/정답/다음문제, 공통 위젯(`DescriptionLevelBox`, `ExplanationBox`, `ClueBox`, `TimerInfoBox`)
- **MiddleMission**: 중등 미션 ✅ 새로 구현 완료 - 문제/정답입력/힌트/대화 시스템
- **ElementaryHigh**: 초등 고학년 대화 → 미션 흐름 구현 완료

### 공통 위젯 (Widgets)
- **SchoolLevelCard**: 학년별 선택 카드
- **ContentCard**: 기타 콘텐츠 카드
- **AnswerPopup**: 정답/오답 피드백 팝업
- **MiddleHintPopup / MiddleAnswerPopup**: 중등 미션 전용 팝업 ✅ 새로 추가
- **ElementaryHighHintPopup / ElementaryHighAnswerPopup**: 초등 고학년 전용 팝업
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

### 중등 미션 데이터 ✅ 새로 추가
- **MissionItem**
```dart
{
  "id": 1,
  "title": "문제 제목",
  "question": "문제 내용",
  "answer": ["정답1", "정답2"],
  "hint1": "첫 번째 힌트",
  "hint2": "두 번째 힌트",
  "back_image": "배경 이미지 경로",
  "questionImage": "문제 이미지 경로 (선택)"
}
```

- **CorrectTalkItem**
```dart
{
  "id": 1,
  "talks": [
    {
      "talk": "대화 내용",
      "puri_image": "푸리 캐릭터 이미지",
      "back_image": "배경 이미지"
    }
  ]
}
```

### 초등(고학년) 데이터
- **ElementaryHighMissionQuestion**: `answer`는 문자열 배열, `hint1`, `hint2` 제공
- **ElementaryHighMissionAnswer**: 정답/해설, `answerImage` 선택

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

## 🆕 최신 업데이트 (2025년)

### 중등 미션 시스템 완성
- **MiddleMissionScreen**: 10문제 구성, 2단계 힌트 시스템
- **대화 시스템**: 정답 시 푸리 캐릭터와의 스토리 진행
- **애니메이션**: 힌트 버튼 색상 변화 효과
- **반응형 UI**: 다양한 화면 크기 지원

### 새로운 위젯
- **MiddleHintPopup**: 중등 미션 전용 힌트 팝업
- **MiddleAnswerPopup**: 중등 미션 전용 정답 팝업
- **TalkScreen**: 대화 진행 화면

## 📦 의존성 패키지

- **permission_handler**: 카메라 권한 처리
- **qr_code_scanner**: QR 코드 스캔
- **flutter_spinkit**: 로딩 애니메이션
- **url_launcher**: 외부 링크 열기
- **flutter_math_fork**: 수학 공식 렌더링
- **audioplayers**: 오디오 재생
- **gif**: GIF 이미지 표시
- **material_symbols_icons**: 머티리얼 심볼 아이콘
- **cupertino_icons**: iOS 스타일 아이콘

## 🎵 오디오 및 폰트

### 오디오
- **high_intro_sound.mp3**: 고등 미션 인트로 사운드

### 폰트
- **Pretendard**: 9가지 굵기 (Thin ~ Black)
- **SBAggro**: B/M/L 굵기

## 📝 라이선스

이 프로젝트는 부산수학문화관의 교육용 앱입니다.

**버전**: 1.0.0+1  
**최종 업데이트**: 2025년 1월  
**개발 환경**: Flutter 3.32.4, Dart 3.8.1