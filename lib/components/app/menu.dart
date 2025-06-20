import 'package:bazaszachowa_flutter/screens/home.dart';
import 'package:bazaszachowa_flutter/screens/players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            title: const Text("Strona głowna"),
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
        ],
      ),
    );
  }
}
