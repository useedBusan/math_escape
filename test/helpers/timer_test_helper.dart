import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:fake_async/fake_async.dart';

/// Timer 관련 테스트를 위한 헬퍼 함수들
class TimerTestHelper {
  /// Timer가 포함된 위젯을 안전하게 테스트하는 함수
  static Future<void> pumpWithTimer(
    WidgetTester tester, {
    Duration? duration,
    int? pumpCount,
  }) async {
    await tester.pump();

    if (duration != null) {
      await tester.pump(duration);
    }

    if (pumpCount != null) {
      for (int i = 0; i < pumpCount; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    // 10초 타이머로 제한
    await tester.pump(const Duration(seconds: 10));
  }

  /// 위젯을 안전하게 정리하는 함수
  static Future<void> disposeWidgetSafely(WidgetTester tester) async {
    // 위젯 트리 정리
    await tester.pumpAndSettle();

    // 추가 대기 시간으로 Timer 정리 보장
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Timer를 안전하게 처리하는 테스트 래퍼
  static Future<T> runWithTimerControl<T>(
    Future<T> Function() testFunction,
  ) async {
    try {
      return await testFunction();
    } finally {
      // 테스트 완료 후 추가 정리 시간
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  /// Timer가 실행되는 동안 여러 번 pump하는 함수
  static Future<void> pumpMultipleTimes(
    WidgetTester tester, {
    int times = 5,
    Duration interval = const Duration(milliseconds: 200),
  }) async {
    for (int i = 0; i < times; i++) {
      await tester.pump(interval);
    }
    await tester.pumpAndSettle();
  }

  /// Timer 관련 위젯의 상태를 안전하게 검증하는 함수
  static Future<void> verifyTimerWidget(
    WidgetTester tester, {
    required String expectedText,
    Duration? waitTime,
  }) async {
    if (waitTime != null) {
      await tester.pump(waitTime);
    }

    await tester.pumpAndSettle();

    // Timer 관련 텍스트가 표시되는지 확인
    expect(find.textContaining(expectedText), findsOneWidget);
  }
}

/// Timer 테스트를 위한 믹스인
mixin TimerTestMixin {
  /// Timer가 포함된 위젯 테스트를 위한 setup
  Future<void> setupTimerTest(WidgetTester tester) async {
    await tester.pump();
    await tester.pumpAndSettle();
  }

  /// Timer가 포함된 위젯 테스트를 위한 teardown
  Future<void> teardownTimerTest(WidgetTester tester) async {
    await TimerTestHelper.disposeWidgetSafely(tester);
  }
}
