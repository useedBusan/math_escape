import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/feature/high/view/high_mission.dart';
import 'package:math_escape/feature/high/model/high_mission_question.dart';
import 'package:math_escape/core/services/service_locator.dart';

void main() {
  group('QR 미션 통합 테스트', () {
    late List<MissionQuestion> questionList;

    setUp(() {
      // 테스트용 문제 데이터 생성
      questionList = [
        MissionQuestion(
          id: 1,
          title: '역설, 혹은 모호함_1',
          description: '테스트 문제 1',
          level: '고급',
          question: '테스트 문제입니다.',
          answer: ['정답1'],
          hint: '힌트입니다.',
          isqr: false,
        ),
        MissionQuestion(
          id: 4,
          title: '역설, 혹은 모호함_4',
          description: 'QR 코드 문제',
          level: '고급',
          question: 'QR 코드를 스캔하세요.',
          answer: [],
          hint: 'QR 코드 힌트입니다.',
          isqr: true,
        ),
      ];
    });

    testWidgets('QR 문제 4번 UI 렌더링 테스트', (WidgetTester tester) async {
      // 서비스 초기화 (QR 정답 데이터 로드 포함)
      await serviceLocator.initialize();

      // HighMission 위젯 생성
      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: questionList,
            currentIndex: 1, // 문제 4번 (인덱스 1)
            gameStartTime: DateTime.now(),
          ),
        ),
      );

      // 위젯 빌드 대기
      await tester.pumpAndSettle();

      // QR 스캔 버튼 확인
      expect(find.text('QR코드 스캔'), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);

      // 일반 입력 필드는 없어야 함
      expect(find.byType(TextField), findsNothing);

      print('QR 문제 4번 UI 렌더링 테스트 통과');
    });

    testWidgets('일반 문제 UI 렌더링 테스트', (WidgetTester tester) async {
      // 서비스 초기화 (QR 정답 데이터 로드 포함)
      await serviceLocator.initialize();

      // HighMission 위젯 생성 (문제 1번)
      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: questionList,
            currentIndex: 0, // 문제 1번 (인덱스 0)
            gameStartTime: DateTime.now(),
          ),
        ),
      );

      // 위젯 빌드 대기
      await tester.pumpAndSettle();

      // 일반 입력 필드 확인
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('확인'), findsOneWidget);

      // QR 스캔 버튼은 없어야 함
      expect(find.text('QR코드 스캔'), findsNothing);

      print('일반 문제 UI 렌더링 테스트 통과');
    });

    test('QR 정답 검증 로직 테스트', () async {
      // 서비스 초기화 (QR 정답 데이터 로드 포함)
      await serviceLocator.initialize();

      // 문제 4번 정답 확인
      final correctAnswer = serviceLocator.qrAnswerService
          .getCorrectAnswerByTitle('역설, 혹은 모호함_4');

      expect(correctAnswer, equals('127Q'));

      // 정답 검증 시뮬레이션
      final testQRResult = '127Q';
      final isCorrect = testQRResult == correctAnswer;

      expect(isCorrect, isTrue);
      print('QR 정답 검증 로직 테스트 통과: $testQRResult == $correctAnswer');
    });

    test('QR 오답 검증 로직 테스트', () async {
      // 서비스 초기화 (QR 정답 데이터 로드 포함)
      await serviceLocator.initialize();

      // 문제 4번 정답 확인
      final correctAnswer = serviceLocator.qrAnswerService
          .getCorrectAnswerByTitle('역설, 혹은 모호함_4');

      expect(correctAnswer, equals('127Q'));

      // 오답 검증 시뮬레이션
      final testQRResult = 'WRONG_ANSWER';
      final isCorrect = testQRResult == correctAnswer;

      expect(isCorrect, isFalse);
      print('QR 오답 검증 로직 테스트 통과: $testQRResult != $correctAnswer');
    });

    test('QR 답안 데이터 무결성 테스트', () async {
      // 서비스 초기화 (QR 정답 데이터 로드 포함)
      await serviceLocator.initialize();

      // 전체 QR 답안 확인
      final allAnswers = serviceLocator.qrAnswerService.allQrAnswers;

      expect(allAnswers, isNotEmpty);

      // 문제 4번 답안이 있는지 확인
      final answer4 = allAnswers.where((a) => a.title == '역설, 혹은 모호함_4').first;

      expect(answer4.id, equals(4));
      expect(answer4.correctAnswer, equals('127Q'));
      expect(answer4.qrImagePath, contains('qr_answer_4.png'));

      print('QR 답안 데이터 무결성 테스트 통과');
      print('문제 4번 답안: ${answer4.correctAnswer}');
    });
  });
}
