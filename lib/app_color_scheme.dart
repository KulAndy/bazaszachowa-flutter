import "package:flutter/material.dart";

class AppColors {
  static const Color lightBackground = Color(0xFFFAEBD7); // AntiqueWhite
  static const Color lightFontColor = Colors.black;
  static const Color lightFooter = Color(0xFFD2B48C); // Tan
  static const Color lightLink = Colors.black;
  static const MaterialColor lightLinkHover = Colors.grey;
  static const Color lightContentBackground = Color(0xFFF5EEE6); // Seashell
  static const Color lightActive = Color(0xFFCD853F); // Peru
  static const Color lightEvenRow = Color(0xFFF0F8FF); // AliceBlue
  static const Color lightOddRow = Color(0xFFDEB887); // BurlyWood

  static const Color darkBackground = Color(0xFF05445E);
  static const Color darkFontColor = Color(0xFFF2F2F2);
  static const Color darkFooter = Color(0xFF2F3645);
  static const Color darkLink = Color(0xFF189AB4);
  static const Color darkLinkHover = Color(0xFFE6754B);
  static const Color darkContentBackground = Color(0xFF033C47);
  static const Color darkActive = Color(0xFFD4F1F4);
  static const Color darkEvenRow = Color(0xFF444444);
  static const Color darkOddRow = Color(0xFF333333);

  static const Color middleGray = Color(0xFF808080);
}

// ignore: avoid_classes_with_only_static_members
class AppColorScheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: const Color(0xFF189AB4),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.lightFontColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightFooter,
      foregroundColor: AppColors.lightFontColor,
    ),
    cardColor: AppColors.lightContentBackground,
    highlightColor: AppColors.lightActive,
    dividerColor: AppColors.middleGray,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightFontColor,
        foregroundColor: AppColors.lightFontColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: const Color(0xFF189AB4),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkFontColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkFooter,
      foregroundColor: AppColors.darkFontColor,
    ),
    cardColor: AppColors.darkContentBackground,
    highlightColor: AppColors.darkActive,
    dividerColor: AppColors.middleGray,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkFooter,
        foregroundColor: AppColors.darkFontColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
