import 'package:flutter/material.dart';

typedef HintEntry = ({String text, String? image, String? video});

class HintModel {
  final String hintIcon;
  final String upString;
  final String downString;
  final String? hintImg;
  final String? hintVideo;
  final Color mainColor;

  const HintModel({
    required this.hintIcon,
    required this.upString,
    required this.downString,
    required this.mainColor,
    this.hintImg,
    this.hintVideo,
  });
}
