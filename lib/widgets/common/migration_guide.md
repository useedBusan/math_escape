# 공통 위젯 마이그레이션 가이드

## 개요
기존의 중복된 위젯들을 통합된 공통 위젯으로 대체하는 가이드입니다.

## 마이그레이션 매핑

### AnswerPopup 마이그레이션

#### 기존 → 새로운 위젯
- `lib/widgets/answer_popup.dart` → `lib/widgets/common/common_answer_popup.dart`
- `lib/widgets/elementary_high_answer_popup.dart` → `lib/widgets/common/common_answer_popup.dart`
- `lib/widgets/middle_answer_popup.dart` → `lib/widgets/common/common_answer_popup.dart`

#### 사용법 변경

**기존 (answer_popup.dart):**
```dart
import 'package:math_escape/widgets/answer_popup.dart';

// 사용
AnswerPopup(isCorrect: true)
```

**새로운 (common_answer_popup.dart):**
```dart
import 'package:math_escape/widgets/common/common_answer_popup.dart';

// 기본 사용
BasicAnswerPopup(isCorrect: true)

// 또는 더 유연한 사용
CommonAnswerPopup(
  isCorrect: true,
  onNext: () => Navigator.pop(context),
  customTitle: '정답입니다!',
  customMessage: '잘했어요!',
)
```

**초등학교 고학년:**
```dart
// 기존
import 'package:math_escape/widgets/elementary_high_answer_popup.dart';
AnswerPopup(isCorrect: true, onNext: () {})

// 새로운
import 'package:math_escape/widgets/common/common_answer_popup.dart';
ElementaryHighAnswerPopup(isCorrect: true, onNext: () {})
```

**중학교:**
```dart
// 기존
import 'package:math_escape/widgets/middle_answer_popup.dart';
AnswerPopup(isCorrect: true, onNext: () {})

// 새로운
import 'package:math_escape/widgets/common/common_answer_popup.dart';
MiddleAnswerPopup(isCorrect: true, onNext: () {})
```

### HintDialog 마이그레이션

#### 기존 → 새로운 위젯
- `lib/widgets/elementary_high_hint_popup.dart` → `lib/widgets/common/common_hint_popup.dart`
- `lib/widgets/middle_hint_popup.dart` → `lib/widgets/common/common_hint_popup.dart`

#### 사용법 변경

**초등학교 고학년:**
```dart
// 기존
import 'package:math_escape/widgets/elementary_high_hint_popup.dart';
HintDialog(hintTitle: '힌트', hintContent: '내용')

// 새로운
import 'package:math_escape/widgets/common/common_hint_popup.dart';
ElementaryHighHintPopup(hintTitle: '힌트', hintContent: '내용')
```

**중학교:**
```dart
// 기존
import 'package:math_escape/widgets/middle_hint_popup.dart';
HintDialog(hintTitle: '힌트', hintContent: '내용', onConfirm: () {})

// 새로운
import 'package:math_escape/widgets/common/common_hint_popup.dart';
MiddleHintPopup(hintTitle: '힌트', hintContent: '내용', onConfirm: () {})
```

### 새로운 공통 위젯 사용법

#### 버튼 위젯
```dart
import 'package:math_escape/widgets/common/common_button.dart';

// QR 스캔 버튼
QRScanButton(
  onPressed: () => _scanQR(),
  text: 'QR코드 촬영',
)

// 힌트 버튼
HintButton(
  onPressed: () => _showHint(),
  text: '힌트',
)

// 답안 제출 버튼
SubmitButton(
  onPressed: () => _submitAnswer(),
  text: '답안 제출',
)
```

#### 로딩 위젯
```dart
import 'package:math_escape/widgets/common/common_loading.dart';

// 기본 로딩
CommonLoading(message: '로딩 중...')

// 전체 화면 로딩
FullScreenLoading(message: '데이터를 불러오는 중...')

// QR 스캔 로딩
QRScanLoading(message: 'QR 코드를 스캔하고 있습니다...')
```

#### 에러 위젯
```dart
import 'package:math_escape/widgets/common/common_error.dart';

// 네트워크 에러
NetworkError(
  onRetry: () => _retry(),
  message: '인터넷 연결을 확인해주세요.',
)

// QR 스캔 에러
QRScanError(
  onRetry: () => _retryScan(),
  message: 'QR 코드를 인식할 수 없습니다.',
)

// 권한 에러
PermissionError(
  onRetry: () => _requestPermission(),
  message: '카메라 권한이 필요합니다.',
)
```

## 마이그레이션 단계

### 1단계: 기존 위젯 사용처 찾기
```bash
# AnswerPopup 사용처 찾기
grep -r "AnswerPopup" lib/
grep -r "HintDialog" lib/
```

### 2단계: import 경로 변경
모든 파일에서 기존 import를 새로운 경로로 변경

### 3단계: 위젯 사용법 변경
기존 위젯 사용법을 새로운 공통 위젯 사용법으로 변경

### 4단계: 테스트
변경된 위젯들이 정상적으로 작동하는지 테스트

### 5단계: 기존 파일 삭제
마이그레이션이 완료되면 기존 중복 파일들 삭제

## 주의사항

1. **기존 호환성**: `BasicAnswerPopup`은 기존 `AnswerPopup`과 동일한 인터페이스를 제공
2. **점진적 마이그레이션**: 한 번에 모든 파일을 변경하지 말고 단계적으로 진행
3. **테스트**: 각 단계마다 테스트를 수행하여 기능이 정상 작동하는지 확인
4. **스타일 일관성**: 새로운 공통 위젯을 사용하여 일관된 UI/UX 제공
