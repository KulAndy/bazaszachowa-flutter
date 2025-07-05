import "package:bazaszachowa_flutter/app_color_scheme.dart";
import "package:bazaszachowa_flutter/screens/home.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // ignore: unreachable_from_main
  static Future<void> launchURL(BuildContext context, String url) async {
    final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(
      context,
    );
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text("Could not launch $url")),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Error launching URL: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "Baza szachowa",
    theme: AppColorScheme.lightTheme,
    darkTheme: AppColorScheme.darkTheme,
    home: const Home(title: "Baza szachowa"),
    debugShowCheckedModeBanner: false,
  );
}
