import "package:bazaszachowa_flutter/main.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

class Link extends TextSpan {
  Link({
    required String text,
    required String href,
    required BuildContext context,
  }) : super(
         text: text,
         style: const TextStyle(color: Colors.blue),
         recognizer: TapGestureRecognizer()
           ..onTap = () => App.launchURL(context, href),
       );
}
