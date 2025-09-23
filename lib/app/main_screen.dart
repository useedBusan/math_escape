import 'package:flutter/material.dart';
import '../core/services/service_locator.dart';
import 'main/base_main_view.dart';


/// 메인 화면 (BaseMainView를 사용하는 래퍼)
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // BaseMainView 사용
    return const BaseMainView();
  }
}
