import 'package:flutter/material.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';
import 'package:intl/intl.dart';

enum Picker { none, date, time }

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField(
      {Key? key,
      required this.titleText,
      required this.hintText,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.pickerType = Picker.none,
      this.onlyRead = false,
      this.maxLines = 1,
      this.onTap,
      this.onChanged,
      this.isObscure = false,
      this.showBorder = true,
      this.width})
      : super(key: key);

  final String titleText;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Picker pickerType;
  final bool onlyRead;
  final int maxLines;
  final Function? onTap;
  final Function(String)? onChanged;
  final bool isObscure;
  final bool showBorder;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: Constants.textTheme.headlineSmall,
        ),
        Container(
          width: width,
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            onChanged: onChanged,
            onTap: () async {
              if (pickerType == Picker.date) {
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
              } else if (pickerType == Picker.time) {
                TimeOfDay startTime = controller.text.isNotEmpty
                    ? TimeOfDay(
                        hour: int.parse(controller.text.split(":")[0]),
                        minute: int.parse(controller.text.split(":")[1]))
                    : TimeOfDay.now();
                final TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: startTime,
                    initialEntryMode: TimePickerEntryMode.dial,
                    builder: (context, childWidget) {
                      return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: childWidget!);
                    });

                if (timeOfDay != null) {
                  controller.text = timeOfDay.to24hours();
                }
              }
              if (onTap != null) {
                onTap!();
              }
            },
            obscureText: isObscure,
            readOnly: onlyRead || pickerType != Picker.none,
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: Constants.textTheme.bodyLarge,
            decoration: InputDecoration(
                filled: true,
                fillColor: Constants.whiteColor,
                hintText: hintText,
                hintStyle: onlyRead
                    ? Constants.textTheme.bodyLarge
                    : Constants.textTheme.bodyLarge!
                        .copyWith(color: Constants.textFieldGrayColor),
                focusedBorder: !onlyRead
                    ? const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          width: 3,
                          color: Constants.secondPrimaryColor,
                        ))
                    : OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          width: 1,
                          color: showBorder
                              ? Constants.textFieldGrayColor
                              : Constants.whiteColor,
                        )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                      width: 1,
                      color: showBorder
                          ? Constants.textFieldGrayColor
                          : Constants.whiteColor,
                    ))),
          ),
        ),
      ],
    );
  }
}
