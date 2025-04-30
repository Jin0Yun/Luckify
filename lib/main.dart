import 'package:flutter/material.dart';
import 'package:luckify/presentation/screen/home_screen.dart';
import 'package:luckify/core/theme/luckify_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: LuckifyColors.white,
        primaryColor: LuckifyColors.primary,
        fontFamily: 'Moneygraphy',
      ),
      home: const HomeScreen(),
    );
  }
}