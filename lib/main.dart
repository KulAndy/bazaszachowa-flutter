import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'screens/Home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static Future<void> launchURL(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error launching URL: $e')));
    }
  }

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
