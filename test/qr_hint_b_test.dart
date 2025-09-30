import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/core/services/qr_answer_service.dart';

void main() {
  group('힌트 문제 B QR 정답 테스트', () {
    late QRAnswerService qrAnswerService;

    setUp(() {
      qrAnswerService = QRAnswerService();
    });

    test('힌트 문제 B QR 정답 로드 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 힌트 문제 B 정답 확인
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_B',
      );

      expect(correctAnswer, isNotNull);
      expect(correctAnswer, equals('126Q'));
      print('힌트 문제 B 정답: $correctAnswer');
    });

    test('힌트 문제 B QR 스캔 결과 검증 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 정답 케이스 테스트
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_B',
      );
      final isCorrect = '126Q' == correctAnswer;

      expect(isCorrect, isTrue);
      print('정답 "126Q" 검증 결과: $isCorrect');

      // 오답 케이스 테스트
      final isWrong = 'WRONG_ANSWER' == correctAnswer;
      expect(isWrong, isFalse);
      print('오답 "WRONG_ANSWER" 검증 결과: $isWrong');
    });

    test('전체 QR 답안 목록 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 전체 답안 목록 확인
      final allAnswers = qrAnswerService.allQrAnswers;

      expect(allAnswers.length, equals(2));

      // 각 답안의 필수 필드 확인
      for (final answer in allAnswers) {
        expect(answer.id, isA<int>());
        expect(answer.title, isNotEmpty);
        expect(answer.correctAnswer, isNotEmpty);
        expect(answer.qrImagePath, isNotEmpty);
        expect(answer.description, isNotEmpty);
      }

      print('전체 QR 답안 개수: ${allAnswers.length}');
      for (final answer in allAnswers) {
        print('- ${answer.title}: ${answer.correctAnswer}');
      }
    });

    test('힌트 문제 B와 문제 4번 정답 비교 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 힌트 문제 B 정답
      final hintBAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_B',
      );
      expect(hintBAnswer, equals('126Q'));

      // 문제 4번 정답
      final question4Answer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_4',
      );
      expect(question4Answer, equals('127Q'));

      // 두 정답이 다른지 확인
      expect(hintBAnswer, isNot(equals(question4Answer)));

      print('힌트 문제 B 정답: $hintBAnswer');
      print('문제 4번 정답: $question4Answer');
    });
  });
}
