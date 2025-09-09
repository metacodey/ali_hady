import 'package:flutter/material.dart';

class AppColors {
  static const Color bgCardDark = Color(0xFF2C2C2C);
  static const Color yellow = Color(0xFFF7D305);
  static const Color blueLight = Color.fromARGB(255, 217, 233, 249);
  static const Color yellowLight = Color.fromARGB(255, 242, 229, 155);
  static const Color yellowDark = Color.fromARGB(255, 191, 166, 23);
  static const Color greyLight = Color(0xFFDDDDDD);
  static const Color greyDark = Color(0xFF878787);
  static const Color blueVeryLight = Color(0xFFF2F3F7);
  static const Color redDark = Color(0xFFE91E25);
  static const Color redLight = Color.fromARGB(255, 255, 213, 214);
  static const Color greenDark = Color(0xFF00BC39);
  static const Color greenLight = Color.fromARGB(255, 218, 255, 229);
  static const Color kLightYellow1 = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color colorsBlue = Color(0xFF14385C);
  static const Color kPalePink = Color(0xFFFED4D6);
  static const Color kPaleP = Color(0x002b8db7);
  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFFD9E6DC);
  static const Color kGreen = Color(0xFF309397);
  static const Color greenBlueDark = Color(0xFF0e2324);
  static const Color greenBlueVeryLight = Color.fromARGB(255, 235, 240, 241);
  static const Color greenBlue = Color.fromARGB(255, 6, 110, 115);
  static const Color kDarkBlue = Color(0xFF0D253F);
  static const Color border = Color.fromARGB(255, 34, 154, 176);
  static const Color searchColor = Color.fromARGB(255, 30, 30, 30);
  static const Color white = Colors.white;
  static const Color iconSearch = Color.fromARGB(255, 100, 100, 100);
}

Gradient? gradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 2, 57, 88),
      Color.fromARGB(255, 26, 104, 149),
    ],
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 0.0),
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp);
final glowBoxShadow = [
  BoxShadow(
    color: const Color.fromARGB(255, 1, 33, 51).withOpacity(.4),
    blurRadius: 1.0,
    spreadRadius: 3.0,
    offset: const Offset(
      0.0,
      3.0,
    ),
  ),
];
const colorPrimaryDark = Color.fromARGB(255, 2, 57, 88);
const colorPrimaryWhite = Color.fromARGB(255, 26, 104, 149);

MaterialColor mcolor = const MaterialColor(
  0xFF023958,
  <int, Color>{
    50: Color(0xFF023958),
    100: Color(0xFF023958),
    200: Color(0xFF023958),
    300: Color(0xFF023958),
    400: Color(0xFF023958),
    500: Color(0xFF023958),
    600: Color(0xFF023958),
    700: Color(0xFF023958),
    800: Color(0xFF023958),
    900: Color(0xFF023958),
  },
);
const kFontColorPallets = [
  Color.fromRGBO(26, 31, 56, 1),
  Color.fromRGBO(72, 76, 99, 1),
  Color.fromRGBO(149, 149, 163, 1),
];
const kBorderRadius = 10.0;
const kSpacing = 20.0;
final List<Color> colors = [
  AppColors.kGreen,
  AppColors.kRed,
  AppColors.kDarkYellow,
  AppColors.kBlue,
];

List<Color> timelineColors = [
  Colors.black,
  Colors.white,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.red,
];

List<double> timelineStops = [
  0.0, // Black
  1 / 7, // Red
  2 / 7, // Blue
  3 / 7, // Green
  4 / 7, // Yellow
  5 / 7, // Purple
  6 / 7, // White
  1.0, // The last stop for White
];
