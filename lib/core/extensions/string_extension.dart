import 'package:flutter/material.dart';
import '../utils/styled_text_parser.dart';


extension StringExtension on String {
  /// 한글 단어 단위 줄바꿈 적용 (원래 insertZwj)
  String applyKoreanWordBreak() {
    return replaceAllMapped(RegExp(r'(\S)(?=\S)'), (m) => '${m[1]}\u200D');
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