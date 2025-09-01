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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pendulum Simulation',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
        // TeX-like serif via Google Fonts (EB Garamond as a close alternative).
        textTheme: GoogleFonts.ebGaramondTextTheme(),
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
