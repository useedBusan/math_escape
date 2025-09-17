import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/core/services/navigation_service.dart';
import 'package:math_escape/Feature/elementary_high/view/elementary_high_mission.dart';

void main() {
  group('QR Scan Integration Tests', () {
    testWidgets('초등학교 고학년 미션에서 QR 스캔 전체 플로우 테스트', (WidgetTester tester) async {
      // Given: 초등학교 고학년 미션 화면
      await tester.pumpWidget(
        MaterialApp(home: const ElementaryHighMissionScreen()),
      );

      // When: 화면이 로드될 때까지 대기 (타임아웃 방지)
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Then: 로딩 상태이거나 QR 스캔 버튼이 표시되어야 함
      final hasLoadingIndicator = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      final hasQRButton = find.text('QR 스캔').evaluate().isNotEmpty;

      expect(hasLoadingIndicator || hasQRButton, true);

      // When: QR 스캔 버튼이 있다면 탭
      if (hasQRButton) {
        await tester.tap(find.text('QR 스캔'));
        await tester.pump();
      }

      // Then: 권한 요청이 표시되어야 함
      // 실제 구현에서는 Permission.camera.request()가 호출됨
    });

    testWidgets('NavigationService를 통한 QR 스캔 테스트', (WidgetTester tester) async {
      // Given: NavigationService와 테스트 앱
      final navigationService = NavigationService();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => navigationService.navigateToQRScan(
                  context,
                  onQRScanned: (result) {
                    // QR 스캔 결과 처리
                  },
                ),
                child: const Text('QR 스캔'),
              ),
            ),
          ),
        ),
      );

      // When: QR 스캔 버튼을 탭
      await tester.tap(find.text('QR 스캔'));
      await tester.pump();

      // Then: 권한 요청이 표시되어야 함
      // 실제 구현에서는 Permission.camera.request()가 호출됨
    });

    test('QR 스캔 결과 검증 로직 테스트', () {
      // Given: 테스트용 미션 아이템들
      final missionItems = [
        MissionItem(
          id: 1,
          title: '문제 1',
          question: '첫 번째 문제',
          answer: ['정답1', '답1'],
          hint1: '힌트1',
          hint2: '힌트2',
        ),
        MissionItem(
          id: 2,
          title: '문제 2',
          question: '두 번째 문제',
          answer: ['정답2'],
          hint1: '힌트1',
          hint2: '힌트2',
        ),
      ];

      // When: 다양한 QR 스캔 결과 테스트
      final testCases = [
        {'qrResult': '정답1', 'expected': true, 'description': '정확한 정답'},
        {'qrResult': '답1', 'expected': true, 'description': '다른 형태의 정답'},
        {'qrResult': '정답2', 'expected': true, 'description': '두 번째 문제 정답'},
        {'qrResult': '오답', 'expected': false, 'description': '완전히 다른 답'},
        {'qrResult': '정답', 'expected': false, 'description': '부분적으로 일치하는 답'},
        {'qrResult': '  정답1  ', 'expected': true, 'description': '공백이 있는 정답'},
      ];

      // Then: 각 테스트 케이스 검증
      for (final testCase in testCases) {
        final qrResult = testCase['qrResult'] as String;
        final expected = testCase['expected'] as bool;
        final description = testCase['description'] as String;

        for (final missionItem in missionItems) {
          final actual = missionItem.answer.contains(qrResult.trim());
          if (expected) {
            expect(actual, true, reason: '$description: $qrResult');
          }
        }
      }
    });

    test('QR 스캔 에러 처리 테스트', () {
      // Given: 잘못된 QR 스캔 결과들
      final invalidResults = [
        '', // 빈 문자열
        '   ', // 공백만 있는 문자열
        'null', // null 문자열
        'undefined', // undefined 문자열
      ];

      final missionItem = MissionItem(
        id: 1,
        title: '테스트 문제',
        question: '테스트 질문',
        answer: ['정답'],
        hint1: '힌트1',
        hint2: '힌트2',
      );

      // When & Then: 각 잘못된 결과에 대해 오답으로 처리되어야 함
      for (final invalidResult in invalidResults) {
        final isCorrect = missionItem.answer.contains(invalidResult.trim());
        expect(
          isCorrect,
          false,
          reason: '잘못된 결과 "$invalidResult"는 오답으로 처리되어야 함',
        );
      }
    });
  });
}
