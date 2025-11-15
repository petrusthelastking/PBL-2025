import 'package:flutter/material.dart';
import 'package:jawara/core/theme/app_theme.dart';
import 'package:jawara/features/splash/splash_page.dart';

class JawaraApp extends StatelessWidget {
  const JawaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jawara',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashPage(),
    );
  }
}
