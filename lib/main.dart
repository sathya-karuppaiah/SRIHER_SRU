import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

import 'screens/admin/admin_dashboard_screen.dart';

void main() {
  runApp(const SrihersBackstageApp());
}

class SrihersBackstageApp extends StatelessWidget {
  const SrihersBackstageApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String initialRoute = (Uri.base.fragment.contains('admin') || Uri.base.path.contains('admin'))
        ? '/admin'
        : '/';

    return MaterialApp(
      title: "Srihers Backstage",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const MyCustomScrollBehavior(),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const SplashScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name != null && settings.name!.contains('/admin')) {
          return MaterialPageRoute(
            builder: (context) => const AdminDashboardScreen(),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: settings,
        );
      },
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
