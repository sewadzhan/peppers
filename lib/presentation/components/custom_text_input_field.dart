import 'package:flutter/material.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';
import 'package:intl/intl.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField(
      {Key? key,
      required this.titleText,
      required this.hintText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.isShowDatePicker = false,
      this.onlyRead = false,
      this.maxLines = 1,
      this.onTap,
      this.onChanged,
      this.isObscure = false})
      : super(key: key);

  final String titleText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isShowDatePicker;
  final bool onlyRead;
  final int maxLines;
  final Function? onTap;
  final Function(String)? onChanged;
  final bool isObscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: Constants.textTheme.headline5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            onChanged: onChanged,
            onTap: () async {
              if (isShowDatePicker) {
                DateTime? date = await showDatePicker(
                  locale: const Locale("ru", "RU"),
                  cancelText: "Отмена",
                  confirmText: "Выбрать",
                  context: context,
                  initialDate: controller.text.isEmpty
                      ? DateTime.now()
                      : DateFormat('dd.MM.yyyy').parse(controller.text),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2025),
                );
                controller.text = DateFormat('dd.MM.yyyy').format(date!);
              }
              if (onTap != null) {
                onTap!();
              }
            },
            obscureText: isObscure,
            readOnly: onlyRead || isShowDatePicker,
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: Constants.textTheme.bodyText1,
            decoration: InputDecoration(
                filled: true,
                fillColor: Constants.whiteColor,
                hintText: hintText,
                hintStyle: onlyRead
                    ? Constants.textTheme.bodyText1
                    : Constants.textTheme.bodyText1!
                        .copyWith(color: Constants.textFieldGrayColor),
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      width: 3,
                      color: Constants.secondPrimaryColor,
                    )),
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Constants.whiteColor,
                    ))),
          ),
        ),
      ],
    );
  }
}
