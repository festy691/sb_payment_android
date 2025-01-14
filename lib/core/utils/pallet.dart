import 'dart:math';

import 'package:flutter/material.dart';
class Pallet {
  Pallet._();
  // LIGHT COLOURS

  static const Color scaffoldBackgroundLight = Colors.white;
  static const primary = MaterialColor(0xFF039855, _primaryColor);
  static const secondary = MaterialColor(0xFF0A3982, _secondaryColor);
  static const grey = MaterialColor(0xFF5F5F5F, _greyColor);
  static const warning = MaterialColor(0xFFCAB166, _warningColor);
  static const accent = MaterialColor(0xFF0E6296, _accentColor);
  static const error = MaterialColor(0xFFDC0000, _errorColor);
  static const success = MaterialColor(0xFF009262, _successColor);
  static const black = Color(0xFF212121);
  static const white = Colors.white;
  static const orange = Color(0xFFF79009);
  static const orangeDark = Color(0xFFE34802);
  static const Color backgroundLight = Colors.white;
  static Color? dividerColor = const Color(0xFFF2F4F7);

  // DARK COLOURS
  static const Color scaffoldBackgroundDark = Color(0xFF010A18);
  static const Color backgroundDark = Color(0xFF212121); //Colors.black;

  //GLOBAL COLORS
  Color scaffoldBackground = scaffoldBackgroundLight;
  static String getRandomColor() => Color.fromARGB(255, Random().nextInt(255),
          Random().nextInt(255), Random().nextInt(255))
      .value
      .toRadixString(16);
}

const Map<int, Color> _primaryColor = {
  50: Color(0xFFEEF4EB),
  100: Color(0xFFCADEC1),
  200: Color(0xFF039855),
  300: Color(0xFF44772D),
  400: Color(0xFF039754),
  500: Color(0xFF1E3414),
  600: Color(0xFF335922),
  700: Color(0xff09663C),
};
const Map<int, Color> _secondaryColor = {
  50: Color(0xFFE7EDF6),
  100: Color(0xFFB4C6E2),
  200: Color(0xFF0C47A3),
  300: Color(0xFF0A3982),
  400: Color(0xFF072B62),
  500: Color(0xFF041939),
  600: Color(0xFF212121),
  700: Color(0xFF082E68),
};
const Map<int, Color> _accentColor = {
  50: Color(0xFFE7F2F8),
  100: Color(0xFFB6D6EA),
  200: Color(0xFF127ABC),
  300: Color(0xFF0E6296),
  400: Color(0xFF0B4971),
  500: Color(0xFF062B42),
  600: Color(0xFF667085),
};
const Map<int, Color> _successColor = {
  50: Color(0xFFF1FAF7),
  100: Color(0xFF84DFC1),
  200: Color(0xFF32C997),
  300: Color(0xFF009262),
  400: Color(0xFF1B6E53),
  500: Color(0xFF105B42),
  600: Color(0xFF039855),
};
const Map<int, Color> _warningColor = {
  50: Color(0xFFFFFCF2),
  100: Color(0xFFF3F4D8),
  200: Color(0xFFFDDD80),
  300: Color(0xFFCAB166),
  400: Color(0xFF98854D),
  500: Color(0xFF594D2D),
  600:Color(0xFFFBFFFA),
  700: Color(0xfFABBED1)

};
const Map<int, Color> _errorColor = {
  50: Color(0xFFFCE6E6),
  100: Color(0xFFF4B0B0),
  200: Color(0xFFDC0000),
  300: Color(0xFFB00000),
  400: Color(0xFF840000),
  500: Color(0xFF4D0000),
};
const Map<int, Color> _greyColor = {
  50: Color(0xFFEFEFEF),
  100: Color(0xFFCDCDCD),
  200: Color(0xFF5F5F5F),
  300: Color(0xFF4C4C4C),
  400: Color(0xFF393939),
  500: Color(0xFFF7F7F7),
  600: Color(0xFFA7A7A7),
  700: Color(0xFFA4A4A4),
  800: Color(0xFF7F7F7F),
  900: Color(0xFFF5F4F7),
};
