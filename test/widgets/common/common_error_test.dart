import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/widgets/common/common_error.dart';

void main() {
  group('CommonError Tests', () {
    testWidgets('기본 에러가 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CommonError(message: '오류가 발생했습니다.')),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('오류가 발생했습니다'), findsOneWidget);
      expect(find.text('오류가 발생했습니다.'), findsOneWidget);
    });

    testWidgets('재시도 버튼이 있는 에러가 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonError(message: '오류가 발생했습니다.', onRetry: () {}),
          ),
        ),
      );

      expect(find.text('오류가 발생했습니다.'), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
    });

    testWidgets('재시도 버튼 클릭 시 onRetry 콜백이 호출되는지 테스트', (
      WidgetTester tester,
    ) async {
      bool callbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonError(
              message: '오류가 발생했습니다.',
              onRetry: () {
                callbackCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('다시 시도'));
      await tester.pumpAndSettle();

      expect(callbackCalled, true);
    });

    testWidgets('커스텀 아이콘이 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonError(message: '오류가 발생했습니다.', icon: Icons.warning),
          ),
        ),
      );

      expect(find.byIcon(Icons.warning), findsOneWidget);
    });

    testWidgets('커스텀 재시도 텍스트가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonError(
              message: '오류가 발생했습니다.',
              onRetry: () {},
              retryText: '재시작',
            ),
          ),
        ),
      );

      expect(find.text('재시작'), findsOneWidget);
    });
  });

  group('NetworkError Tests', () {
    testWidgets('네트워크 에러가 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: NetworkError())),
      );

      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
      expect(find.text('네트워크 연결을 확인해주세요.'), findsOneWidget);
    });

    testWidgets('커스텀 메시지가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NetworkError(message: '인터넷 연결을 확인해주세요.')),
        ),
      );

      expect(find.text('인터넷 연결을 확인해주세요.'), findsOneWidget);
    });

    testWidgets('재시도 버튼이 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NetworkError(onRetry: () {})),
        ),
      );

      expect(find.text('다시 시도'), findsOneWidget);
    });
  });

  group('QRScanError Tests', () {
    testWidgets('QR 스캔 에러가 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: QRScanError())));

      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      expect(find.text('QR 코드를 인식할 수 없습니다.'), findsOneWidget);
      expect(find.text('다시 스캔'), findsOneWidget);
    });

    testWidgets('커스텀 메시지가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: QRScanError(message: 'QR 코드가 손상되었습니다.')),
        ),
      );

      expect(find.text('QR 코드가 손상되었습니다.'), findsOneWidget);
    });
  });

  group('PermissionError Tests', () {
    testWidgets('권한 에러가 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: PermissionError())),
      );

      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.text('카메라 권한이 필요합니다.'), findsOneWidget);
      expect(find.text('권한 설정'), findsOneWidget);
    });

    testWidgets('커스텀 메시지가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: PermissionError(message: '마이크 권한이 필요합니다.')),
        ),
      );

      expect(find.text('마이크 권한이 필요합니다.'), findsOneWidget);
    });
  });

  group('DataLoadError Tests', () {
    testWidgets('데이터 로딩 에러가 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: DataLoadError())),
      );

      expect(find.byIcon(Icons.data_usage), findsOneWidget);
      expect(find.text('데이터를 불러올 수 없습니다.'), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
    });

    testWidgets('커스텀 메시지가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: DataLoadError(message: '서버에서 데이터를 가져올 수 없습니다.')),
        ),
      );

      expect(find.text('서버에서 데이터를 가져올 수 없습니다.'), findsOneWidget);
    });
  });
}
