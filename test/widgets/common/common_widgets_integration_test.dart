import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/widgets/common/common_answer_popup.dart';
import 'package:math_escape/widgets/common/common_hint_popup.dart';
import 'package:math_escape/widgets/common/common_button.dart';
import 'package:math_escape/widgets/common/common_loading.dart';
import 'package:math_escape/widgets/common/common_error.dart';

void main() {
  group('Common Widgets Integration Tests', () {
    testWidgets('AnswerPopup과 HintPopup이 순차적으로 사용되는 시나리오 테스트', (
      WidgetTester tester,
    ) async {
      bool answerCallbackCalled = false;
      bool hintCallbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CommonAnswerPopup(
                          isCorrect: true,
                          onNext: () {
                            answerCallbackCalled = true;
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: Text('Show Answer Dialog'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CommonHintPopup(
                          hintTitle: '힌트',
                          hintContent: '이것은 힌트입니다.',
                          onConfirm: () {
                            hintCallbackCalled = true;
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: Text('Show Hint Dialog'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // AnswerPopup 테스트
      await tester.tap(find.text('Show Answer Dialog'));
      await tester.pumpAndSettle();
      expect(find.text('정답'), findsOneWidget);
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();
      expect(answerCallbackCalled, true);

      // HintPopup 테스트
      await tester.tap(find.text('Show Hint Dialog'));
      await tester.pumpAndSettle();
      expect(find.text('힌트'), findsOneWidget);
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();
      expect(hintCallbackCalled, true);
    });

    testWidgets('CommonButton과 CommonLoading이 함께 사용되는 시나리오 테스트', (
      WidgetTester tester,
    ) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CommonButton(
                    text: '테스트 버튼',
                    onPressed: () {
                      buttonPressed = true;
                    },
                  ),
                  SizedBox(height: 20),
                  CommonLoading(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('테스트 버튼'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.text('테스트 버튼'));
      await tester.pump();
      expect(buttonPressed, true);
    });

    testWidgets('CommonError와 CommonButton이 함께 사용되는 시나리오 테스트', (
      WidgetTester tester,
    ) async {
      bool retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CommonError(
                    message: '네트워크 오류가 발생했습니다.',
                    onRetry: () {
                      retryCalled = true;
                    },
                  ),
                  SizedBox(height: 20),
                  CommonButton(
                    text: '새로고침',
                    onPressed: () {
                      retryCalled = true;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('네트워크 오류가 발생했습니다.'), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
      expect(find.text('새로고침'), findsOneWidget);

      await tester.tap(find.text('다시 시도'));
      await tester.pump();
      expect(retryCalled, true);
    });

    testWidgets('다양한 CommonButton 타입들이 함께 사용되는 시나리오 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  QRScanButton(onPressed: () {}),
                  SizedBox(height: 10),
                  HintButton(onPressed: () {}),
                  SizedBox(height: 10),
                  SubmitButton(text: '제출', onPressed: () {}),
                  SizedBox(height: 10),
                  NextButton(onPressed: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      // 각 버튼의 텍스트 확인
      expect(find.text('QR 스캔'), findsOneWidget);
      expect(find.text('힌트'), findsOneWidget);
      expect(find.text('제출'), findsOneWidget);
      expect(find.text('다음'), findsOneWidget);
    });

    testWidgets('다양한 CommonLoading 타입들이 함께 사용되는 시나리오 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  CommonLoading(),
                  SizedBox(height: 20),
                  ButtonLoading(),
                  SizedBox(height: 20),
                  QRScanLoading(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('다양한 CommonError 타입들이 함께 사용되는 시나리오 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  NetworkError(onRetry: () {}),
                  SizedBox(height: 20),
                  QRScanError(onRetry: () {}),
                  SizedBox(height: 20),
                  PermissionError(onRetry: () {}),
                  SizedBox(height: 20),
                  DataLoadError(onRetry: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      // 각 에러 타입의 메시지 확인
      expect(find.text('네트워크 연결을 확인해주세요'), findsOneWidget);
      expect(find.text('QR 코드를 인식할 수 없습니다'), findsOneWidget);
      expect(find.text('카메라 권한이 필요합니다'), findsOneWidget);
      expect(find.text('데이터를 불러올 수 없습니다'), findsOneWidget);
    });

    testWidgets('전체 위젯들이 실제 앱 시나리오에서 사용되는 통합 테스트', (WidgetTester tester) async {
      bool qrScanPressed = false;
      bool hintPressed = false;
      bool submitPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Builder(
                builder: (context) => Column(
                  children: [
                    // QR 스캔 버튼
                    QRScanButton(
                      onPressed: () {
                        qrScanPressed = true;
                      },
                    ),
                    SizedBox(height: 10),
                    // 힌트 버튼
                    HintButton(
                      onPressed: () {
                        hintPressed = true;
                        showDialog(
                          context: context,
                          builder: (context) => CommonHintPopup(
                            hintTitle: '힌트',
                            hintContent: '이것은 통합 테스트 힌트입니다.',
                            onConfirm: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    // 제출 버튼
                    SubmitButton(
                      text: '답안 제출',
                      onPressed: () {
                        submitPressed = true;
                        showDialog(
                          context: context,
                          builder: (context) => CommonAnswerPopup(
                            isCorrect: true,
                            onNext: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    // 로딩 표시
                    CommonLoading(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // QR 스캔 버튼 테스트
      await tester.tap(find.text('QR 스캔'));
      await tester.pump();
      expect(qrScanPressed, true);

      // 힌트 버튼 테스트
      await tester.tap(find.text('힌트'));
      await tester.pumpAndSettle();
      expect(hintPressed, true);
      expect(find.text('힌트'), findsOneWidget);
      expect(find.text('이것은 통합 테스트 힌트입니다.'), findsOneWidget);
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // 제출 버튼 테스트
      await tester.tap(find.text('답안 제출'));
      await tester.pumpAndSettle();
      expect(submitPressed, true);
      expect(find.text('정답'), findsOneWidget);
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // 로딩 표시 확인
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
