import 'package:flutter/material.dart';
import '../utils/styled_text_parser.dart';


extension StringExtension on String {
  /// 한글 단어 단위 줄바꿈 적용 (이모지 안전)
  String applyKoreanWordBreak() {
    final RegExp emoji = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|'
      r'\ud83c[\ud000-\udfff]|'
      r'\ud83d[\ud000-\udfff]|'
      r'\ud83e[\ud000-\udfff])',
    );

    String fullText = '';
    List<String> words = split(' ');

    for (var i = 0; i < words.length; i++) {
      if (emoji.hasMatch(words[i])) {
        fullText += words[i];
      } else {
        fullText += words[i]
            .replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D');
      }
      if (i < words.length - 1) fullText += ' ';
    }

    return fullText;
  }

  /// 1) 먼저 스타일 파싱  2) 그 다음 일반 텍스트(TextSpan)에만 ZWJ 적용
  List<InlineSpan> toStyledSpans({double fontSize = 16}) {
    final spans = StyledTextParser.parse(this, fontSize: fontSize);
    return spans.map((span) {
      if (span is TextSpan && span.text != null) {
        return TextSpan(
          text: span.text!.applyKoreanWordBreak(),
          style: span.style,
          children: span.children,
        );
      }
      return span;
    }).toList();
  }

  Widget toStyledRichText({
    double fontSize = 16,
    TextAlign align = TextAlign.start,
    double height = 1.6,
  }) {
    return RichText(
      textAlign: align,
      softWrap: true,
      overflow: TextOverflow.visible,
      text: TextSpan(
        style: TextStyle(height: height),
        children: toStyledSpans(fontSize: fontSize),
      ),
    );
  }
}