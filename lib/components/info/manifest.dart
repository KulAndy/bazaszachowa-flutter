import 'package:bazaszachowa_flutter/components/app/link.dart';
import 'package:bazaszachowa_flutter/components/app/separator.dart';
import 'package:flutter/material.dart';

class Manifest extends StatelessWidget {
  const Manifest({super.key});

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
              Link(
                text: 'licencją',
                context: context,
                href: 'https://bazaszachowa.smallhost.pl/license/',
              ),
              const TextSpan(text: ' 🍺.'),
            ],
          ),
        ),
      ],
    );
  }
}
