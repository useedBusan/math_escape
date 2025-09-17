// // lib/app/base_main_view.dart
// import 'package:flutter/material.dart';
// import 'base_main_view_model.dart';
//
//
// /// 메인 홈 화면
// /// - MainScreen -> serviceLocator.mainViewModel 주입 받아 사용
// /// - 카드 탭 시 NavigationService를 통해 개별 화면으로 이동
// class BaseMainView extends StatelessWidget {
//   const BaseMainView({super.key, required this.viewModel});
//
//   final BaseMainViewModel viewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     // MainViewModel이 ChangeNotifier이므로 AnimatedBuilder로 상태 반영
//     return AnimatedBuilder(
//       animation: viewModel,
//       builder: (context, _) {
//         return Scaffold(
//           backgroundColor: Colors.white,
//           body: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 상단 로고/타이틀 영역 ------------------------------
//                   // 로고 이미지가 있으면 여기에 Image.asset(...)로 교체
//                   Row(
//                     children: [
//                       // TODO: 로고 자산 있으면 교체
//                       const Icon(Icons.school, size: 28),
//                       const SizedBox(width: 8),
//                       const Text(
//                         '부산수학문화관',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     '미션투어시리즈에 온 걸 환영해! 🎉\n너만의 수학 모험을 시작해 봐!',
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, height: 1.25),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // 2x2 카드 영역 -------------------------------------
//                   GridView(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 12,
//                       mainAxisSpacing: 12,
//                       childAspectRatio: 0.78, // 디자인에 맞춰 조정
//                     ),
//                     children: [
//                       _LevelCard(
//                         bgColor: const Color(0xFFFFEEF3),
//                         title: '미션! 수학자의\n수첩을 찾아서',
//                         subtitle: '초등 저학년 8~10세',
//                         // TODO: 실제 일러스트 자산으로 교체 -> Image.asset('assets/elem_low.png')
//                         leading: const Icon(Icons.explore, size: 72),
//                         onTap: () => viewModel.onSchoolLevelCardTap(context, '초등학교 저학년'),
//                       ),
//                       _LevelCard(
//                         bgColor: const Color(0xFFFFEEF6),
//                         title: '미션! 수사모의\n보물을 찾아서',
//                         subtitle: '초등 고학년 11~13세',
//                         leading: const Icon(Icons.auto_awesome, size: 72),
//                         onTap: () => viewModel.onSchoolLevelCardTap(context, '초등학교 고학년'),
//                       ),
//                       _LevelCard(
//                         bgColor: const Color(0xFFEFF3FF),
//                         title: '수학자의 비밀\n노트를 찾아라!',
//                         subtitle: '중학생 14~16세',
//                         leading: const Icon(Icons.menu_book, size: 72),
//                         onTap: () => viewModel.onSchoolLevelCardTap(context, '중학교'),
//                       ),
//                       _LevelCard(
//                         bgColor: const Color(0xFFEFF3FF),
//                         title: '역설, 혹은\n모호함',
//                         subtitle: '고등학생 17~19세',
//                         leading: const Icon(Icons.edit_note, size: 72),
//                         onTap: () => viewModel.onSchoolLevelCardTap(context, '고등학교'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// /// 단일 학년 카드 위젯
// class _LevelCard extends StatelessWidget {
//   const _LevelCard({
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//     required this.leading,
//     required this.bgColor,
//   });
//
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//   final Widget leading;
//   final Color bgColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: bgColor,
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.black12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: Center(child: leading)),
//               const SizedBox(height: 8),
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 subtitle,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF4E6BFA), // 디자인에 맞춰 보라/블루 톤
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }