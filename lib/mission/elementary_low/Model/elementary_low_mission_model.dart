import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ElementaryLowMissionModel {
  final int id;
  final String title;
  final String question;
  final List<String> answer;
  final int choice;
  final String hint1;
  final String hint2;
  final String? questionImage;

  const ElementaryLowMissionModel({
    required this.id,
    required this.title,
    required this.question,
    required this.answer,
    required this.choice
    required this.hint1,
    required this.hint2,
    this.questionImage,
  });

  factory ElementaryLowMissionModel.fromJson(Map<String, dynamic> json) {
    return ElementaryLowMissionModel(
        id: json['id'],
        title: json['title'],
        question: json['question'],
        answer: List<String>.from(json['answer']),
        choice: json['choice'],
        hint1: json['hint1'] ?? '',
        hint2: json['hint2'] ?? '',
        questionImage: json['images'] as String?
    );
  }
}