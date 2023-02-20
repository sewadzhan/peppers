import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class CustomTheme {
  static TextTheme usualTextTheme = const TextTheme(
    displayLarge: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    displayMedium: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    displaySmall: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    headlineMedium: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    headlineSmall: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
    titleLarge: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    ),
    bodyLarge: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
    bodyMedium: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    ),
    bodySmall: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 10,
    ),
  );

  static TextTheme smallTextTheme = const TextTheme(
    displayLarge: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 26,
    ),
    displayMedium: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    displaySmall: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    headlineMedium: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 14.5,
    ),
    headlineSmall: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 12.5,
    ),
    titleLarge: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.bold,
      fontSize: 11,
    ),
    bodyLarge: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 12.5,
    ),
    bodyMedium: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 11,
    ),
    bodySmall: TextStyle(
      color: Constants.darkGrayColor,
      fontWeight: FontWeight.normal,
      fontSize: 9,
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
