import 'dart:convert';
import 'package:flutter/services.dart';
import '../../feature/high/model/high_qr_answer.dart';

class QRAnswerService {
  static final QRAnswerService _instance = QRAnswerService._internal();
  factory QRAnswerService() => _instance;
  QRAnswerService._internal();

  List<HighQRAnswer> _qrAnswers = [];

  Future<void> loadQrAnswers() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/high/high_qr_answers.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      _qrAnswers = jsonData.map((e) => HighQRAnswer.fromJson(e)).toList();
    } catch (e) {
      _qrAnswers = [];
    }
  }

  String? getCorrectAnswer(int questionId) {
    try {
      final answer = _qrAnswers.firstWhere((answer) => answer.id == questionId);
      return answer.correctAnswer;
    } catch (e) {
      return null;
    }
  }

  String? getCorrectAnswerByTitle(String title) {
    try {
      final answer = _qrAnswers.firstWhere((answer) => answer.title == title);
      return answer.correctAnswer;
    } catch (e) {
      return null;
    }
  }

  String? getQRImagePathByTitle(String title) {
    try {
      final answer = _qrAnswers.firstWhere((answer) => answer.title == title);
      return answer.qrImagePath;
    } catch (e) {
      return null;
    }
  }

  HighQRAnswer? getQRAnswerByTitle(String title) {
    try {
      return _qrAnswers.firstWhere((answer) => answer.title == title);
    } catch (e) {
      return null;
    }
  }

  List<HighQRAnswer> get allQrAnswers => _qrAnswers;
}
