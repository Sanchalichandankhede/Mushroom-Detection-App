import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MycelialLayerApp());
}

class MycelialLayerApp extends StatelessWidget {
  const MycelialLayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mycelial Layer',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
