# Math Escape API 문서

## 📋 목차
1. [모델 (Models)](#모델-models)
2. [화면 (Screens)](#화면-screens)
3. [위젯 (Widgets)](#위젯-widgets)
4. [상수 (Constants)](#상수-constants)
5. [미션 (Missions)](#미션-missions)
6. [유틸리티 (Utilities)](#유틸리티-utilities)

---

## 모델 (Models)

- **MissionQuestion**: 문제 데이터 모델
- **MissionAnswer**: 정답/해설 데이터 모델
- **ContentItem**: 콘텐츠 카드 데이터 모델

---

## 화면 (Screens)

- **MyApp**: 앱 루트, 테마(`AppTheme`), 상수(`AppConstants`) 관리
- **SplashScreen**: 앱 시작 로딩, 자동 메인 이동
- **MainScreen**: 학년별 카드(`SchoolLevelCard`), 콘텐츠 카드(`ContentCard`), 상수(`AppConstants`)
- **HighIntroScreen**: 고등 미션 소개, 규칙, QR 안내
- **QRScanScreen**: 카메라 권한, QR 인식
- **HighMission**: 문제/타이머/정답입력/힌트, 공통 위젯(`DescriptionLevelBox`, `QuestionBalloon`, `TimerInfoBox`), 스타일 상수(`high_mission_constants.dart`)
- **HighAnswer**: 해설/정답/다음문제, 공통 위젯(`DescriptionLevelBox`, `ExplanationBox`, `ClueBox`, `TimerInfoBox`), 스타일 상수(`high_answer_constants.dart`)

---

## 위젯 (Widgets)

- **SchoolLevelCard**: 학년별 선택 카드
- **ContentCard**: 기타 콘텐츠 카드
- **AnswerPopup**: 정답/오답 피드백 팝업
- **DescriptionLevelBox**: 설명+레벨 박스
- **QuestionBalloon**: 문제 말풍선
- **TimerInfoBox**: 하단 타이머 박스
- **ExplanationBox**: 해설 박스 (정답 화면)
- **ClueBox**: 단서 박스 (정답 화면)

---

## 상수 (Constants)

- **AppConstants**: 앱 전역 상수 (타이틀, URL, 이미지 경로 등)
- **high_mission_constants.dart**: 고등 미션 화면 스타일 상수
- **high_answer_constants.dart**: 고등 정답 화면 스타일 상수

---

## 미션 (Missions)

- **HighMission**: 실시간 타이머, 문제 표시, 정답 입력, 힌트 제공, 공통 위젯/상수 활용
- **HighAnswer**: 정답 해설, 다음 문제/게임 완료, 시간 표시, 공통 위젯/상수 활용

---

## 유틸리티 (Utilities)

- **JSON 데이터 로딩**: 문제/정답 데이터 파일에서 로딩
- **URL 런처**: 외부 링크 열기 (`url_launcher`)
- **권한 처리**: 카메라 권한 요청 (`permission_handler`)
- **IOS는 별도 권한 처리 필요**
---

**문서 버전**: 0.0.1  
**최종 업데이트**: 2025년