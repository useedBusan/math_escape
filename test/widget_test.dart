// MathEscape 앱의 기본 위젯 테스트

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:math_escape/main.dart';
import 'helpers/timer_test_helper.dart';

void main() {
  testWidgets('MathEscape 앱이 정상적으로 시작되는지 테스트', (WidgetTester tester) async {
    // 앱을 빌드하고 프레임을 트리거합니다.
    await tester.pumpWidget(const MyApp());

    // 스플래시 화면이 표시되도록 여러 번 pump
    await TimerTestHelper.pumpWithTimer(tester, pumpCount: 3);

    // 스플래시 화면이 표시되는지 확인
    expect(find.byType(Image), findsOneWidget);
    
    // 이어폰 안내 텍스트가 표시되는지 확인
    expect(find.text('원활한 체험을 위해\n이어폰 착용을 권장드립니다'), findsOneWidget);
  });
}
