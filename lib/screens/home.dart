import "package:bazaszachowa_flutter/components/app/menu.dart";
import "package:bazaszachowa_flutter/components/app/separator.dart";
import "package:bazaszachowa_flutter/components/info/manifest.dart";
import "package:bazaszachowa_flutter/components/info/useful_links.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  String get title => "Strona główna";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.title)),
    body: SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SvgPicture.asset(
                "assets/images/logo.svg",
                semanticsLabel: "Chess Logo",
              ),
              const UsefulLinks(),
              const Separator(),
              const Manifest(),
            ],
          ),
        ),
      ),
    ),
    drawer: const Menu(),
  );
}
