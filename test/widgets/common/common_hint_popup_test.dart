import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/widgets/common/common_hint_popup.dart';

void main() {
  group('CommonHintPopup Tests', () {
    testWidgets('기본 힌트 팝업이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonHintPopup(hintTitle: '힌트', hintContent: '이것은 힌트입니다.'),
          ),
        ),
      );

      expect(find.text('힌트'), findsOneWidget);
      expect(find.text('이것은 힌트입니다.'), findsOneWidget);
      expect(find.text('확인'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // 기본 아이콘
    });

    testWidgets('커스텀 아이콘 에셋이 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonHintPopup(
              hintTitle: '힌트',
              hintContent: '이것은 힌트입니다.',
              iconAsset: 'assets/images/hint_puri.png',
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.text('힌트'), findsOneWidget);
    });

    testWidgets('커스텀 아이콘 데이터가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonHintPopup(
              hintTitle: '힌트',
              hintContent: '이것은 힌트입니다.',
              iconData: Icons.lightbulb,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lightbulb), findsOneWidget);
      expect(find.text('힌트'), findsOneWidget);
    });

    testWidgets('버튼 클릭 시 onConfirm 콜백이 호출되는지 테스트', (WidgetTester tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonHintPopup(
              hintTitle: '힌트',
              hintContent: '이것은 힌트입니다.',
              onConfirm: () {
                callbackCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      expect(callbackCalled, true);
    });

    testWidgets('onConfirm이 null일 때 Navigator.pop만 호출되는지 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonHintPopup(hintTitle: '힌트', hintContent: '이것은 힌트입니다.'),
          ),
        ),
      );

      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // Navigator.pop이 호출되어 화면이 닫혀야 함
      expect(find.byType(CommonHintPopup), findsNothing);
    });

    testWidgets('커스텀 버튼 텍스트가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonHintPopup(
              hintTitle: '힌트',
              hintContent: '이것은 힌트입니다.',
              buttonText: '닫기',
            ),
          ),
        ),
      );

      expect(find.text('닫기'), findsOneWidget);
    });
  });

  group('ElementaryHighHintPopup Tests', () {
    testWidgets('초등학교 고학년용 힌트 팝업이 올바르게 렌더링되는지 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElementaryHighHintPopup(
              hintTitle: '힌트',
              hintContent: '이것은 힌트입니다.',
            ),
          ),
        ),
      );

      expect(find.text('힌트'), findsOneWidget);
      expect(find.text('이것은 힌트입니다.'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // hint_puri.png
    });
  });

  group('MiddleHintPopup Tests', () {
    testWidgets('중학교용 힌트 팝업이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MiddleHintPopup(
              hintTitle: '힌트',
              hintContent: '이것은 힌트입니다.',
              onConfirm: () {},
            ),
          ),
        ),
      );

      expect(find.text('힌트'), findsOneWidget);
      expect(find.text('이것은 힌트입니다.'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget); // bulb.png
    });
  });

  group('BasicHintPopup Tests', () {
    testWidgets('기본 힌트 팝업이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BasicHintPopup(
              hintTitle: '힌트',
              hintContent: '이것은 힌트입니다.',
              onConfirm: () {},
            ),
          ),
        ),
      );

      expect(find.text('힌트'), findsOneWidget);
      expect(find.text('이것은 힌트입니다.'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
    });
  });
}
