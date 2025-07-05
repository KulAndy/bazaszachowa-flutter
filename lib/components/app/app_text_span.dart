import "package:flutter/material.dart";

class AppTextSpan extends TextSpan {
  AppTextSpan({
    required BuildContext context,
    super.text,
    TextStyle? style,
    Color? color,
    super.children,
  }) : super(
         style:
             style?.copyWith(
               color: color ?? style.color ?? _defaultColor(context),
             ) ??
             TextStyle(color: color ?? _defaultColor(context)),
       );

  static Color _defaultColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
}
