import 'package:flutter/material.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {Key? key,
      required this.text,
      required this.function,
      this.fullWidth = true,
      this.isEnabled = true,
      this.isLoading = false,
      this.width,
      this.height = 48,
      this.fontSize,
      this.alternativeStyle = false,
      this.backgroundColor = Constants.primaryColor,
      this.autoFocus = false})
      : super(key: key);

  final String text;
  final bool isLoading;

  final Function function;
  final bool fullWidth;
  final bool isEnabled;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool alternativeStyle;
  final Color backgroundColor;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: ElevatedButton(
          autofocus: autoFocus,
          style: ElevatedButton.styleFrom(
              backgroundColor: alternativeStyle
                  ? Constants.secondBackgroundColor
                  : backgroundColor,
              side: alternativeStyle
                  ? BorderSide(
                      width: 1.5,
                      color: backgroundColor,
                    )
                  : null,
              elevation: 0,
              disabledBackgroundColor: alternativeStyle
                  ? Constants.secondBackgroundColor
                  : backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0))),
          onPressed: isEnabled
              ? () {
                  function();
                }
              : null,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Constants.buttonTextColor,
                  ),
                )
              : Text(
                  text,
                  style: Constants.textTheme.headlineMedium!.copyWith(
                      color: alternativeStyle
                          ? Constants.primaryColor
                          : Constants.buttonTextColor,
                      fontSize: fontSize),
                )),
    );
  }
}
