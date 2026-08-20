import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SrihersBackstageApp());
}

class SrihersBackstageApp extends StatelessWidget {
  const SrihersBackstageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Srihers Backstage",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const MyCustomScrollBehavior(),
      home: const SplashScreen(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  const MyCustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
