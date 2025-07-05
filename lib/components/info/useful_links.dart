import "package:bazaszachowa_flutter/components/app/link.dart";
import "package:flutter/material.dart";

const Map<String, List<String>> links = <String, List<String>>{
  "Alternatywa": <String>[
    "https://www.yottachess.com/",
    "https://www.chessbites.com/",
    "https://chessify.me/analysis/chess-database",
    "https://chess-results.com/PartieSuche.aspx?lan=3",
  ],
  "Darmowy program szachowy": <String>["http://scidvspc.sourceforge.net/"],
  "Najlepszy silnik szachowy": <String>["https://stockfishchess.org/"],
  "W pełni wolna strona szachowa": <String>["https://lichess.org/"],
};

class UsefulLinks extends StatelessWidget {
  const UsefulLinks({super.key});

  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Przydatne linki"),
          ...links.entries.map((MapEntry<String, List<String>> entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(entry.key),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entry.value.map((String url) => RichText(
                      text: Link(text: url, href: url, context: context),
                    )).toList(),
                ),
              ],
            )),
        ],
      ),
    );
}
