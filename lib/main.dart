import 'package:flutter/material.dart';

import 'screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baza szachowa',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF189AB4),
          primaryContainer: const Color(0xFF75E6DA),
          secondary: const Color(0xFF05445E),
          secondaryContainer: const Color(0xFFD4F1F4),
          surface: const Color(0xFF033C47),
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(color: Color(0xFF05445E)),
        useMaterial3: true,
      ),
      home: const Home(title: 'Baza szachowa'),
      debugShowCheckedModeBanner: false,
    );
  }
}
