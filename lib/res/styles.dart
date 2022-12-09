import 'package:flutter/material.dart';

import 'colors.dart';

class Styles {
  static const TextStyle body1 = TextStyle(
    color: AppColors.darkGray,
    fontWeight: FontWeight.w400,
    fontFamily: "Roboto",
    fontStyle: FontStyle.normal,
    letterSpacing: LetterSpacing.smaller,
    height: FontHeight.standart,
    fontSize: 16.0,
  );
}

class FontHeight {
  static const double standart = 1.5;
  static const double smaller = 1.42;
  static const double small = 1.34;
  static const double moresmall = 1.2;
  static const double smallest = 1.16;
}

class LetterSpacing {
  static const double smaller = 0.1;
  static const double normal = 0.15;
  static const double bigger = 0.45;
}
