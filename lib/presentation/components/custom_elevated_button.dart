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
      this.width})
      : super(key: key);

  final String text;
  final bool isLoading;

  final Function function;
  final bool fullWidth;
  final bool isEnabled;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: 48,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              disabledBackgroundColor: Constants.primaryColor,
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
                  style: Constants.textTheme.headline4!
                      .copyWith(color: Constants.buttonTextColor),
                )),
    );
  }
}
