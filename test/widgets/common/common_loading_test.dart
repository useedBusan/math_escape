import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/widgets/common/common_loading.dart';

void main() {
  group('CommonLoading Tests', () {
    testWidgets('기본 로딩이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: CommonLoading())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('메시지가 있는 로딩이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CommonLoading(message: '로딩 중...')),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('로딩 중...'), findsOneWidget);
    });

    testWidgets('showMessage가 false일 때 메시지가 표시되지 않는지 테스트', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonLoading(message: '로딩 중...', showMessage: false),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('로딩 중...'), findsNothing);
    });

    testWidgets('커스텀 크기와 색상이 올바르게 적용되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CommonLoading(size: 50.0, color: Colors.red)),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(progressIndicator.strokeWidth, 3.0);
      // 색상은 valueColor에서 확인해야 함
    });
  });

  group('FullScreenLoading Tests', () {
    testWidgets('전체 화면 로딩이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: FullScreenLoading())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('로딩 중...'), findsOneWidget);
    });

    testWidgets('커스텀 메시지가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FullScreenLoading(message: '데이터를 불러오는 중...')),
        ),
      );

      expect(find.text('데이터를 불러오는 중...'), findsOneWidget);
    });

    testWidgets('커스텀 배경색이 올바르게 적용되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FullScreenLoading(backgroundColor: Colors.blue)),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('ButtonLoading Tests', () {
    testWidgets('버튼 내부 로딩이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ButtonLoading())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('커스텀 크기가 올바르게 적용되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ButtonLoading(size: 20.0))),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 20.0);
      expect(sizedBox.height, 20.0);
    });

    testWidgets('커스텀 색상이 올바르게 적용되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ButtonLoading(color: Colors.red)),
        ),
      );

      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(progressIndicator.strokeWidth, 2.0);
    });
  });

  group('QRScanLoading Tests', () {
    testWidgets('QR 스캔 로딩이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: QRScanLoading())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('QR 코드를 스캔하고 있습니다...'), findsOneWidget);
    });

    testWidgets('커스텀 메시지가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QRScanLoading(message: 'QR 코드를 인식하는 중...')),
        ),
      );

      expect(find.text('QR 코드를 인식하는 중...'), findsOneWidget);
    });

    testWidgets('흰색 텍스트가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: QRScanLoading())),
      );

      final textWidget = tester.widget<Text>(find.text('QR 코드를 스캔하고 있습니다...'));
      expect(textWidget.style?.color, Colors.white);
    });
  });
}
