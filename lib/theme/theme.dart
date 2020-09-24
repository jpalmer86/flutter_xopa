import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme(
  brightness: Brightness.light,

  //Surface colors
  surface: Colors.white,
  onSurface: Colors.black,

  //Primary Color
  primary: const Color(0xff01579B),
  primaryVariant: const Color(0xff01579B),
  onPrimary: Colors.white,

  //Secondary Color
  secondary: const Color(0xff00796B),
  secondaryVariant: const Color(0xff00796B),
  onSecondary: Colors.white,

  //Background Color
  background: Colors.white,
  onBackground: Colors.black,

  //Error Color
  error: Colors.redAccent,
  onError: Colors.white,
);

final darkColorScheme = colorScheme;

final textTheme = TextTheme(
  headline6: const TextStyle(fontFamily: 'Jost', fontSize: 24),
  overline: GoogleFonts.roboto(fontSize: 24),
  bodyText1: GoogleFonts.roboto(fontSize: 18),
  button: GoogleFonts.roboto(fontSize: 14),
  subtitle2: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w300),
  //TODO
);

final appTheme = ThemeData(
  brightness: colorScheme.brightness,
  colorScheme: colorScheme,
  textTheme: textTheme,
  primaryTextTheme: textTheme,
  accentTextTheme: textTheme,
  primaryColor: colorScheme.primary,
  accentColor: colorScheme.secondary,
  backgroundColor: colorScheme.background,
  //TODO
);

final appDarkTheme = ThemeData(
  brightness: darkColorScheme.brightness,
  colorScheme: darkColorScheme,
  textTheme: textTheme,
  primaryTextTheme: textTheme,
  accentTextTheme: textTheme,
  primaryColor: darkColorScheme.primary,
  accentColor: darkColorScheme.secondary,
  backgroundColor: darkColorScheme.background,
);

/// Other App-wide configuration values
class AppTheme {

  AppTheme._();

  static final ShapeBorder roundedBoxShape = new RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

}