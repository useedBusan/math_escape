import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/feature/high/model/high_mission_question.dart';
import 'package:math_escape/feature/high/view_model/high_mission_view_model.dart';

void main() {
  group('고등학교 힌트 시스템 테스트', () {
    late HighMissionViewModel viewModel;
    late List<MissionQuestion> testQuestions;

    setUp(() {
      viewModel = HighMissionViewModel.instance;

      // 테스트용 문제 데이터 생성
      testQuestions = [
        MissionQuestion(
          id: 1,
          level: '고급',
          title: '역설, 혹은 모호함_1',
          question: '테스트 문제 1',
          answer: ['정답1'],
          hint: '힌트 1',
          description: '설명 1',
          hintType: 'problem',
          hintTargetId: 2,
        ),
        MissionQuestion(
          id: 2,
          level: '고급',
          title: '역설, 혹은 모호함_A',
          question: '테스트 문제 2',
          answer: ['정답2'],
          hint: '힌트 2',
          description: '설명 2',
          hintType: 'popup',
        ),
        MissionQuestion(
          id: 3,
          level: '고급',
          title: '역설, 혹은 모호함_2',
          question: '테스트 문제 3',
          answer: ['정답3'],
          hint: '힌트 3',
          description: '설명 3',
          hintType: 'problem',
          hintTargetId: 14,
        ),
        MissionQuestion(
          id: 4,
          level: '고급',
          title: '역설, 혹은 모호함_3',
          question: '테스트 문제 4',
          answer: ['정답4'],
          hint: '힌트 4',
          description: '설명 4',
          hintType: 'problem',
          hintTargetId: 7,
        ),
        MissionQuestion(
          id: 7,
          level: '고급',
          title: '역설, 혹은 모호함_B',
          question: '테스트 문제 B',
          answer: ['정답B'],
          hint: '힌트 B',
          description: '설명 B',
          hintType: 'popup',
        ),
      ];

      viewModel.startGame(testQuestions);
    });

    tearDown(() {
      viewModel.resetGame();
    });

    test('문제 1번 힌트 클릭 시 문제 2번으로 이동', () {
      // Given: 문제 1번에 위치
      viewModel.goToQuestionById(1);
      expect(viewModel.currentQuestion.id, equals(1));

      // When: 힌트 클릭
      viewModel.handleHint();

      // Then: 문제 2번으로 이동
      expect(viewModel.currentQuestion.id, equals(2));
    });

    test('문제 2번 힌트 클릭 시 팝업만 표시 (이동하지 않음)', () {
      // Given: 문제 2번에 위치
      viewModel.goToQuestionById(2);
      expect(viewModel.currentQuestion.id, equals(2));

      // When: 힌트 클릭
      viewModel.handleHint();

      // Then: 문제 2번에 그대로 위치 (팝업은 외부에서 처리)
      expect(viewModel.currentQuestion.id, equals(2));
    });

    test('문제 3번 힌트 클릭 시 문제 14번으로 이동', () {
      // Given: 문제 3번에 위치
      viewModel.goToQuestionById(3);
      expect(viewModel.currentQuestion.id, equals(3));

      // When: 힌트 클릭
      viewModel.handleHint();

      // Then: 문제 14번으로 이동
      expect(viewModel.currentQuestion.id, equals(14));
    });

    test('문제 4번 힌트 클릭 시 문제 7번으로 이동', () {
      // Given: 문제 4번에 위치
      viewModel.goToQuestionById(4);
      expect(viewModel.currentQuestion.id, equals(4));

      // When: 힌트 클릭
      viewModel.handleHint();

      // Then: 문제 7번으로 이동
      expect(viewModel.currentQuestion.id, equals(7));
    });

    test('문제 B번 힌트 클릭 시 팝업만 표시 (이동하지 않음)', () {
      // Given: 문제 B번에 위치
      viewModel.goToQuestionById(7);
      expect(viewModel.currentQuestion.id, equals(7));

      // When: 힌트 클릭
      viewModel.handleHint();

      // Then: 문제 B번에 그대로 위치 (팝업은 외부에서 처리)
      expect(viewModel.currentQuestion.id, equals(7));
    });

    test('hintType이 null인 경우 기존 로직 유지', () {
      // Given: hintType이 없는 문제 생성
      final legacyQuestion = MissionQuestion(
        id: 99,
        level: '고급',
        title: '역설, 혹은 모호함_1', // 기존 특별 처리 대상
        question: '레거시 문제',
        answer: ['정답'],
        hint: '힌트',
        description: '설명',
        // hintType과 hintTargetId 없음
      );

      final legacyQuestions = [legacyQuestion];
      viewModel.startGame(legacyQuestions);

      // When: 힌트 클릭
      viewModel.handleHint();

      // Then: 기존 로직에 따라 문제 2번으로 이동 (하지만 문제 2번이 없으므로 현재 위치 유지)
      expect(viewModel.currentQuestion.id, equals(99));
    });

    test('문제 ID로 이동하는 기능 테스트', () {
      // Given: 문제 1번에 위치
      viewModel.goToQuestionById(1);
      expect(viewModel.currentQuestion.id, equals(1));

      // When: 문제 4번으로 이동
      viewModel.goToQuestionById(4);

      // Then: 문제 4번에 위치
      expect(viewModel.currentQuestion.id, equals(4));
    });

    test('존재하지 않는 문제 ID로 이동 시도', () {
      // Given: 문제 1번에 위치
      viewModel.goToQuestionById(1);
      expect(viewModel.currentQuestion.id, equals(1));

      // When: 존재하지 않는 문제 ID로 이동 시도
      viewModel.goToQuestionById(999);

      // Then: 현재 위치 유지
      expect(viewModel.currentQuestion.id, equals(1));
    });
  });
}
