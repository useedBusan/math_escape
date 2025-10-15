import 'package:flutter/material.dart';

typedef HintEntry = ({String text, List<String>? images, List<String>? videos});

class HintModel {
  final String hintIcon;
  final String upString;
  final String downString;
  final List<String>? hintImg;
  final List<String>? hintVideo;
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
