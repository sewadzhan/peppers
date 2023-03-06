import 'package:flutter/material.dart';
import 'package:pikapika_admin_panel/presentation/config/theme.dart';

class Constants {
  static const Color backgroundColor = Color(0xffF6F6F6);
  static const Color secondBackgroundColor = Colors.white;
  static const Color primaryColor = Color(0xFFEB573F);
  static const Color secondPrimaryColor = Color(0xFFFC7F72);
  static const Color darkPrimaryColor = Color.fromARGB(255, 162, 35, 15);

  static const Color darkGrayColor = Color(0xFF383838);
  static const Color lightGrayColor = Color(0xFFEAEAEA);
  static const Color middleGrayColor = Color(0xFF6C7383);

  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color dividerColor = Color(0xFFEAEAEA);
  static const Color textFieldGrayColor = Color(0xFFC7C7C7);
  static const Color buttonTextColor = Colors.white;

  static const Color successColor = Color(0xFF00C288);
  static const Color errorColor = Color(0xFFFF5E50);

  static double defaultPadding = 20;

  static TextTheme textTheme = CustomTheme.usualTextTheme;

  static SnackBar errorSnackBar(BuildContext context, String text,
      {duration = const Duration(milliseconds: 500)}) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Constants.errorColor,
      duration: duration,
      content: Text(
        text,
        style: Constants.textTheme.headlineSmall!.copyWith(color: Colors.white),
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
        style: Constants.textTheme.headlineSmall!.copyWith(color: Colors.white),
      ),
    );
  }

  static SnackBar loadingSnackBar(BuildContext context, {String? title}) {
    return SnackBar(
      dismissDirection: DismissDirection.none,
      backgroundColor: Constants.primaryColor,
      duration: const Duration(seconds: 777),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? "Загрузка...",
              style: Constants.textTheme.headlineSmall!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(
              width: 21,
              height: 21,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Constants.buttonTextColor),
            )
          ],
        ),
      ),
    );
  }

  //Check for changing theme for small devices
  static void checkThemeForSmallDevices(double width) {
    if (width <= 450) {
      textTheme = CustomTheme.smallTextTheme;
      defaultPadding = 16;
    }
  }

  //Get number of columns in GridView depending on device width
  static int getCrossAxisCount(double width) {
    if (width > 1600) {
      return 8;
    }
    if (width > 1400) {
      return 7;
    }
    if (width > 1200) {
      return 6;
    }
    if (width > 1000) {
      return 5;
    } else if (width > 640) {
      return 4;
    } else if (width > 300) {
      return 3;
    }
    return 2;
  }
}
