import 'package:flutter/material.dart';
import '../core/services/service_locator.dart';
import 'main_view.dart';


/// 메인 화면 (MainView를 사용하는 래퍼)
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ServiceLocator에서 MainViewModel 가져오기
    final viewModel = serviceLocator.mainViewModel;

    // MainView에 ViewModel 주입
    return MainView(viewModel: viewModel,);
  }
}
