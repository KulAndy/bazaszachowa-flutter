import 'package:bazaszachowa_flutter/screens/home.dart';
import 'package:bazaszachowa_flutter/screens/license.dart';
import 'package:bazaszachowa_flutter/screens/players.dart';
import 'package:bazaszachowa_flutter/screens/games.dart';
import 'package:bazaszachowa_flutter/screens/search_preparation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              semanticsLabel: 'Chess Logo',
            ),
          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: const Text("Strona główna"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Home(title: "Strona główna"),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_search),
            title: const Text("Zawodnicy"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Players(title: "Zawodnicy"),
                ),
              );
            },
          ),
          ListTile(
            leading: SizedBox(
              width: 32,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
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
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Games(title: "Partie")),
              );
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.brain),
            title: const Text("Przygotowanie"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      SearchPreparation(title: "Przygotowanie"),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.policy),
            title: const Text("Licencja"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => License(title: "Licencja"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
