import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/core/services/qr_answer_service.dart';

void main() {
  group('QR 스캔 시뮬레이션 테스트', () {
    late QRAnswerService qrAnswerService;

    setUp(() async {
      qrAnswerService = QRAnswerService();
      await qrAnswerService.loadQrAnswers();
    });

    test('정답 QR 스캔 시뮬레이션', () {
      // 시뮬레이션: 사용자가 "127Q" QR 코드를 스캔
      final simulatedQRResult = '127Q';

      // 정답 확인
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_4',
      );
      final isCorrect = simulatedQRResult == correctAnswer;

      expect(isCorrect, isTrue);
      print('✅ 정답 QR 스캔 시뮬레이션 성공');
      print('   스캔 결과: $simulatedQRResult');
      print('   정답: $correctAnswer');
      print('   결과: 정답');
    });

    test('오답 QR 스캔 시뮬레이션', () {
      // 시뮬레이션: 사용자가 잘못된 QR 코드를 스캔
      final simulatedQRResult = 'WRONG_ANSWER';

      // 정답 확인
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_4',
      );
      final isCorrect = simulatedQRResult == correctAnswer;

      expect(isCorrect, isFalse);
      print('❌ 오답 QR 스캔 시뮬레이션 성공');
      print('   스캔 결과: $simulatedQRResult');
      print('   정답: $correctAnswer');
      print('   결과: 오답');
    });

    test('빈 QR 스캔 시뮬레이션', () {
      // 시뮬레이션: 사용자가 빈 QR 코드를 스캔
      final simulatedQRResult = '';

      // 정답 확인
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_4',
      );
      final isCorrect = simulatedQRResult == correctAnswer;

      expect(isCorrect, isFalse);
      print('❌ 빈 QR 스캔 시뮬레이션 성공');
      print('   스캔 결과: (빈 문자열)');
      print('   정답: $correctAnswer');
      print('   결과: 오답');
    });

    test('대소문자 구분 QR 스캔 시뮬레이션', () {
      // 시뮬레이션: 사용자가 대소문자가 다른 QR 코드를 스캔
      final simulatedQRResult = '127q'; // 소문자

      // 정답 확인
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_4',
      );
      final isCorrect = simulatedQRResult == correctAnswer;

      expect(isCorrect, isFalse);
      print('❌ 대소문자 구분 QR 스캔 시뮬레이션 성공');
      print('   스캔 결과: $simulatedQRResult');
      print('   정답: $correctAnswer');
      print('   결과: 오답 (대소문자 구분)');
    });

    test('공백 포함 QR 스캔 시뮬레이션', () {
      // 시뮬레이션: 사용자가 공백이 포함된 QR 코드를 스캔
      final simulatedQRResult = ' 127Q '; // 앞뒤 공백

      // 정답 확인
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_4',
      );
      final isCorrect = simulatedQRResult == correctAnswer;

      expect(isCorrect, isFalse);
      print('❌ 공백 포함 QR 스캔 시뮬레이션 성공');
      print('   스캔 결과: "$simulatedQRResult"');
      print('   정답: $correctAnswer');
      print('   결과: 오답 (공백 포함)');
    });

    test('여러 QR 답안 동시 테스트', () async {
      // 여러 QR 답안이 있는 경우를 시뮬레이션
      final testCases = [
        {'title': '역설, 혹은 모호함_4', 'scanResult': '127Q', 'expected': true},
        {'title': '존재하지_않는_문제', 'scanResult': 'ANY_ANSWER', 'expected': false},
      ];

      for (final testCase in testCases) {
        final title = testCase['title'] as String;
        final scanResult = testCase['scanResult'] as String;
        final expected = testCase['expected'] as bool;

        final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(title);
        final isCorrect = correctAnswer != null && scanResult == correctAnswer;

        expect(isCorrect, equals(expected));
        print('${expected ? '✅' : '❌'} $title: $scanResult -> $isCorrect');
      }
    });

    test('QR 스캔 성능 테스트', () {
      // QR 스캔 검증 성능 테스트
      final startTime = DateTime.now();

      // 1000번 반복 검증
      for (int i = 0; i < 1000; i++) {
        final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
          '역설, 혹은 모호함_4',
        );
        final isCorrect = '127Q' == correctAnswer;
        expect(isCorrect, isTrue);
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print('QR 스캔 성능 테스트 완료');
      print('   1000번 검증 소요 시간: ${duration.inMilliseconds}ms');
      print('   평균 검증 시간: ${duration.inMicroseconds / 1000}μs');
    });
  });
}
