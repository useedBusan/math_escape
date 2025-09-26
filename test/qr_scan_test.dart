import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/core/services/qr_answer_service.dart';
import 'package:math_escape/feature/high/model/high_qr_answer.dart';

void main() {
  group('QR 스캔 기능 테스트', () {
    late QRAnswerService qrAnswerService;

    setUp(() {
      qrAnswerService = QRAnswerService();
    });

    test('QR 정답 데이터 로드 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 로드된 데이터 확인
      expect(qrAnswerService.allQrAnswers.length, greaterThan(0));
      print('로드된 QR 정답 개수: ${qrAnswerService.allQrAnswers.length}');
    });

    test('문제 4번 QR 정답 확인 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 문제 4번 정답 확인
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_4',
      );

      expect(correctAnswer, isNotNull);
      expect(correctAnswer, equals('127Q'));
      print('문제 4번 정답: $correctAnswer');
    });

    test('QR 스캔 결과 검증 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 정답 케이스 테스트
      final correctAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '역설, 혹은 모호함_4',
      );
      final isCorrect = '127Q' == correctAnswer;

      expect(isCorrect, isTrue);
      print('정답 "127Q" 검증 결과: $isCorrect');

      // 오답 케이스 테스트
      final isWrong = 'WRONG_ANSWER' == correctAnswer;
      expect(isWrong, isFalse);
      print('오답 "WRONG_ANSWER" 검증 결과: $isWrong');
    });

    test('QR 이미지 경로 확인 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 이미지 경로 확인
      final imagePath = qrAnswerService.getQRImagePathByTitle('역설, 혹은 모호함_4');

      expect(imagePath, isNotNull);
      expect(imagePath, contains('qr_answer_4.png'));
      print('QR 이미지 경로: $imagePath');
    });

    test('존재하지 않는 문제 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 존재하지 않는 문제
      final nonExistentAnswer = qrAnswerService.getCorrectAnswerByTitle(
        '존재하지_않는_문제',
      );

      expect(nonExistentAnswer, isNull);
      print('존재하지 않는 문제 검증: $nonExistentAnswer');
    });

    test('QR 답안 모델 테스트', () {
      // JSON 데이터 생성
      final jsonData = {
        'id': 4,
        'title': '역설, 혹은 모호함_4',
        'correctAnswer': '127Q',
        'qrImagePath': 'assets/images/qr_answers/high/qr_answer_4.png',
        'description': 'QR 코드 스캔 정답',
      };

      // 모델 생성
      final qrAnswer = HighQRAnswer.fromJson(jsonData);

      // 모델 검증
      expect(qrAnswer.id, equals(4));
      expect(qrAnswer.title, equals('역설, 혹은 모호함_4'));
      expect(qrAnswer.correctAnswer, equals('127Q'));
      expect(qrAnswer.qrImagePath, contains('qr_answer_4.png'));
      expect(qrAnswer.description, equals('QR 코드 스캔 정답'));

      print('QR 답안 모델 검증 완료');
      print('ID: ${qrAnswer.id}');
      print('Title: ${qrAnswer.title}');
      print('Correct Answer: ${qrAnswer.correctAnswer}');
      print('Image Path: ${qrAnswer.qrImagePath}');
    });

    test('전체 QR 답안 목록 테스트', () async {
      // QR 정답 데이터 로드
      await qrAnswerService.loadQrAnswers();

      // 전체 답안 목록 확인
      final allAnswers = qrAnswerService.allQrAnswers;

      expect(allAnswers, isNotEmpty);

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
  });
}
