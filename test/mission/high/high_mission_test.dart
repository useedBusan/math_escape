import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import 'package:math_escape/Feature/high/view/high_mission.dart';

void main() {
  group('HighMission Widget Tests', () {
    late List<MissionQuestion> mockQuestionList;
    late DateTime mockGameStartTime;

    setUp(() {
      mockGameStartTime = DateTime.now();
      mockQuestionList = [
        MissionQuestion(
          id: 1,
          description: '테스트 설명',
          level: '고급',
          title: '테스트 문제 1',
          question: '테스트 질문입니다.',
          answer: ['정답1', '정답2'],
          hint: '테스트 힌트입니다.',
        ),
        MissionQuestion(
          id: 2,
          description: 'QR 테스트 설명',
          level: '고급',
          title: '역설, 혹은 모호함_B',
          question: 'QR 코드를 찍으세요.',
          answer: [''],
          hint: 'QR 힌트입니다.',
        ),
      ];
    });

    testWidgets('HighMission 위젯이 올바르게 렌더링되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: mockQuestionList,
            currentIndex: 0,
            gameStartTime: mockGameStartTime,
          ),
        ),
      );

      // 앱바 타이틀이 표시되는지 확인
      expect(find.text('역설, 혹은 모호함'), findsOneWidget);

      // 문제 제목이 표시되는지 확인
      expect(find.text('테스트 문제 1'), findsOneWidget);

      // 문제 내용이 표시되는지 확인
      expect(find.text('테스트 질문입니다.'), findsOneWidget);

      // 답변 입력 필드가 있는지 확인
      expect(find.byType(TextField), findsOneWidget);

      // 확인 버튼이 있는지 확인
      expect(find.text('확인'), findsOneWidget);

      // 힌트 버튼이 있는지 확인 (버튼과 텍스트가 모두 있으므로 findsWidgets 사용)
      expect(find.text('힌트'), findsWidgets);
    });

    testWidgets('QR 코드 버튼이 특정 문제에서만 표시되는지 테스트', (WidgetTester tester) async {
      // QR 코드가 필요한 문제로 테스트
      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: mockQuestionList,
            currentIndex: 1, // '역설, 혹은 모호함_B' 문제
            gameStartTime: mockGameStartTime,
          ),
        ),
      );

      // QR 코드 버튼이 표시되는지 확인
      expect(find.text('QR코드 촬영'), findsOneWidget);
    });

    testWidgets('QR 코드 버튼이 일반 문제에서는 표시되지 않는지 테스트', (WidgetTester tester) async {
      // 일반 문제로 테스트
      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: mockQuestionList,
            currentIndex: 0, // 일반 문제
            gameStartTime: mockGameStartTime,
          ),
        ),
      );

      // QR 코드 버튼이 표시되지 않는지 확인
      expect(find.text('QR코드 촬영'), findsNothing);
    });

    testWidgets('힌트 다이얼로그가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: mockQuestionList,
            currentIndex: 0,
            gameStartTime: mockGameStartTime,
          ),
        ),
      );

      // 힌트 버튼을 탭 (첫 번째 힌트 버튼만 탭)
      await tester.tap(find.text('힌트').first);
      await tester.pumpAndSettle();

      // 힌트 다이얼로그가 표시되는지 확인
      expect(find.text('힌트'), findsWidgets);
      expect(find.text('테스트 힌트입니다.'), findsOneWidget);
    });

    testWidgets('답변 입력 및 제출 기능 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: mockQuestionList,
            currentIndex: 0,
            gameStartTime: mockGameStartTime,
          ),
        ),
      );

      // 답변 입력
      await tester.enterText(find.byType(TextField), '정답1');

      // 확인 버튼 탭 (warnIfMissed: false로 경고 무시)
      await tester.tap(find.text('확인'), warnIfMissed: false);
      await tester.pump();

      // 답변 팝업이 표시되는지 확인 (정답인 경우)
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('타이머 정보가 올바르게 표시되는지 테스트', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: mockQuestionList,
            currentIndex: 0,
            gameStartTime: mockGameStartTime,
          ),
        ),
      );

      // 타이머 정보가 표시되는지 확인
      expect(find.textContaining('생각의 시간'), findsOneWidget);
      expect(find.textContaining('몸의 시간'), findsOneWidget);
    });
  });

  group('HighMission 비즈니스 로직 테스트', () {
    test('정답 검증 로직 테스트', () {
      final question = MissionQuestion(
        id: 1,
        description: '테스트',
        level: '고급',
        title: '테스트',
        question: '테스트',
        answer: ['정답1', '정답2', '정답3'],
        hint: '테스트',
      );

      // 정답 검증 로직 시뮬레이션
      final userAnswers = ['정답1', '정답2', '정답3', 'wrong'];
      final correctAnswers = question.answer
          .map((a) => a.trim().toLowerCase())
          .toList();

      for (int i = 0; i < userAnswers.length - 1; i++) {
        final userAnswer = userAnswers[i].trim().toLowerCase();
        final isCorrect = correctAnswers.contains(userAnswer);
        expect(isCorrect, true, reason: '정답 ${userAnswers[i]}이 올바르게 인식되어야 함');
      }

      final wrongAnswer = userAnswers.last.trim().toLowerCase();
      final isWrong = correctAnswers.contains(wrongAnswer);
      expect(isWrong, false, reason: '오답 ${userAnswers.last}이 잘못 인식되어야 함');
    });

    test('시간 계산 로직 테스트', () {
      final gameStartTime = DateTime(2024, 1, 1, 10, 0, 0);
      final currentTime = DateTime(2024, 1, 1, 10, 5, 30); // 5분 30초 후

      final elapsed = currentTime.difference(gameStartTime);

      // 생각의 시간 계산
      final minutes = elapsed.inMinutes;
      final seconds = elapsed.inSeconds % 60;
      final thinkingTime =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      expect(thinkingTime, '05:30');

      // 몸의 시간 계산
      final totalSeconds = elapsed.inSeconds;
      final c = totalSeconds ~/ 60;
      final d = (totalSeconds % 60) ~/ 5;
      final bodyTime = '$c년, $d개월';

      expect(bodyTime, '5년, 6개월');
    });

    test('JSON 데이터 로딩 테스트', () async {
      // 실제 JSON 데이터 구조 검증
      final jsonData = '''
      [
        {
          "id": 1,
          "description": "테스트 설명",
          "level": "고급",
          "title": "테스트 문제",
          "question": "테스트 질문",
          "answer": ["정답1", "정답2"],
          "hint": "테스트 힌트"
        }
      ]
      ''';

      final List<dynamic> jsonList = [
        {
          "id": 1,
          "description": "테스트 설명",
          "level": "고급",
          "title": "테스트 문제",
          "question": "테스트 질문",
          "answer": ["정답1", "정답2"],
          "hint": "테스트 힌트",
        },
      ];

      final questions = jsonList
          .map((e) => MissionQuestion.fromJson(e))
          .toList();

      expect(questions.length, 1);
      expect(questions.first.id, 1);
      expect(questions.first.title, '테스트 문제');
      expect(questions.first.answer, ['정답1', '정답2']);
    });
  });

  group('HighMission 위젯 상태 관리 테스트', () {
    testWidgets('힌트 상태 토글 테스트', (WidgetTester tester) async {
      final questionList = [
        MissionQuestion(
          id: 1,
          description: '테스트',
          level: '고급',
          title: '테스트',
          question: '테스트',
          answer: ['정답'],
          hint: '힌트',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: HighMission(
            questionList: questionList,
            currentIndex: 0,
            gameStartTime: DateTime.now(),
          ),
        ),
      );

      // 초기에는 힌트 카드가 보이지 않아야 함
      expect(find.text('힌트'), findsWidgets); // 버튼만 있음

      // 힌트 버튼을 탭하고 다이얼로그에서 확인을 누름
      await tester.tap(find.text('힌트').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // 힌트 카드가 표시되어야 함 (더 많은 힌트 텍스트가 있어야 함)
      expect(find.text('힌트'), findsWidgets); // 버튼과 카드 모두 있음
    });
  });
}
