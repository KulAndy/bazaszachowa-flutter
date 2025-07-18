import "package:bazaszachowa_flutter/screens/games.dart";
import "package:bazaszachowa_flutter/screens/home.dart";
import "package:bazaszachowa_flutter/screens/license.dart";
import "package:bazaszachowa_flutter/screens/players.dart";
import "package:bazaszachowa_flutter/screens/search_preparation.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          child: SvgPicture.asset(
            "assets/images/logo.svg",
            semanticsLabel: "Chess Logo",
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home_filled),
          title: const Text("Strona główna"),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const Home(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_search),
          title: const Text("Zawodnicy"),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const Players(),
              ),
            );
          },
        ),
        ListTile(
          leading: const SizedBox(
            width: 32,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.chessBoard, size: 20),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 12),
                ),
              ],
            ),
          ),
          title: const Text("Partie"),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const Games(),
              ),
            );
          },
        ),
        ListTile(
          leading: const FaIcon(FontAwesomeIcons.brain),
          title: const Text("Przygotowanie"),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const SearchPreparation(),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.policy),
          title: const Text("Licencja"),
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const License(),
              ),
            );
          },
        ),
      ],
    ),
  );
}
