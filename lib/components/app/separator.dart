import "package:flutter/material.dart";

class Separator extends StatelessWidget {
  const Separator({
    super.key,
    this.height = 10,
    this.color,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });
  final double height;
  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      SizedBox(height: height),
      Divider(
        color: color,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      ),
      SizedBox(height: height),
    ],
  );
}
