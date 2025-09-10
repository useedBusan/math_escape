import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/widgets/common/common_button.dart';

void main() {
  group('CommonButton Tests', () {
    testWidgets('기본 버튼이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonButton(text: '테스트 버튼', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('테스트 버튼'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('버튼 클릭 시 onPressed 콜백이 호출되는지 테스트', (WidgetTester tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonButton(
              text: '테스트 버튼',
              onPressed: () {
                callbackCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('테스트 버튼'));
      await tester.pumpAndSettle();

      expect(callbackCalled, true);
    });

    testWidgets('onPressed가 null일 때 버튼이 비활성화되는지 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CommonButton(text: '테스트 버튼')),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('로딩 상태일 때 CircularProgressIndicator가 표시되는지 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonButton(
              text: '테스트 버튼',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('테스트 버튼'), findsNothing);
    });

    testWidgets('아이콘이 있는 버튼이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonButton(
              text: '테스트 버튼',
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.text('테스트 버튼'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('커스텀 스타일이 올바르게 적용되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonButton(
              text: '테스트 버튼',
              onPressed: () {},
              backgroundColor: Colors.red,
              textColor: Colors.white,
              width: 200,
              height: 50,
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final buttonStyle = button.style;

      expect(buttonStyle?.backgroundColor?.resolve({}), Colors.red);
      expect(buttonStyle?.foregroundColor?.resolve({}), Colors.white);
    });
  });

  group('QRScanButton Tests', () {
    testWidgets('QR 스캔 버튼이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QRScanButton(onPressed: () {})),
        ),
      );

      expect(find.text('QR코드 촬영'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    });

    testWidgets('커스텀 텍스트가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QRScanButton(text: 'QR 스캔', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('QR 스캔'), findsOneWidget);
    });

    testWidgets('로딩 상태일 때 로딩 인디케이터가 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QRScanButton(onPressed: () {}, isLoading: true)),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('HintButton Tests', () {
    testWidgets('힌트 버튼이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: HintButton(onPressed: () {})),
        ),
      );

      expect(find.text('힌트'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
    });
  });

  group('SubmitButton Tests', () {
    testWidgets('답안 제출 버튼이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SubmitButton(onPressed: () {})),
        ),
      );

      expect(find.text('답안 제출'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('NextButton Tests', () {
    testWidgets('다음 버튼이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NextButton(onPressed: () {})),
        ),
      );

      expect(find.text('다음'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });
  });
}
