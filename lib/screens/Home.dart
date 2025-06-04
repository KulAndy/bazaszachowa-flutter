import 'package:bazaszachowa_flutter/components/app/Separator.dart';
import 'package:bazaszachowa_flutter/components/info/Manifest.dart';
import 'package:bazaszachowa_flutter/components/info/UsefulLinks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    );
  }
}
