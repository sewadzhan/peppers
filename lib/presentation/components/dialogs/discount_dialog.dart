import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pikapika_admin_panel/data/models/iiko_discount.dart';
import 'package:pikapika_admin_panel/data/models/promocode.dart';
import 'package:pikapika_admin_panel/logic/blocs/promocode/promocode_bloc.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class DiscountDialog extends StatefulWidget {
  const DiscountDialog(
      {super.key, required this.promocode, required this.iikoDiscounts});

  final Promocode? promocode;
  final List<IikoDiscount> iikoDiscounts;

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  late TextEditingController codeController;
  late PromocodeType? typeController;
  late TextEditingController valueController;
  late bool isActiveController;
  late bool limitController;
  late TextEditingController startTimeLimitController;
  late TextEditingController finishTimeLimitController;
  late String iikoDiscountID;
  late IikoDiscount? initialIikoDiscount;

  @override
  void initState() {
    initialIikoDiscount = null;
    codeController = widget.promocode == null
        ? TextEditingController()
        : TextEditingController(text: widget.promocode!.code);
    typeController = widget.promocode == null ? null : widget.promocode!.type;
    valueController = widget.promocode == null
        ? TextEditingController()
        : TextEditingController(text: widget.promocode!.value.toString());
    isActiveController =
        widget.promocode == null ? true : widget.promocode!.isActive;
    limitController =
        widget.promocode == null ? false : widget.promocode!.canBeUsedOnlyOnce;
    startTimeLimitController = widget.promocode == null
        ? TextEditingController()
        : TextEditingController(text: widget.promocode!.startTimeLimit);
    finishTimeLimitController = widget.promocode == null
        ? TextEditingController()
        : TextEditingController(text: widget.promocode!.finishTimeLimit);
    iikoDiscountID =
        widget.promocode == null ? "" : widget.promocode!.discountID;

    if (widget.promocode != null) {
      var tmp = widget.iikoDiscounts
          .where((element) => element.id == widget.promocode!.discountID);
      if (tmp.isNotEmpty) {
        initialIikoDiscount = tmp.first;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Builder(builder: (dialogContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Dialog(
            insetPadding: EdgeInsets.all(Constants.defaultPadding * 0.5),
            backgroundColor: Colors.transparent,
            child: SingleChildScrollView(
              child: Container(
                width: 600,
                padding: EdgeInsets.symmetric(
                    horizontal: Constants.defaultPadding,
                    vertical: Constants.defaultPadding * 1.75),
                decoration: const BoxDecoration(
                    color: Constants.secondBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.5),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.promocode == null
                                    ? "Добавление нового промокода"
                                    : "Редактирование промокода",
                                style: Constants.textTheme.displaySmall,
                              ),
                              widget.promocode != null
                                  ? BlocBuilder<PromocodeBloc, PromocodeState>(
                                      builder: (context, state) {
                                        if (state is PromocodeDeletingState) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    Constants.defaultPadding *
                                                        0.5),
                                            width: 15,
                                            height: 15,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color:
                                                  Constants.secondPrimaryColor,
                                            ),
                                          );
                                        }
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            shape: const CircleBorder(),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/trash.svg',
                                            color: Constants.secondPrimaryColor,
                                            width: 15,
                                          ),
                                          onPressed: () {
                                            context.read<PromocodeBloc>().add(
                                                DeletePromocode(
                                                    id: widget.promocode!.id));
                                          },
                                        );
                                      },
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 1.5),
                        child: Text(
                          widget.promocode == null
                              ? "Введите все необходимые данные для добавления купона"
                              : "Для редактирования внесите изменения и нажмите кнопку \"Сохранить\"",
                          style: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.middleGrayColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: CustomTextInputField(
                            titleText: "Код купона",
                            hintText: "Введите промокод",
                            keyboardType: TextInputType.text,
                            controller: codeController),
                      ),
                      Text(
                        "Тип промокода",
                        style: Constants.textTheme.headlineSmall,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Constants.defaultPadding * 0.5,
                          bottom: Constants.defaultPadding,
                        ),
                        child: DropdownButton(
                          value: initialIikoDiscount,
                          focusColor: Constants.secondPrimaryColor,
                          hint: Text("Выберите тип промокода",
                              style: Constants.textTheme.bodyLarge!.copyWith(
                                  color: Constants.textFieldGrayColor)),
                          items: widget.iikoDiscounts
                              .map((discount) => DropdownMenuItem(
                                    value: discount,
                                    child: Text(
                                      discount.toString(),
                                      style: Constants.textTheme.bodyLarge,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (discount) {
                            if (discount != null) {
                              setState(() {
                                typeController = discount.type;
                                iikoDiscountID = discount.id;
                                initialIikoDiscount = discount;
                              });
                              if (discount.type != PromocodeType.flexible) {
                                valueController.text =
                                    discount.value.toString();
                              } else {
                                valueController.text = "";
                              }
                            }
                          },
                        ),
                      ),
                      typeController == PromocodeType.flexible
                          ? Padding(
                              padding: EdgeInsets.only(
                                bottom: Constants.defaultPadding,
                              ),
                              child: CustomTextInputField(
                                  titleText: "Величина купона",
                                  hintText: "Введите величину скидки",
                                  keyboardType: TextInputType.text,
                                  controller: valueController),
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                value: limitController,
                                activeColor: Constants.primaryColor,
                                onChanged: (bool? val) {
                                  setState(() {
                                    if (val != null) {
                                      limitController = val;
                                    }
                                  });
                                }),
                            Flexible(
                              child: Text(
                                "Единоразовая возможность использования промокода",
                                style: Constants.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                value: isActiveController,
                                activeColor: Constants.primaryColor,
                                onChanged: (bool? val) {
                                  setState(() {
                                    if (val != null) {
                                      isActiveController = val;
                                    }
                                  });
                                }),
                            Flexible(
                              child: Text(
                                "Активировать купон",
                                style: Constants.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 1.5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomTextInputField(
                                  titleText: "Время старта",
                                  pickerType: Picker.time,
                                  hintText: "Время старта активации",
                                  controller: startTimeLimitController),
                            ),
                            SizedBox(
                              width: Constants.defaultPadding,
                            ),
                            Expanded(
                              child: CustomTextInputField(
                                  titleText: "Время закрытия",
                                  pickerType: Picker.time,
                                  hintText: "Время деактивации",
                                  controller: finishTimeLimitController),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                child: const Icon(
                                  Icons.backspace,
                                  size: 20,
                                  color: Constants.secondPrimaryColor,
                                ),
                                onPressed: () {
                                  startTimeLimitController.clear();
                                  finishTimeLimitController.clear();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocConsumer<PromocodeBloc, PromocodeState>(
                            listener: (context, state) {
                              if (state is PromocodeErrorState) {
                                var errorSnackBar = Constants.errorSnackBar(
                                    dialogContext, state.message,
                                    duration:
                                        const Duration(milliseconds: 1000));
                                ScaffoldMessenger.of(dialogContext)
                                    .showSnackBar(errorSnackBar);
                              }
                            },
                            builder: (context3, state) {
                              return CustomElevatedButton(
                                  text: "Сохранить",
                                  width: 130,
                                  isLoading: state is PromocodeSavingState,
                                  height: 43,
                                  fontSize:
                                      Constants.textTheme.bodyLarge!.fontSize,
                                  function: () {
                                    //Add the new Promocode
                                    if (widget.promocode == null) {
                                      context.read<PromocodeBloc>().add(
                                          AddPromocode(
                                              code: codeController.text,
                                              type: typeController,
                                              isActive: isActiveController,
                                              discountID: iikoDiscountID,
                                              value: valueController.text,
                                              canBeUsedOnlyOnce:
                                                  limitController,
                                              startTimeLimit:
                                                  startTimeLimitController.text,
                                              finishTimeLimit:
                                                  finishTimeLimitController
                                                      .text));
                                    }
                                    //Edit the existed Promocode
                                    else {
                                      context.read<PromocodeBloc>().add(
                                          UpdatePromocodeData(
                                              id: widget.promocode!.id,
                                              code: codeController.text,
                                              type: typeController,
                                              isActive: isActiveController,
                                              discountID: iikoDiscountID,
                                              value: valueController.text,
                                              canBeUsedOnlyOnce:
                                                  limitController,
                                              startTimeLimit:
                                                  startTimeLimitController.text,
                                              finishTimeLimit:
                                                  finishTimeLimitController
                                                      .text));
                                    }
                                  });
                            },
                          ),
                          SizedBox(
                            width: Constants.defaultPadding * 0.5,
                          ),
                          CustomElevatedButton(
                              text: "Отмена",
                              width: 110,
                              height: 43,
                              alternativeStyle: true,
                              fontSize: Constants.textTheme.bodyLarge!.fontSize,
                              function: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      )
                    ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
