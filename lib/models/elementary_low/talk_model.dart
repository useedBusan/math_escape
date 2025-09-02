import 'package:flutter/material.dart';

enum Speaker { puri, maemae, book }
enum BackImg { first, second }
enum StudentGrade { elementaryLow, middle}

class Talk {
  final int id;
  final Speaker speaker;
  final String speakerImg;
  final String backgroundImg;
  final String talk;

  Talk({
    required this.id,
    required this.speaker,
    required this.speakerImg,
    required this.backgroundImg,
    required this.talk,
  });

  factory Talk.fromJson(Map<String, dynamic> json) {
    Speaker speaker;
    switch (json['speaker']) {
      case 'Puri':
        speaker = Speaker.puri;
        break;
      case 'Maemae':
        speaker = Speaker.maemae;
        break;
      case 'Book':
        speaker = Speaker.book;
        break;
      default:
        throw Exception('Invalid speaker value: ${json['speaker']}');
    }

    BackImg backImg;
    switch (json['backImg']) {
      case 'first':
        backImg = BackImg.first;
        break;
      case 'second':
        backImg = BackImg.second;
        break;
      default:
        throw Exception('Invalid backImg value: ${json['backImg']}');
    }

    return Talk(
      id: json['id'],
      speaker: speaker,
      speakerImg: json['speakerImg'],
      backgroundImg: json['backgroundImg'],
      talk: json['talk'],
    );
  }
}
