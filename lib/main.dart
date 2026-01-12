import 'package:flutter/material.dart';
import 'core/theme/theme_data.dart';
import 'ui/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Generator & Scanner',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(title: 'QR Generator & Scanner'),
    );
  }
}
