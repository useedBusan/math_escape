// import 'package:flutter/material.dart';
//
// import '../../../Feature/high/high_mission_constants.dart';
//
// class DescriptionLevelBox extends StatelessWidget {
//   final String description;
//   final String level;
//   final double fontSize;
//   const DescriptionLevelBox({required this.description, required this.level, required this.fontSize, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Container(
//             padding: EdgeInsets.all(fontSize * 0.85),
//             decoration: BoxDecoration(
//               color: HighMissionConstants.descriptionBoxColor,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               description,
//               style: TextStyle(fontSize: fontSize, color: Colors.black87),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: fontSize * 0.85, vertical: fontSize * 0.6),
//           decoration: BoxDecoration(
//             color: HighMissionConstants.levelBoxColor,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             level,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: Colors.black),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class QuestionBalloon extends StatelessWidget {
//   final String question;
//   final double fontSize;
//   const QuestionBalloon({required this.question, required this.fontSize, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(fontSize),
//       decoration: BoxDecoration(
//         color: HighMissionConstants.questionBalloonColor,
//         border: Border.all(color: HighMissionConstants.questionBalloonBorder),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Text(
//         question,
//         style: TextStyle(fontSize: fontSize, color: Colors.black87),
//       ),
//     );
//   }
// }
//
// class TimerInfoBox extends StatelessWidget {
//   final String thinkingTime;
//   final String bodyTime;
//   final double fontSize;
//   const TimerInfoBox({required this.thinkingTime, required this.bodyTime, required this.fontSize, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: fontSize * 2, vertical: fontSize * 0.6),
//           margin: const EdgeInsets.only(bottom: 8),
//           decoration: BoxDecoration(
//             color: HighMissionConstants.timerBoxColor,
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: HighMissionConstants.timerBoxShadow,
//                 blurRadius: 2,
//                 offset: Offset(1, 2),
//               ),
//             ],
//           ),
//           child: Text(
//             '생각의 시간 $thinkingTime',
//             style: TextStyle(fontSize: fontSize * 1.4, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1.2),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: fontSize * 2, vertical: fontSize * 0.6),
//           decoration: BoxDecoration(
//             color: HighMissionConstants.timerBoxColor,
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: HighMissionConstants.timerBoxShadow,
//                 blurRadius: 2,
//                 offset: Offset(1, 2),
//               ),
//             ],
//           ),
//           child: Text(
//             '몸의 시간 $bodyTime',
//             style: TextStyle(fontSize: fontSize * 1.4, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: 1.2),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }
// }