# Math Escape API 문서

## 📋 목차
1. [모델 (Models)](#모델-models)
2. [화면 (Screens)](#화면-screens)
3. [위젯 (Widgets)](#위젯-widgets)
4. [상수 (Constants)](#상수-constants)
5. [미션 (Missions)](#미션-missions)
6. [데이터 (Data)](#데이터-data)
7. [유틸리티 (Utilities)](#유틸리티-utilities)
8. [의존성 패키지 (Dependencies)](#의존성-패키지-dependencies)

---

## 모델 (Models)

### 고등 미션 모델
- **HighMissionQuestion**: 고등 문제 데이터 모델
- **HighMissionAnswer**: 고등 정답/해설 데이터 모델

### 중등 미션 모델 ✅ 새로 구현 완료
- **MissionItem**: 중등 문제 데이터 모델
  ```dart
  {
    id: int,
    title: String,
    question: String,
    answer: List<String>,
    hint1: String,
    hint2: String,
    backImage: String,
    questionImage: String
  }
  ```
- **CorrectTalkItem**: 중등 정답 시 대화 데이터 모델
  ```dart
  {
    id: int,
    talks: List<TalkItem>
  }
  ```
- **TalkItem**: 개별 대화 아이템 모델
  ```dart
  {
    talk: String,
    furiImage: String,
    backImage: String
  }
  ```

### 초등(고학년) 모델
- **ElementaryHighMissionQuestion**: 정답 배열(`answer`), 힌트(`hint1`, `hint2`), 이미지(optional)
- **ElementaryHighMissionAnswer**: 정답/해설, 이미지(optional)

### 공통 모델
- **ContentItem**: 콘텐츠 카드 데이터 모델

---

## 화면 (Screens)

### 메인 화면
- **MyApp**: 앱 루트, 테마(`AppTheme`), 상수(`AppConstants`) 관리
- **SplashScreen**: 앱 시작 로딩, 자동 메인 이동
- **MainScreen**: 학년별 카드(`SchoolLevelCard`), 콘텐츠 카드(`ContentCard`), 상수(`AppConstants`)

### 인트로 화면
- **HighIntroScreen**: 고등 미션 소개, 규칙, QR 안내, 오디오 재생
- **MiddleIntroScreen**: 중등 미션 소개 ✅ 구현 완료

### 미션 화면
- **QRScanScreen**: 카메라 권한, QR 인식
- **HighMission**: 문제/타이머/정답입력/힌트, 공통 위젯(`DescriptionLevelBox`, `QuestionBalloon`, `TimerInfoBox`), 스타일 상수(`high_mission_constants.dart`)
- **HighAnswer**: 해설/정답/다음문제, 공통 위젯(`DescriptionLevelBox`, `ExplanationBox`, `ClueBox`, `TimerInfoBox`), 스타일 상수(`high_answer_constants.dart`)
- **ElementaryHighTalkScreen**: 초등 고학년 도입 대화(스토리) 진행
- **ElementaryHighMissionScreen**: 초등 고학년 미션 화면
- **MiddleMissionScreen**: 중등 미션 화면 ✅ 새로 구현 완료
- **TalkScreen**: 중등 미션 대화 진행 화면 ✅ 새로 구현 완료

---

## 위젯 (Widgets)

### 공통 위젯
- **SchoolLevelCard**: 학년별 선택 카드
- **ContentCard**: 기타 콘텐츠 카드
- **AnswerPopup**: 정답/오답 피드백 팝업

### 미션 전용 위젯
- **DescriptionLevelBox**: 설명+레벨 박스
- **QuestionBalloon**: 문제 말풍선
- **TimerInfoBox**: 하단 타이머 박스
- **ExplanationBox**: 해설 박스 (정답 화면)
- **ClueBox**: 단서 박스 (정답 화면)

### 중등 미션 전용 위젯 ✅ 새로 추가
- **MiddleHintPopup**: 중등 미션 힌트 팝업
- **MiddleAnswerPopup**: 중등 미션 정답/오답 팝업

### 초등 미션 전용 위젯
- **ElementaryHighHintPopup**: 초등 고학년 힌트 팝업
- **ElementaryHighAnswerPopup**: 초등 고학년 정답/오답 팝업

---

## 상수 (Constants)

### 앱 전역 상수
- **AppConstants**: 앱 전역 상수 (타이틀, URL, 이미지 경로 등)

### 미션별 상수
- **high_mission_constants.dart**: 고등 미션 화면 스타일 상수
- **high_answer_constants.dart**: 고등 정답 화면 스타일 상수

---

## 미션 (Missions)

### 고등 미션
- **HighMission**: 실시간 타이머, 문제 표시, 정답 입력, 힌트 제공, 공통 위젯/상수 활용
- **HighAnswer**: 정답 해설, 다음 문제/게임 완료, 시간 표시, 공통 위젯/상수 활용

### 중등 미션 ✅ 새로 구현 완료
- **MiddleMission**: 중등 미션 구현 - 10문제, 2단계 힌트, 정답 시 대화 시스템
- **TalkScreen**: 정답 시 푸리 캐릭터와의 스토리 진행
- **애니메이션**: 힌트 버튼 색상 변화 효과
- **반응형 UI**: 다양한 화면 크기 지원

### 초등 미션
- **ElementaryHighMission**: 초등 고학년 미션 ✅ 구현 완료
- **ElementaryLowMission**: 초등 저학년 미션 (구현 예정)

---

## 데이터 (Data)

### JSON 데이터 파일
- **high_level_question.json**: 고등 문제 데이터
- **high_level_answer.json**: 고등 정답 데이터
- **middle_question.json**: 중등 문제 데이터 ✅ 구현 완료
- **middle_correct_talks.json**: 중등 정답 시 대화 데이터 ✅ 새로 추가
- **elementary_high_question.json**: 초등 고학년 문제 데이터
- **elementary_high_context.json**: 초등 고학년 대화 데이터

### 데이터 로딩
- JSON 파일에서 문제/정답 데이터 로딩
- 각 학년별로 분리된 데이터 구조
- 중등 미션: 문제 데이터와 대화 데이터 분리 관리

---

## 유틸리티 (Utilities)

### 권한 처리
- **카메라 권한**: QR 스캔을 위한 카메라 권한 요청 (`permission_handler`)
- **iOS 권한**: iOS 별도 권한 처리 필요

### 외부 연동
- **URL 런처**: 외부 링크 열기 (`url_launcher`)
- **QR 스캔**: QR 코드 인식 (`qr_code_scanner`)

### 오디오
- **오디오 재생**: 인트로 사운드 재생 (`audioplayers`)

### 애니메이션 ✅ 새로 추가
- **힌트 버튼 애니메이션**: 색상 변화 효과 (`AnimationController`, `Tween`)
- **대화 전환**: 화면 간 부드러운 전환 효과

---

## 의존성 패키지 (Dependencies)

### 핵심 패키지
- **permission_handler**: ^12.0.0+1 - 카메라 권한 처리
- **qr_code_scanner**: 1.0.1 - QR 코드 스캔
- **url_launcher**: 6.2.5 - 외부 링크 열기

### UI/UX 패키지
- **flutter_spinkit**: ^5.2.1 - 로딩 애니메이션
- **flutter_math_fork**: 0.7.4 - 수학 공식 렌더링
- **material_symbols_icons**: 4.2858.1 - 머티리얼 심볼 아이콘

### 미디어 패키지
- **audioplayers**: ^5.2.1 - 오디오 재생
- **gif**: ^2.3.0 - GIF 표시

### 기본 패키지
- **cupertino_icons**: ^1.0.8 - iOS 스타일 아이콘

---

## 🆕 최신 업데이트 (2025년 1월)

### 중등 미션 시스템 완성
- **MiddleMissionScreen**: 10문제 구성, 2단계 힌트 시스템
- **대화 시스템**: 정답 시 푸리 캐릭터와의 스토리 진행
- **애니메이션**: 힌트 버튼 색상 변화 효과
- **반응형 UI**: 다양한 화면 크기 지원

### 새로운 모델
- **MissionItem**: 중등 문제 데이터 구조
- **CorrectTalkItem**: 정답 시 대화 데이터 구조
- **TalkItem**: 개별 대화 아이템 구조

### 새로운 위젯
- **MiddleHintPopup**: 중등 미션 전용 힌트 팝업
- **MiddleAnswerPopup**: 중등 미션 전용 정답 팝업
- **TalkScreen**: 대화 진행 화면

### 새로운 데이터 파일
- **middle_correct_talks.json**: 중등 미션 대화 데이터

---

## 개발 환경

- **Flutter**: 3.32.4
- **Dart**: 3.8.1
- **Android**: 최소 API 레벨 21
- **iOS**: 최소 버전 12.0
- **Web**: 지원
- **Desktop**: Windows, macOS, Linux 지원

---

**문서 버전**: 1.1.0  
**최종 업데이트**: 2025년 1월