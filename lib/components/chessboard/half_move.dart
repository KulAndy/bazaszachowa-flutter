import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

class HalfMove extends TextSpan {
  HalfMove({
    required this.doMove,
    this.move = "",
    this.isCurrent = false,
    this.isMain = true,
  }) : super(
         style: TextStyle(
           fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
           color: isCurrent ? Colors.orange : null,
         ),
         text: "$move ",
         recognizer: TapGestureRecognizer()..onTap = doMove,
       );
  final String move;
  final VoidCallback doMove;
  final bool isCurrent;
  final bool isMain;
}
