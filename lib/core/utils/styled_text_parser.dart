import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// Markdown-like & LaTeX-style mixed parser.
/// 지원 문법:
/// - **볼드**
/// - {#RRGGBB|텍스트} 색상 지정
/// - $...$ LaTeX 수식
class StyledTextParser {
  static List<InlineSpan> parse(String text, {double fontSize = 16}) {
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();

    bool isBold = false;
    Color? currentColor;
    bool inMath = false;
    final mathBuffer = StringBuffer();

    void flushBuffer() {
      if (buffer.isEmpty) return;
      spans.add(TextSpan(
        text: buffer.toString(),
        style: TextStyle(
          color: currentColor ?? Colors.black87,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
        ),
      ));
      buffer.clear();
    }

    void flushMathBuffer() {
      if (mathBuffer.isEmpty) return;
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Math.tex(
          mathBuffer.toString(),
          textStyle: TextStyle(
            color: currentColor ?? Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
      ));
      mathBuffer.clear();
    }

    for (int i = 0; i < text.length; i++) {
      if (text[i] == r'$') {
        if (inMath) {
          flushMathBuffer();
          inMath = false;
        } else {
          flushBuffer();
          inMath = true;
        }
        continue;
      }

      if (inMath) {
        mathBuffer.write(text[i]);
        continue;
      }

      if (text.startsWith('**', i)) {
        flushBuffer();
        isBold = !isBold;
        i++; // **는 2글자
        continue;
      }

      if (text.startsWith('{#', i)) {
        final match = RegExp(r'\{#([0-9A-Fa-f]{6})\|').matchAsPrefix(text, i);
        if (match != null) {
          flushBuffer();
          currentColor = Color(int.parse('0xFF${match.group(1)}'));
          i += match.group(0)!.length - 1;
          continue;
        }
      }

      if (text[i] == '}') {
        flushBuffer();
        currentColor = null;
        continue;
      }

      buffer.write(text[i]);
    }

    if (inMath) flushMathBuffer();
    else flushBuffer();

    return spans;
  }
}