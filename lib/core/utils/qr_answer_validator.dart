/// 공통 QR 코드 스캔 정답 판별 모듈
/// 모든 레벨(초등 저학년, 초등 고학년, 중등, 고등)의 QR 문제 정답을 통합 처리
library;

import 'package:flutter/foundation.dart';

/// QR 정답 판별을 위한 공통 인터페이스
abstract class QRAnswerProvider {
  bool get isQRQuestion;
  List<String> get qrAnswers;
  int get id;
}

/// 초등 저학년용 QR 정답 제공자
class ElementaryLowQRAnswerProvider implements QRAnswerProvider {
  @override
  final int id;
  final bool isqr;
  final List<String> choices;
  final int answerIndex;

  const ElementaryLowQRAnswerProvider({
    required this.id,
    required this.isqr,
    required this.choices,
    required this.answerIndex,
  });

  @override
  bool get isQRQuestion => isqr;

  @override
  List<String> get qrAnswers {
    if (!isQRQuestion || answerIndex < 0 || answerIndex >= choices.length) {
      return [];
    }
    return [choices[answerIndex]];
  }
}

/// 초등 고학년용 QR 정답 제공자
class ElementaryHighQRAnswerProvider implements QRAnswerProvider {
  @override
  final int id;
  final bool isqr;
  final List<String> answer;

  const ElementaryHighQRAnswerProvider({
    required this.id,
    required this.isqr,
    required this.answer,
  });

  @override
  bool get isQRQuestion => isqr;

  @override
  List<String> get qrAnswers => answer;
}

/// 중등용 QR 정답 제공자
class MiddleQRAnswerProvider implements QRAnswerProvider {
  @override
  final int id;
  final bool isqr;
  final List<String> answer;

  const MiddleQRAnswerProvider({
    required this.id,
    required this.isqr,
    required this.answer,
  });

  @override
  bool get isQRQuestion => isqr;

  @override
  List<String> get qrAnswers => answer;
}

/// 고등용 QR 정답 제공자
class HighQRAnswerProvider implements QRAnswerProvider {
  @override
  final int id;
  final bool isqr;
  final List<String> answer;

  const HighQRAnswerProvider({
    required this.id,
    required this.isqr,
    required this.answer,
  });

  @override
  bool get isQRQuestion => isqr;

  @override
  List<String> get qrAnswers => answer;
}

/// 공통 QR 정답 판별기
class QRAnswerValidator {
  /// QR 스캔 결과가 정답인지 확인
  /// 
  /// [scannedValue]: QR 스캔으로 읽은 값
  /// [answerProvider]: 해당 레벨의 정답 제공자
  /// 
  /// Returns: 정답 여부
  static bool validateQRAnswer(String scannedValue, QRAnswerProvider answerProvider) {
    if (!answerProvider.isQRQuestion) {
      debugPrint('QRAnswerValidator: This is not a QR question (ID: ${answerProvider.id})');
      return false;
    }

    final correctAnswers = answerProvider.qrAnswers;
    if (correctAnswers.isEmpty) {
      debugPrint('QRAnswerValidator: No correct answers found (ID: ${answerProvider.id})');
      return false;
    }

    // 정답 리스트에서 일치하는 값 찾기 (대소문자 무시)
    final normalizedScannedValue = scannedValue.trim().toLowerCase();
    
    for (final correctAnswer in correctAnswers) {
      final normalizedCorrectAnswer = correctAnswer.trim().toLowerCase();
      
      if (normalizedScannedValue == normalizedCorrectAnswer) {
        debugPrint('QRAnswerValidator: Correct answer! Scanned: "$scannedValue", Expected: "$correctAnswer"');
        return true;
      }
    }

    debugPrint('QRAnswerValidator: Wrong answer. Scanned: "$scannedValue", Expected: $correctAnswers');
    return false;
  }

  /// QR 스캔 결과가 정답인지 확인 (간편 버전)
  /// 
  /// [scannedValue]: QR 스캔으로 읽은 값
  /// [correctAnswers]: 정답 리스트
  /// 
  /// Returns: 정답 여부
  static bool validateQRAnswerSimple(String scannedValue, List<String> correctAnswers) {
    if (correctAnswers.isEmpty) {
      debugPrint('QRAnswerValidator: No correct answers provided');
      return false;
    }

    final normalizedScannedValue = scannedValue.trim().toLowerCase();
    
    for (final correctAnswer in correctAnswers) {
      final normalizedCorrectAnswer = correctAnswer.trim().toLowerCase();
      
      if (normalizedScannedValue == normalizedCorrectAnswer) {
        debugPrint('QRAnswerValidator: Correct answer! Scanned: "$scannedValue", Expected: "$correctAnswer"');
        return true;
      }
    }

    debugPrint('QRAnswerValidator: Wrong answer. Scanned: "$scannedValue", Expected: $correctAnswers');
    return false;
  }

  /// QR 정답 형식 검증 (예: "120Q", "121Q" 등)
  /// 
  /// [value]: 검증할 값
  /// 
  /// Returns: QR 정답 형식인지 여부
  static bool isValidQRAnswerFormat(String value) {
    final trimmedValue = value.trim();
    
    // 기본 패턴: 숫자 + Q (예: "120Q", "121Q")
    final qrPattern = RegExp(r'^\d+Q$');
    
    return qrPattern.hasMatch(trimmedValue);
  }

  /// QR 정답 추출 (QR 형식에서 숫자 부분만 추출)
  /// 
  /// [qrValue]: QR 값 (예: "120Q")
  /// 
  /// Returns: 숫자 부분 (예: "120") 또는 null
  static String? extractQRNumber(String qrValue) {
    final trimmedValue = qrValue.trim();
    
    if (isValidQRAnswerFormat(trimmedValue)) {
      return trimmedValue.substring(0, trimmedValue.length - 1);
    }
    
    return null;
  }
}

/// QR 정답 판별 결과
class QRValidationResult {
  final bool isCorrect;
  final String scannedValue;
  final List<String> expectedAnswers;
  final String? message;

  const QRValidationResult({
    required this.isCorrect,
    required this.scannedValue,
    required this.expectedAnswers,
    this.message,
  });

  @override
  String toString() {
    return 'QRValidationResult(isCorrect: $isCorrect, scannedValue: "$scannedValue", expectedAnswers: $expectedAnswers, message: $message)';
  }
}

/// 확장된 QR 정답 판별기 (결과 객체 반환)
class ExtendedQRAnswerValidator {
  /// QR 스캔 결과 검증 (상세 결과 반환)
  /// 
  /// [scannedValue]: QR 스캔으로 읽은 값
  /// [answerProvider]: 해당 레벨의 정답 제공자
  /// 
  /// Returns: 검증 결과 객체
  static QRValidationResult validateQRAnswerDetailed(String scannedValue, QRAnswerProvider answerProvider) {
    if (!answerProvider.isQRQuestion) {
      return QRValidationResult(
        isCorrect: false,
        scannedValue: scannedValue,
        expectedAnswers: [],
        message: 'This is not a QR question',
      );
    }

    final correctAnswers = answerProvider.qrAnswers;
    if (correctAnswers.isEmpty) {
      return QRValidationResult(
        isCorrect: false,
        scannedValue: scannedValue,
        expectedAnswers: [],
        message: 'No correct answers found',
      );
    }

    final normalizedScannedValue = scannedValue.trim().toLowerCase();
    
    for (final correctAnswer in correctAnswers) {
      final normalizedCorrectAnswer = correctAnswer.trim().toLowerCase();
      
      if (normalizedScannedValue == normalizedCorrectAnswer) {
        return QRValidationResult(
          isCorrect: true,
          scannedValue: scannedValue,
          expectedAnswers: correctAnswers,
          message: 'Correct answer!',
        );
      }
    }

    return QRValidationResult(
      isCorrect: false,
      scannedValue: scannedValue,
      expectedAnswers: correctAnswers,
      message: 'Wrong answer',
    );
  }
}
