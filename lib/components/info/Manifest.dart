import 'package:bazaszachowa_flutter/components/app/Separator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Manifest extends StatelessWidget {
  const Manifest({super.key});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Z uwagi na to, że aktualnie w Polsce nie ma serwisu udostępniającego partie szachowe, '
          'bo jedyny istniejący został zawieszony, a jest to idea godna kontynuowania, '
          'lecz PZSzach, czy którykolwiek WZSzach nie jest zainteresowany takim projektem, '
          'powstała ta strona. \nStrona z założenia ma pomagać graczom w przygotowaniu, '
          'co pomoże w podwyższeniu poziomu sportowego. Osoby, które w nieuczciwy sposób '
          'chcą zyskać przewagę poprzez usunięcie ich z bazy powinny zapoznać się z takimi pojęciami jak ',
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'honor',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      _launchURL('https://pl.wikipedia.org/wiki/Honor_(etyka)'),
              ),
              const TextSpan(text: ', '),
              TextSpan(
                text: 'godność człowieka',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      _launchURL('https://pl.wikipedia.org/wiki/Godność'),
              ),
              const TextSpan(text: ' i '),
              TextSpan(
                text: 'postawa fair play',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      _launchURL('https://pl.wikipedia.org/wiki/Fair_play'),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        Separator(height: 10),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text:
                    'Baza partii będzie aktualizowana mniej więcej raz na miesiąc i można z niej korzystać w zgodzie z zamieszczoną na stronie ',
              ),
              TextSpan(
                text: 'licencją',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _launchURL('https://example.com/license'),
              ),
              const TextSpan(text: ' 🍺.'),
            ],
          ),
        ),
      ],
    );
  }
}
