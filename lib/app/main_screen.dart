import 'package:flutter/material.dart';
import 'package:math_escape/App/main_view.dart';
import '../Core/services/service_locator.dart';

/// 메인 화면 (MainView를 사용하는 래퍼)
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ServiceLocator에서 MainViewModel 가져오기
    final viewModel = serviceLocator.mainViewModel;

    // MainView에 ViewModel 주입
    return MainView(viewModel: viewModel);
  }
}
