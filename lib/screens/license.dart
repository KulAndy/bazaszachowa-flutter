// ignore_for_file: lines_longer_than_80_chars

import "package:bazaszachowa_flutter/components/app/app_text_span.dart";
import "package:bazaszachowa_flutter/components/app/link.dart";
import "package:bazaszachowa_flutter/components/app/menu.dart";
import "package:bazaszachowa_flutter/components/app/separator.dart";
import "package:flutter/material.dart";

class License extends StatefulWidget {
  const License({super.key});

  String get title => "Licencja";

  @override
  State<License> createState() => _LicenseState();
}

class _LicenseState extends State<License> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Całość strony jest udostępniona na następujących zasadach:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("użytkownik:"),
            const SizedBox(height: 4),
            const BulletList(
              items: <String>[
                "ma prawo używać strony w dowolnym celu",
                "ma prawo do analizowania strony*",
                "ma prawo do kopiowania strony*",
                "ma prawo do udoskonalania i publicznego rozpowszechniania ulepszeń strony*",
                "nie może zmienić licencji",
                "nie może pobierać opłat za projekt, w którym został wykorzystany jakikolwiek element z tej strony*",
                "jeśli skorzysta z wyszukiwarki, to ma obowiązek sprawdzenia swoich gier na dany moment z minimum ostatnich 3 lat przynajmniej z bazy z której korzystał i zgłoszenia ewentualnych błędów",
                "zobowiązuje się postawić piwo autorowi strony",
                "zgłaszać błędy w partiach mogą tylko osoby, których dane są publicznie dostępne (np. zarejestrowani w FIDE, PZSzach lub ich partie znajdują się w bazie)",
              ],
            ),
            const SizedBox(height: 12),
            RichText(
              text: AppTextSpan(
                children: <InlineSpan>[
                  const TextSpan(
                    text: "* kod źródłowy dostępny na githubie – ",
                  ),
                  Link(
                    text: "frontend",
                    context: context,
                    href: "https://github.com/KulAndy/bazaszachowa",
                  ),

                  const TextSpan(text: " i "),
                  Link(
                    text: "backend",
                    context: context,
                    href: "https://github.com/KulAndy/bazaszachowa-api",
                  ),
                ],
                context: context,
              ),
            ),
            const Separator(),
            RichText(
              text: AppTextSpan(
                children: <InlineSpan>[
                  const TextSpan(
                    text:
                        "we wszystkich innych przypadkach obowiązuje licencja ",
                  ),
                  Link(
                    text: "GNU AGPLv3",
                    context: context,
                    href: "https://www.gnu.org/licenses/agpl-3.0.html",
                  ),
                ],
                context: context,
              ),
            ),
            const Separator(),
          ],
        ),
      ),
    ),
    drawer: const Menu(),
  );
}

class BulletList extends StatelessWidget {
  const BulletList({required this.items, super.key});
  final List<String> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items
        .map(
          (String item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("• "),
                Expanded(child: Text(item)),
              ],
            ),
          ),
        )
        .toList(),
  );
}
