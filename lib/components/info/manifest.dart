import 'package:bazaszachowa_flutter/components/app/app_text_span.dart';
import 'package:bazaszachowa_flutter/components/app/link.dart';
import 'package:bazaszachowa_flutter/components/app/separator.dart';
import 'package:flutter/material.dart';
import 'package:bazaszachowa_flutter/screens/license.dart';
import 'package:flutter/gestures.dart';

class Manifest extends StatelessWidget {
  const Manifest({super.key});

  @override
  Widget build(BuildContext context) {
    final TapGestureRecognizer recognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const License(title: "Licencja"),
          ),
        );
      };

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
          text: AppTextSpan(
            children: <TextSpan>[
              Link(
                text: 'honor',
                href: 'https://pl.wikipedia.org/wiki/Honor_(etyka)',
                context: context,
              ),
              const TextSpan(text: ', '),
              Link(
                text: 'godność człowieka',
                context: context,
                href: 'https://pl.wikipedia.org/wiki/Godność',
              ),
              const TextSpan(text: ' i '),
              Link(
                text: 'postawa fair play',
                context: context,
                href: 'https://pl.wikipedia.org/wiki/Fair_play',
              ),
              const TextSpan(text: '.'),
            ],
            context: context,
          ),
        ),
        const Separator(height: 10),
        RichText(
          text: AppTextSpan(
            children: <TextSpan>[
              const TextSpan(
                text:
                    'Baza partii będzie aktualizowana mniej więcej raz na miesiąc i można z niej korzystać w zgodzie z zamieszczoną na stronie ',
              ),
              TextSpan(
                text: "licencją",
                style: const TextStyle(
                  color: Colors.lightBlue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: recognizer,
              ),
              const TextSpan(text: ' 🍺.'),
            ],
            context: context,
          ),
        ),
      ],
    );
  }
}
