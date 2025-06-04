import 'package:bazaszachowa_flutter/components/app/Link.dart';
import 'package:bazaszachowa_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UsefulLinks extends StatelessWidget {
  final Map<String, List<String>> links = {
    'Alternatywa': [
      'https://www.yottachess.com/',
      'https://www.chessbites.com/',
      'https://chessify.me/analysis/chess-database',
      'https://chess-results.com/PartieSuche.aspx?lan=3',
    ],
    'Darmowy program szachowy': ['http://scidvspc.sourceforge.net/'],
    'Najlepszy silnik szachowy': ['https://stockfishchess.org/'],
    'W pełni wolna strona szachowa': ['https://lichess.org/'],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Przydatne linki'),
          ...links.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entry.value.map((url) {
                    return RichText(
                      text: Link(text: url, href: url, context: context),
                    );
                  }).toList(),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  String _extractDomain(String url) {
    return url.replaceAll(RegExp(r'https?://|www\.|/.*$'), '');
  }
}
