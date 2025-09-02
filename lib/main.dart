import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rk4_solver/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final rounded = GoogleFonts.mPlusRounded1cTextTheme();
    final roundedTuned = rounded.copyWith(
      bodyMedium: rounded.bodyMedium?.copyWith(height: 1.35),
      titleLarge: rounded.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '物理シミュレーション：二重振り子',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
        // Friendly rounded Japanese UI font for body/headings.
        textTheme: roundedTuned,
        // When Latin Modern Roman is added to assets and registered in pubspec,
        // you can switch to it by setting:
        // fontFamily: 'LatinModernRoman',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
