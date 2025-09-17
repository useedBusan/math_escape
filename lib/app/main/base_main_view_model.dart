//
// import 'package:flutter/material.dart';
//
// import '../../core/services/navigation_service.dart';
// import '../../core/utils/view_model/base_viewmodel.dart';
//
// /// 홈(미션 선택) 화면 전용 ViewModel
// class BaseMainViewModel extends BaseViewModel {
//   final NavigationService _navService;
//
//   BaseMainViewModel({required NavigationService navService})
//       : _navService = navService;
//
//   /// 학년별 카드 탭 처리
//   void onSchoolLevelCardTap(BuildContext context, String level) {
//     try {
//       _navService.navigateToMission(context, level);
//     } catch (e) {
//       setError('화면 이동 중 오류 발생: $e');
//     }
//   }
//
//   /// 에러 초기화
//   void clearErrorState() {
//     clearError();
//   }
// }
