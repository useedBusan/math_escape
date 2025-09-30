// import 'package:flutter/material.dart';
//
// class HighAnswerPopup extends StatelessWidget {
//   final bool isCorrect;
//   final VoidCallback? onNext;
//
//   const HighAnswerPopup({super.key, required this.isCorrect, this.onNext});
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       child: Container(
//         padding: const EdgeInsets.all(32),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 15,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // 아이콘
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: isCorrect
//                     ? const Color(0xFF4CAF50).withOpacity(0.1)
//                     : const Color(0xFFF44336).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 isCorrect ? Icons.check_circle : Icons.cancel,
//                 size: 50,
//                 color: isCorrect
//                     ? const Color(0xFF4CAF50)
//                     : const Color(0xFFF44336),
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // 결과 텍스트
//             Text(
//               isCorrect ? '정답입니다!' : '틀렸습니다!',
//               style: TextStyle(
//                 fontSize: screenWidth * (20 / 360),
//                 fontWeight: FontWeight.bold,
//                 color: isCorrect
//                     ? const Color(0xFF4CAF50)
//                     : const Color(0xFFF44336),
//               ),
//             ),
//             const SizedBox(height: 8),
//
//             // 부가 설명
//             Text(
//               isCorrect ? '훌륭한 수학적 사고력입니다!' : '다시 한번 생각해보세요.',
//               style: TextStyle(
//                 fontSize: screenWidth * (14 / 360),
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//
//             // 확인 버튼
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: onNext ?? () => Navigator.of(context).pop(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: isCorrect
//                       ? const Color(0xFF4CAF50)
//                       : const Color(0xFFF44336),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   isCorrect ? '다음 문제' : '다시 시도',
//                   style: TextStyle(
//                     fontSize: screenWidth * (16 / 360),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
