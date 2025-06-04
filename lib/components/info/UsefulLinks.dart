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

  Future<void> _launchURL(BuildContext context, String url) async {
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
                    return GestureDetector(
                      onTap: () => _launchURL(context, url),
                      child: Text(
                        _extractDomain(url),
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
