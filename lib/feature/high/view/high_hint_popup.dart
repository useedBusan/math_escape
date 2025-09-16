import 'package:flutter/material.dart';

class HighHintPopup extends StatelessWidget {
  final String hintTitle;
  final String hintContent;
  final VoidCallback onConfirm;

  const HighHintPopup({
    super.key,
    required this.hintTitle,
    required this.hintContent,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 제목
            Text(
              hintTitle,
              style: TextStyle(
                fontSize: screenWidth * (18 / 360),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3F55A7),
              ),
            ),
            const SizedBox(height: 16),

            // 힌트 내용
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE9ECEF), width: 1),
              ),
              child: Text(
                hintContent,
                style: TextStyle(
                  fontSize: screenWidth * (14 / 360),
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // 확인 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F55A7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontSize: screenWidth * (16 / 360),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
