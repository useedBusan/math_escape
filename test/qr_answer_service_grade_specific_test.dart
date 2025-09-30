import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/core/services/qr_answer_service.dart';

void main() {
  group('QRAnswerService 학년별 메서드 테스트', () {
    late QRAnswerService qrAnswerService;

    setUp(() {
      qrAnswerService = QRAnswerService();
    });

    group('초등학교 저학년 메서드 테스트', () {
      test('getElementaryLowAnswer - 정상적인 문제 ID로 정답 반환', () async {
        // QR 답안 서비스 로드
        await qrAnswerService.loadQrAnswers();

        // 테스트용 문제 ID (실제 데이터에 존재하는 ID 사용)
        const testQuestionId = 1;

        // 정답 검색
        final answer = qrAnswerService.getElementaryLowAnswer(testQuestionId);

        // 결과 검증
        expect(answer, isNotNull);
        expect(answer, isA<String>());
        expect(answer!.isNotEmpty, isTrue);
      });

      test('getElementaryLowAnswer - 존재하지 않는 문제 ID로 null 반환', () async {
        await qrAnswerService.loadQrAnswers();

        const nonExistentId = 99999;
        final answer = qrAnswerService.getElementaryLowAnswer(nonExistentId);

        expect(answer, isNull);
      });

      test('getElementaryLowAnswers - 모든 답안 반환', () async {
        await qrAnswerService.loadQrAnswers();

        final answers = qrAnswerService.getElementaryLowAnswers();

        expect(answers, isA<Map<int, String>>());
        expect(answers.isNotEmpty, isTrue);
      });

      test('getElementaryLowProblemCount - 문제 개수 반환', () async {
        await qrAnswerService.loadQrAnswers();

        final count = qrAnswerService.getElementaryLowProblemCount();

        expect(count, isA<int>());
        expect(count, greaterThanOrEqualTo(0));
      });
    });

    group('초등학교 고학년 메서드 테스트', () {
      test('getElementaryHighAnswer - 정상적인 문제 ID로 정답 반환', () async {
        await qrAnswerService.loadQrAnswers();

        const testQuestionId = 1;
        final answer = qrAnswerService.getElementaryHighAnswer(testQuestionId);

        expect(answer, isNotNull);
        expect(answer, isA<String>());
        expect(answer!.isNotEmpty, isTrue);
      });

      test('getElementaryHighAnswer - 존재하지 않는 문제 ID로 null 반환', () async {
        await qrAnswerService.loadQrAnswers();

        const nonExistentId = 99999;
        final answer = qrAnswerService.getElementaryHighAnswer(nonExistentId);

        expect(answer, isNull);
      });

      test('getElementaryHighAnswers - 모든 답안 반환', () async {
        await qrAnswerService.loadQrAnswers();

        final answers = qrAnswerService.getElementaryHighAnswers();

        expect(answers, isA<Map<int, String>>());
        expect(answers.isNotEmpty, isTrue);
      });

      test('getElementaryHighProblemCount - 문제 개수 반환', () async {
        await qrAnswerService.loadQrAnswers();

        final count = qrAnswerService.getElementaryHighProblemCount();

        expect(count, isA<int>());
        expect(count, greaterThanOrEqualTo(0));
      });
    });

    group('중학교 메서드 테스트', () {
      test('getMiddleAnswer - 정상적인 문제 ID로 정답 반환', () async {
        await qrAnswerService.loadQrAnswers();

        const testQuestionId = 1;
        final answer = qrAnswerService.getMiddleAnswer(testQuestionId);

        expect(answer, isNotNull);
        expect(answer, isA<String>());
        expect(answer!.isNotEmpty, isTrue);
      });

      test('getMiddleAnswer - 존재하지 않는 문제 ID로 null 반환', () async {
        await qrAnswerService.loadQrAnswers();

        const nonExistentId = 99999;
        final answer = qrAnswerService.getMiddleAnswer(nonExistentId);

        expect(answer, isNull);
      });

      test('getMiddleAnswers - 모든 답안 반환', () async {
        await qrAnswerService.loadQrAnswers();

        final answers = qrAnswerService.getMiddleAnswers();

        expect(answers, isA<Map<int, String>>());
        expect(answers.isNotEmpty, isTrue);
      });

      test('getMiddleProblemCount - 문제 개수 반환', () async {
        await qrAnswerService.loadQrAnswers();

        final count = qrAnswerService.getMiddleProblemCount();

        expect(count, isA<int>());
        expect(count, greaterThanOrEqualTo(0));
      });
    });

    group('고등학교 메서드 테스트', () {
      test('getHighAnswer - 정상적인 문제 ID로 정답 반환', () async {
        await qrAnswerService.loadQrAnswers();

        const testQuestionId = 1;
        final answer = qrAnswerService.getHighAnswer(testQuestionId);

        expect(answer, isNotNull);
        expect(answer, isA<String>());
        expect(answer!.isNotEmpty, isTrue);
      });

      test('getHighAnswer - 존재하지 않는 문제 ID로 null 반환', () async {
        await qrAnswerService.loadQrAnswers();

        const nonExistentId = 99999;
        final answer = qrAnswerService.getHighAnswer(nonExistentId);

        expect(answer, isNull);
      });

      test('getHighAnswers - 모든 답안 반환', () async {
        await qrAnswerService.loadQrAnswers();

        final answers = qrAnswerService.getHighAnswers();

        expect(answers, isA<Map<int, String>>());
        expect(answers.isNotEmpty, isTrue);
      });

      test('getHighProblemCount - 문제 개수 반환', () async {
        await qrAnswerService.loadQrAnswers();

        final count = qrAnswerService.getHighProblemCount();

        expect(count, isA<int>());
        expect(count, greaterThanOrEqualTo(0));
      });
    });

    group('통합 테스트', () {
      test('모든 학년의 QR 답안이 정상적으로 로드되는지 확인', () async {
        await qrAnswerService.loadQrAnswers();

        // 각 학년별로 답안이 로드되었는지 확인
        final elementaryLowAnswers = qrAnswerService.getElementaryLowAnswers();
        final elementaryHighAnswers = qrAnswerService
            .getElementaryHighAnswers();
        final middleAnswers = qrAnswerService.getMiddleAnswers();
        final highAnswers = qrAnswerService.getHighAnswers();

        // 최소한 하나의 학년에는 답안이 있어야 함
        final totalAnswers =
            elementaryLowAnswers.length +
            elementaryHighAnswers.length +
            middleAnswers.length +
            highAnswers.length;

        expect(totalAnswers, greaterThan(0));
      });

      test('각 학년별 문제 개수와 답안 개수가 일치하는지 확인', () async {
        await qrAnswerService.loadQrAnswers();

        expect(
          qrAnswerService.getElementaryLowProblemCount(),
          equals(qrAnswerService.getElementaryLowAnswers().length),
        );

        expect(
          qrAnswerService.getElementaryHighProblemCount(),
          equals(qrAnswerService.getElementaryHighAnswers().length),
        );

        expect(
          qrAnswerService.getMiddleProblemCount(),
          equals(qrAnswerService.getMiddleAnswers().length),
        );

        expect(
          qrAnswerService.getHighProblemCount(),
          equals(qrAnswerService.getHighAnswers().length),
        );
      });
    });
  });
}
