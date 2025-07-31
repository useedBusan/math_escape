import 'package:flutter/material.dart';
import 'package:math_escape/screens/splash_screen.dart';
import 'package:math_escape/screens/main_screen.dart';
import 'package:math_escape/constants/app_constants.dart';
import 'package:math_escape/theme/app_theme.dart';

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
