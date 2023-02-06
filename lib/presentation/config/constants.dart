import 'package:flutter/material.dart';
import 'package:pikapika_admin_panel/presentation/config/theme.dart';

class Constants {
  static const Color backgroundColor = Color(0xffF6F6F6);
  static const Color primaryColor = Color(0xFFEB573F);
  static const Color secondPrimaryColor = Color(0xFFFC7F72);
  static const Color darkPrimaryColor = Color.fromARGB(255, 162, 35, 15);

  static const Color darkGrayColor = Color(0xFF383838);
  static const Color middleGrayColor = Color(0xFF959595);
  static const Color lightGrayColor = Color(0xFFEAEAEA);

  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color dividerColor = Color(0xFFEAEAEA);
  static const Color textFieldGrayColor = Color(0xFFC7C7C7);
  static const Color buttonTextColor = Colors.white;

  static const Color successColor = Color(0xFF00C288);
  static const Color errorColor = Color(0xFFFF5E50);

  static const double defaultPadding = 20;

  static TextTheme textTheme = CustomTheme.usualTextTheme;

  static SnackBar errorSnackBar(BuildContext context, String text,
      {duration = const Duration(milliseconds: 500)}) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Constants.errorColor,
      duration: duration,
      content: Text(
        text,
        style: Constants.textTheme.headline5!.copyWith(color: Colors.white),
      ),
    );
  }

  static SnackBar successSnackBar(BuildContext context, String text,
      {duration = const Duration(milliseconds: 300)}) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Constants.successColor,
      duration: duration,
      content: Text(
        text,
        style: Constants.textTheme.headline5!.copyWith(color: Colors.white),
      ),
    );
  }
}
