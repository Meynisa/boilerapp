import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData themeData = new ThemeData(
  fontFamily: 'Roboto',
  brightness: Brightness.light,
  accentColor: SwatchColor.kLightBlueGreen,
  accentColorBrightness: Brightness.light,
);

final ThemeData darkThemeData = new ThemeData(
  fontFamily: 'Roboto',
  brightness: Brightness.dark,
  primarySwatch: SwatchColor.kBlueGreen,
  accentColor: SwatchColor.kLightBlueGreen,
  accentColorBrightness: Brightness.dark
);

final TextStyle textFieldStyle = new TextStyle(
  fontFamily: "Roboto",
  color: SwatchColor.kLightBlueGreen,
  fontWeight: FontWeight.normal,
);
