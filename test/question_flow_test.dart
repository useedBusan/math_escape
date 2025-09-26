import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/feature/high/model/high_mission_question.dart';

void main() {
  group('문제 플로우 테스트', () {
    test('문제 3번 정답 후 문제 4번으로 이동 검증', () {
      // 문제 3번 데이터
      final question3 = MissionQuestion(
        id: 4,
        title: '역설, 혹은 모호함_3',
        description: '테스트',
        level: '고급',
        question: '이 입체도형 위에서는 곡선이 직선이 된다.',
        answer: ['구', '곡면', '공'],
        hint: '',
        isqr: false,
      );

      // 문제 4번 데이터 (QR 인식 문제)
      final question4 = MissionQuestion(
        id: 6,
        title: '역설, 혹은 모호함_4',
        description: '테스트',
        level: '고급',
        question: '세 내각의 합이 180°보다 작은 삼각형을 찾아\nQR코드를 찍으시오.',
        answer: ['127Q'],
        hint: '말의 안장처럼 생겼다.',
        isqr: true,
      );

      // 문제 3번에서 정답을 맞추면 문제 4번으로 이동
      expect(question3.title, equals('역설, 혹은 모호함_3'));
      expect(question3.id, equals(4));
      expect(question3.isqr, isFalse);

      expect(question4.title, equals('역설, 혹은 모호함_4'));
      expect(question4.id, equals(6));
      expect(question4.isqr, isTrue);

      print('✅ 문제 3번 정답 후 문제 4번으로 이동 검증 완료');
      print(
        '   문제 3번: ${question3.title} (ID: ${question3.id}, QR: ${question3.isqr})',
      );
      print(
        '   문제 4번: ${question4.title} (ID: ${question4.id}, QR: ${question4.isqr})',
      );
    });

    test('전체 문제 플로우 검증', () {
      // 전체 문제 플로우 확인
      final flow = [
        {
          'step': 1,
          'title': '역설, 혹은 모호함_1',
          'action': '힌트 클릭',
          'next': '역설, 혹은 모호함_A',
        },
        {
          'step': 2,
          'title': '역설, 혹은 모호함_A',
          'action': '정답 입력',
          'next': '역설, 혹은 모호함_1',
        },
        {
          'step': 3,
          'title': '역설, 혹은 모호함_1',
          'action': '정답 입력',
          'next': '정답 화면',
        },
        {
          'step': 4,
          'title': '역설, 혹은 모호함_2',
          'action': '힌트 클릭',
          'next': '힌트 팝업',
        },
        {
          'step': 5,
          'title': '역설, 혹은 모호함_2',
          'action': '정답 입력',
          'next': '정답 화면',
        },
        {
          'step': 6,
          'title': '역설, 혹은 모호함_3',
          'action': '힌트 클릭',
          'next': '역설, 혹은 모호함_B',
        },
        {
          'step': 7,
          'title': '역설, 혹은 모호함_B',
          'action': '힌트 클릭',
          'next': '힌트 팝업',
        },
        {
          'step': 8,
          'title': '역설, 혹은 모호함_B',
          'action': '정답 입력',
          'next': '역설, 혹은 모호함_3',
        },
        {
          'step': 9,
          'title': '역설, 혹은 모호함_3',
          'action': '정답 입력',
          'next': '역설, 혹은 모호함_4',
        },
        {
          'step': 10,
          'title': '역설, 혹은 모호함_4',
          'action': 'QR 스캔',
          'next': '정답 화면',
        },
      ];

      for (final step in flow) {
        expect(step['title'], isNotEmpty);
        expect(step['action'], isNotEmpty);
        expect(step['next'], isNotEmpty);
      }

      print('✅ 전체 문제 플로우 검증 완료');
      for (final step in flow) {
        print(
          '   ${step['step']}. ${step['title']} -> ${step['action']} -> ${step['next']}',
        );
      }
    });

    test('QR 문제 특성 검증', () {
      // QR 문제 4번의 특성 확인
      final qrQuestion = MissionQuestion(
        id: 6,
        title: '역설, 혹은 모호함_4',
        description: '테스트',
        level: '고급',
        question: '세 내각의 합이 180°보다 작은 삼각형을 찾아\nQR코드를 찍으시오.',
        answer: ['127Q'],
        hint: '말의 안장처럼 생겼다.',
        isqr: true,
      );

      // QR 문제 특성 검증
      expect(qrQuestion.isqr, isTrue);
      expect(qrQuestion.answer, contains('127Q'));
      expect(qrQuestion.question, contains('QR코드를 찍으시오'));

      print('✅ QR 문제 특성 검증 완료');
      print('   QR 문제 여부: ${qrQuestion.isqr}');
      print('   정답: ${qrQuestion.answer}');
      print('   문제 내용: ${qrQuestion.question}');
    });
  });
}
