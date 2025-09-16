import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../model/answer_model.dart';

class AnswerPopup extends StatelessWidget {
  final bool isCorrect;
  final StudentGrade grade;
  final VoidCallback onNext;

  const AnswerPopup({
    super.key,
    required this.isCorrect,
    required this.grade,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = themeOf(isCorrect: isCorrect, grade: grade);
    final width = MediaQuery.of(context).size.width;
    final baseSize = width * (16 / 360);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Icon(theme.icon, size: 80, color: theme.accentColor),
                    const SizedBox(height: 12),
                    _HighlightedTitle(
                      text: theme.title,
                      highlightWords: const ['정답', '오답'],
                      highlightColor: theme.accentColor,
                      fontSize: baseSize,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      theme.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: baseSize,
                        color: const Color(0xff202020),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(height: 1, thickness: 1, color: Color(0xFFDDDDDD)),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: onNext,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.buttonColor,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('확인', style: TextStyle(fontSize: baseSize)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightedTitle extends StatelessWidget {
  final String text;
  final List<String> highlightWords;
  final Color highlightColor;
  final double fontSize;

  const _HighlightedTitle({
    required this.text,
    required this.highlightWords,
    required this.highlightColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontSize: fontSize,
      color: const Color(0xff202020),
      fontWeight: FontWeight.w700,
    );

    final pattern = RegExp(highlightWords.join('|'));

    final spans = <InlineSpan>[];
    int start = 0;

    for (final m in pattern.allMatches(text)) {
      if (m.start > start) {
        spans.add(TextSpan(text: text.substring(start, m.start), style: base));
      }
      final word = text.substring(m.start, m.end);
      spans.add(TextSpan(text: word, style: base.copyWith(color: highlightColor)));
      start = m.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: base));
    }

    return Text.rich(TextSpan(children: spans), textAlign: TextAlign.center);
  }
}