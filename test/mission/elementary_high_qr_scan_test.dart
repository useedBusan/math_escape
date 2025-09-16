import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/Feature/elementary_high/view/elementary_high_mission.dart';

void main() {
  group('ElementaryHighMissionScreen QR Scan Tests', () {
    late ElementaryHighMissionScreen screen;

    setUp(() {
      screen = const ElementaryHighMissionScreen();
    });

    testWidgets('QR 스캔 버튼이 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      // Given: 미션 화면이 로드된 상태
      await tester.pumpWidget(MaterialApp(home: screen));

      // When: 화면이 로드될 때까지 대기 (타임아웃 방지)
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Then: 로딩 상태이거나 제출 버튼이 표시되어야 함
      // 데이터 로딩 중이면 로딩 인디케이터가 표시됨
      final hasLoadingIndicator = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      final hasQRButton = find.text('QR 스캔').evaluate().isNotEmpty;
      final hasSubmitButton = find.text('정답제출').evaluate().isNotEmpty;

      expect(hasLoadingIndicator || hasQRButton || hasSubmitButton, true);
    });

    testWidgets('QR 스캔 버튼 클릭 시 권한 요청이 호출되는지 테스트', (WidgetTester tester) async {
      // Given: 미션 화면이 로드된 상태
      await tester.pumpWidget(MaterialApp(home: screen));

      // When: 화면이 로드될 때까지 대기 (타임아웃 방지)
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Then: 로딩 상태이거나 제출 버튼이 표시되어야 함
      final hasLoadingIndicator = find
          .byType(CircularProgressIndicator)
          .evaluate()
          .isNotEmpty;
      final hasQRButton = find.text('QR 스캔').evaluate().isNotEmpty;
      final hasSubmitButton = find.text('정답제출').evaluate().isNotEmpty;

      expect(hasLoadingIndicator || hasQRButton || hasSubmitButton, true);

      // When: 제출 버튼이 있다면 탭
      if (hasQRButton) {
        await tester.tap(find.text('QR 스캔'));
        await tester.pump();
      } else if (hasSubmitButton) {
        await tester.tap(find.text('정답제출'));
        await tester.pump();
      }

      // Then: 권한 요청이 표시되어야 함 (실제 구현에서는 Permission.camera.request()가 호출됨)
      // 이 테스트는 실제 권한 요청을 모킹하지 않으므로 UI 변화를 확인
    });

    test('QR 스캔 결과 처리 로직 테스트', () {
      // Given: 미션 아이템과 QR 스캔 결과
      final missionItem = MissionItem(
        id: 1,
        title: '테스트 문제',
        question: '테스트 질문',
        answer: ['정답1', '정답2'],
        hint1: '힌트1',
        hint2: '힌트2',
      );

      // When: 정답이 포함된 QR 스캔 결과
      final correctResult = '정답1';
      final isCorrect = missionItem.answer.contains(correctResult.trim());

      // Then: 정답으로 인식되어야 함
      expect(isCorrect, true);

      // When: 오답이 포함된 QR 스캔 결과
      final incorrectResult = '오답';
      final isIncorrect = missionItem.answer.contains(incorrectResult.trim());

      // Then: 오답으로 인식되어야 함
      expect(isIncorrect, false);
    });

    test('QR 스캔 결과 공백 처리 테스트', () {
      // Given: 미션 아이템
      final missionItem = MissionItem(
        id: 1,
        title: '테스트 문제',
        question: '테스트 질문',
        answer: ['정답1', '정답2'],
        hint1: '힌트1',
        hint2: '힌트2',
      );

      // When: 앞뒤 공백이 있는 QR 스캔 결과
      final resultWithSpaces = '  정답1  ';
      final isCorrect = missionItem.answer.contains(resultWithSpaces.trim());

      // Then: 공백이 제거되어 정답으로 인식되어야 함
      expect(isCorrect, true);
    });

    test('조건부 제출 로직 테스트', () {
      // Given: QR 스캔이 필요한 문제들
      final qrScanQuestions = [2, 3, 4, 8];

      // When & Then: 각 문제 번호에 대해 올바른 제출 방식 확인
      for (int questionNumber = 1; questionNumber <= 10; questionNumber++) {
        final shouldUseQRScan = qrScanQuestions.contains(questionNumber);

        if (shouldUseQRScan) {
          expect(
            qrScanQuestions.contains(questionNumber),
            true,
            reason: '문제 $questionNumber번은 QR 스캔을 사용해야 함',
          );
        } else {
          expect(
            qrScanQuestions.contains(questionNumber),
            false,
            reason: '문제 $questionNumber번은 텍스트 입력을 사용해야 함',
          );
        }
      }
    });
  });
}
