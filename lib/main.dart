import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_color_scheme.dart';
import 'screens/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  final ThemeMode themeMode = ThemeMode.system;
  const App({super.key});

  static Future<void> launchURL(BuildContext context, String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baza szachowa',
      theme: AppColorScheme.lightTheme,
      darkTheme: AppColorScheme.darkTheme,
      themeMode: themeMode,
      home: const Home(title: 'Baza szachowa'),
      debugShowCheckedModeBanner: false,
    );
  }
}
