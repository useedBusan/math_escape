import 'package:flutter/material.dart';
import 'package:math_escape/screens/splash_screen.dart';
import 'package:math_escape/screens/main_screen.dart';
import 'package:math_escape/constants/app_constants.dart';
import 'package:math_escape/theme/app_theme.dart';
import 'package:math_escape/mission/elementary_high/elementary_high_mission.dart';
import 'package:math_escape/mission/elementary_high/elementary_high_talk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
