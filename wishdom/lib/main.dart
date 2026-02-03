import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const WishdomApp());
}

class WishdomApp extends StatelessWidget {
  const WishdomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wishdom',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.modernDark,
      home: const MainScreen(),
    );
  }
}
