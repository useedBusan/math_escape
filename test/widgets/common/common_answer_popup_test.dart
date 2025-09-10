import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/widgets/common/common_answer_popup.dart';

void main() {
  group('CommonAnswerPopup Tests', () {
    testWidgets('정답 팝업이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        CommonAnswerPopup(isCorrect: true, onNext: () {}),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('정답'), findsOneWidget);
      expect(find.text('입니다!'), findsOneWidget);
      expect(find.text('조금만 더 풀면 탈출할 수 있어요!'), findsOneWidget);
      expect(find.text('다음'), findsOneWidget);
    });

    testWidgets('오답 팝업이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        CommonAnswerPopup(isCorrect: false, onNext: () {}),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.text('오답'), findsOneWidget);
      expect(find.text('입니다.'), findsOneWidget);
      expect(find.text('다시 한번 생각해 볼까요?'), findsOneWidget);
      expect(find.text('확인'), findsOneWidget);
    });

    testWidgets('커스텀 제목과 메시지가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CommonAnswerPopup(
                      isCorrect: true,
                      customTitle: '맞습니다!',
                      customMessage: '훌륭해요!',
                      onNext: () {},
                    ),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('맞습니다!'), findsOneWidget);
      expect(find.text('훌륭해요!'), findsOneWidget);
    });

    testWidgets('버튼 클릭 시 onNext 콜백이 호출되는지 테스트', (WidgetTester tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CommonAnswerPopup(
                      isCorrect: true,
                      onNext: () {
                        callbackCalled = true;
                      },
                    ),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(callbackCalled, true);
    });

    testWidgets('onNext가 null일 때 Navigator.pop이 호출되는지 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CommonAnswerPopup(isCorrect: true),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // Navigator.pop이 호출되어 화면이 닫혀야 함
      expect(find.byType(CommonAnswerPopup), findsNothing);
    });

    testWidgets('showNextButton이 false일 때 버튼이 표시되지 않는지 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CommonAnswerPopup(
                      isCorrect: true,
                      showNextButton: false,
                    ),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('다음'), findsNothing);
      expect(find.text('확인'), findsNothing);
    });
  });

  group('ElementaryHighAnswerPopup Tests', () {
    testWidgets('초등학교 고학년용 팝업이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ElementaryHighAnswerPopup(
                      isCorrect: true,
                      onNext: () {},
                    ),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('정답'), findsOneWidget);
      expect(find.text('보물에 한 걸음 더 가까워졌어!'), findsOneWidget);
    });
  });

  group('MiddleAnswerPopup Tests', () {
    testWidgets('중학교용 팝업이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        MiddleAnswerPopup(isCorrect: true, onNext: () {}),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('정답'), findsOneWidget);
      expect(find.text('조금만 더 풀면 탈출할 수 있어요!'), findsOneWidget);
    });
  });

  group('BasicAnswerPopup Tests', () {
    testWidgets('기본 팝업이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => BasicAnswerPopup(isCorrect: true),
                  );
                },
                child: Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // 다이얼로그 표시
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('정답입니다!'), findsOneWidget);
      expect(find.text('조금만 더 풀면 탈출할 수 있어요!'), findsOneWidget);
      expect(find.text('다음'), findsNothing);
      expect(find.text('확인'), findsNothing);
    });
  });
}
