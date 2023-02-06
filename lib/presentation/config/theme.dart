import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class CustomTheme {
  static TextTheme usualTextTheme = const TextTheme(
    headline1: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    headline2: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    headline3: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    headline4: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    headline5: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    headline6: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
    bodyText1: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
    bodyText2: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    ),
  );

  static TextTheme smallTextTheme = const TextTheme(
    headline1: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 26,
    ),
    headline2: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    headline3: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    headline4: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 14.5,
    ),
    headline5: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 12.5,
    ),
    headline6: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 11,
    ),
    bodyText1: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 12.5,
    ),
    bodyText2: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 11,
    ),
  );

  static ThemeData get theme => ThemeData(
      scaffoldBackgroundColor: Constants.backgroundColor,
      primaryColor: const Color(0xFFEB573F),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xFFEB573F),
        primary: const Color(0xFFEB573F),
      ),
      textTheme: GoogleFonts.ralewayTextTheme()
          .apply(bodyColor: Constants.darkGrayColor));
}
