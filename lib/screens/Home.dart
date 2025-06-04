import 'package:bazaszachowa_flutter/components/app/Menu.dart';
import 'package:bazaszachowa_flutter/components/app/Separator.dart';
import 'package:bazaszachowa_flutter/components/info/Manifest.dart';
import 'package:bazaszachowa_flutter/components/info/UsefulLinks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/logo.svg',
                semanticsLabel: 'Chess Logo',
              ),
              UsefulLinks(),
              Separator(height: 10),
              Manifest(),
            ],
          ),
        ),
      ),
      drawer: Menu(),
    );
  }
}
