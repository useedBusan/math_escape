// import 'package:flutter/material.dart';
//
// class HighHintPopup extends StatelessWidget {
//   final String hintTitle;
//   final String hintContent;
//   final VoidCallback onConfirm;
//
//   const HighHintPopup({
//     super.key,
//     required this.hintTitle,
//     required this.hintContent,
//     required this.onConfirm,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final mq = MediaQuery.of(context);
//     final width = mq.size.width;
//     final height = mq.size.height;
//     final headerSize = width * (18 / 360);
//     final baseSize = width * (17 / 360);
//
//     return Dialog(
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(12),
//           topRight: Radius.circular(12),
//           bottomLeft: Radius.circular(40),
//           bottomRight: Radius.circular(40),
//         ),
//       ),
//       child: ConstrainedBox(
//         constraints: BoxConstraints(maxWidth: 420, maxHeight: height * 0.55),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ConstrainedBox(
//               constraints: const BoxConstraints(maxHeight: 360),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // 힌트 아이콘 (파란색)
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF3F55A7).withValues(alpha: 0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.lightbulb_outline,
//                         size: 40,
//                         color: Color(0xFF3F55A7),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Text(
//                       hintTitle,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: headerSize,
//                         fontWeight: FontWeight.w700,
//                         color: const Color(0xff202020),
//                         height: 1.25,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       hintContent,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: baseSize,
//                         color: const Color(0xff202020),
//                         height: 1.4,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//
//             // 확인 버튼 (파란색)
//             SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: FilledButton(
//                 style: FilledButton.styleFrom(
//                   backgroundColor: const Color(0xFF3F55A7),
//                   foregroundColor: Colors.white,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(12),
//                       bottomRight: Radius.circular(12),
//                     ),
//                   ),
//                 ),
//                 onPressed: onConfirm,
//                 child: Text(
//                   '확인',
//                   style: TextStyle(
//                     fontSize: baseSize,
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
