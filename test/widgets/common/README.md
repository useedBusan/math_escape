# 공통 위젯 테스트 가이드

## 개요
이 디렉토리는 공통 위젯들에 대한 테스트 코드를 포함하고 있습니다.

## 테스트 파일 구조
```
test/widgets/common/
├── common_answer_popup_test.dart      # AnswerPopup 테스트
├── common_hint_popup_test.dart        # HintPopup 테스트
├── common_button_test.dart            # Button 테스트
├── common_loading_test.dart           # Loading 테스트
├── common_error_test.dart             # Error 테스트
├── common_widgets_integration_test.dart # 통합 테스트
├── run_tests.dart                     # 테스트 실행 가이드
└── README.md                          # 이 파일
```

## 테스트 실행 방법

### 개별 테스트 실행
```bash
# WidgetConstants 테스트
flutter test test/constants/widget_constants_test.dart

# AnswerPopup 테스트
flutter test test/widgets/common/common_answer_popup_test.dart

# HintPopup 테스트
flutter test test/widgets/common/common_hint_popup_test.dart

# Button 테스트
flutter test test/widgets/common/common_button_test.dart

# Loading 테스트
flutter test test/widgets/common/common_loading_test.dart

# Error 테스트
flutter test test/widgets/common/common_error_test.dart

# 통합 테스트
flutter test test/widgets/common/common_widgets_integration_test.dart
```

### 모든 공통 위젯 테스트 실행
```bash
# 상수와 공통 위젯 테스트 모두 실행
flutter test test/constants/ test/widgets/common/

# 또는 특정 디렉토리만 실행
flutter test test/widgets/common/
```

### 상세한 출력으로 테스트 실행
```bash
flutter test test/widgets/common/ --verbose
```

## 테스트 커버리지

### WidgetConstants
- 색상 상수 테스트
- 크기 상수 테스트
- 폰트 크기 상수 테스트
- 애니메이션 상수 테스트
- 텍스트 스타일 테스트

### CommonAnswerPopup
- 정답/오답 팝업 렌더링 테스트
- 커스텀 제목/메시지 테스트
- 버튼 클릭 콜백 테스트
- 학년별 특화 팝업 테스트

### CommonHintPopup
- 힌트 팝업 렌더링 테스트
- 커스텀 아이콘 테스트
- 버튼 클릭 콜백 테스트
- 학년별 특화 팝업 테스트

### CommonButton
- 기본 버튼 렌더링 테스트
- 버튼 클릭 콜백 테스트
- 로딩 상태 테스트
- 아이콘 버튼 테스트
- 커스텀 스타일 테스트
- 특화 버튼 테스트 (QR, 힌트, 제출, 다음)

### CommonLoading
- 기본 로딩 테스트
- 메시지 표시 테스트
- 커스텀 스타일 테스트
- 다양한 로딩 타입 테스트

### CommonError
- 기본 에러 테스트
- 재시도 버튼 테스트
- 커스텀 아이콘/메시지 테스트
- 특화 에러 타입 테스트

### 통합 테스트
- 여러 위젯이 함께 사용되는 시나리오 테스트
- 학년별 특화 팝업 조합 테스트

## 테스트 결과 확인

테스트 실행 후 다음과 같은 결과를 확인할 수 있습니다:

- ✅ 모든 테스트 통과
- ❌ 실패한 테스트와 원인
- 📊 테스트 커버리지 (옵션)

## 문제 해결

### 테스트 실패 시
1. 에러 메시지를 확인하세요
2. 위젯의 props가 올바르게 전달되었는지 확인하세요
3. 콜백 함수가 올바르게 호출되는지 확인하세요

### 테스트 실행 오류 시
1. `flutter clean` 실행 후 다시 시도
2. `flutter pub get` 실행 후 다시 시도
3. IDE를 재시작 후 다시 시도

## 추가 테스트 작성

새로운 공통 위젯을 추가할 때는 다음 규칙을 따르세요:

1. `test/widgets/common/` 디렉토리에 `{widget_name}_test.dart` 파일 생성
2. 위젯의 모든 public 메서드와 props에 대한 테스트 작성
3. 다양한 시나리오에 대한 테스트 케이스 작성
4. 통합 테스트에 새로운 위젯 추가
5. 이 README 파일 업데이트
