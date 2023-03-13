import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pikapika_admin_panel/data/models/iiko_category.dart';
import 'package:pikapika_admin_panel/logic/blocs/gift/gift_bloc.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<IikoCategory> iikoCategories = [];
    var iconsList = [
      DropdownMenuItem(
        value: "gift",
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset("assets/icons/gift_flat.svg")),
            const SizedBox(width: 7),
            Text(
              "Подарок",
              style: Constants.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      DropdownMenuItem(
        value: "cola",
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset("assets/icons/cola_flat.svg")),
            const SizedBox(width: 7),
            Text(
              "Газировка",
              style: Constants.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      DropdownMenuItem(
        value: "pizza",
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset("assets/icons/pizza_flat.svg")),
            const SizedBox(width: 7),
            Text(
              "Пицца",
              style: Constants.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      DropdownMenuItem(
        value: "sushi",
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset("assets/icons/sushi_flat.svg")),
            const SizedBox(width: 7),
            Text(
              "Суши",
              style: Constants.textTheme.bodyLarge,
            ),
          ],
        ),
      )
    ];

    IikoCategory? initialIikoCategoryGift1;
    bool initialIsEnabledGift1 = false;
    bool initialIsSingleGift1 = false;
    TextEditingController gift1CategoryIDController = TextEditingController();
    TextEditingController gift1DescriptionController = TextEditingController();
    TextEditingController gift1GoalController = TextEditingController();
    TextEditingController gift1IconController = TextEditingController();

    IikoCategory? initialIikoCategoryGift2;
    bool initialIsEnabledGift2 = false;
    bool initialIsSingleGift2 = false;
    TextEditingController gift2CategoryIDController = TextEditingController();
    TextEditingController gift2DescriptionController = TextEditingController();
    TextEditingController gift2GoalController = TextEditingController();
    TextEditingController gift2IconController = TextEditingController();

    IikoCategory? initialIikoCategoryGift3;
    bool initialIsEnabledGift3 = false;
    bool initialIsSingleGift3 = false;
    TextEditingController gift3CategoryIDController = TextEditingController();
    TextEditingController gift3DescriptionController = TextEditingController();
    TextEditingController gift3GoalController = TextEditingController();
    TextEditingController gift3IconController = TextEditingController();

    return BlocConsumer<GiftBloc, GiftState>(
        listener: (context, settingsState) {
      if (settingsState is GiftErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(Constants.errorSnackBar(
            context, settingsState.message,
            duration: const Duration(milliseconds: 1000)));
      } else if (settingsState is GiftSuccessSaved) {
        ScaffoldMessenger.of(context).showSnackBar(Constants.successSnackBar(
            context, "Данные успешно сохранены",
            duration: const Duration(milliseconds: 1600)));
      }
    }, builder: (context, state) {
      if (state is GiftInitialState || state is GiftLoadingState) {
        return const Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3.5,
              color: Constants.primaryColor,
            ),
          ),
        );
      }
      if (state is GiftLoadedState && iikoCategories.isEmpty) {
        iikoCategories = state.iikoCategories;
        gift1CategoryIDController =
            TextEditingController(text: state.giftGoals.gift1.categoryID);
        gift1DescriptionController =
            TextEditingController(text: state.giftGoals.gift1.description);
        gift1GoalController =
            TextEditingController(text: state.giftGoals.gift1.goal.toString());
        gift1IconController =
            TextEditingController(text: state.giftGoals.gift1.icon);
        initialIsEnabledGift1 = state.giftGoals.gift1.isEnabled;
        initialIsSingleGift1 = state.giftGoals.gift1.isSingleGift;

        gift2CategoryIDController =
            TextEditingController(text: state.giftGoals.gift2.categoryID);
        gift2DescriptionController =
            TextEditingController(text: state.giftGoals.gift2.description);
        gift2GoalController =
            TextEditingController(text: state.giftGoals.gift2.goal.toString());
        gift2IconController =
            TextEditingController(text: state.giftGoals.gift2.icon);
        initialIsEnabledGift2 = state.giftGoals.gift2.isEnabled;
        initialIsSingleGift2 = state.giftGoals.gift2.isSingleGift;

        gift3CategoryIDController =
            TextEditingController(text: state.giftGoals.gift3.categoryID);
        gift3DescriptionController =
            TextEditingController(text: state.giftGoals.gift3.description);
        gift3GoalController =
            TextEditingController(text: state.giftGoals.gift3.goal.toString());
        gift3IconController =
            TextEditingController(text: state.giftGoals.gift3.icon);
        initialIsEnabledGift3 = state.giftGoals.gift3.isEnabled;
        initialIsSingleGift3 = state.giftGoals.gift3.isSingleGift;

        var tmp = state.iikoCategories
            .where((element) => element.id == state.giftGoals.gift1.categoryID);
        if (tmp.isNotEmpty) {
          initialIikoCategoryGift1 = tmp.first;
        }
        var tmp2 = state.iikoCategories
            .where((element) => element.id == state.giftGoals.gift2.categoryID);
        if (tmp2.isNotEmpty) {
          initialIikoCategoryGift2 = tmp2.first;
        }
        var tmp3 = state.iikoCategories
            .where((element) => element.id == state.giftGoals.gift3.categoryID);
        if (tmp3.isNotEmpty) {
          initialIikoCategoryGift3 = tmp3.first;
        }
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: Constants.defaultPadding * 0.5,
                    right: Constants.defaultPadding * 1.5,
                    bottom: Constants.defaultPadding * 0.5),
                child: CustomElevatedButton(
                    text: "Сохранить",
                    width: 120,
                    isLoading:
                        context.read<GiftBloc>().state is GiftSavingState,
                    height: 43,
                    fontSize: Constants.textTheme.bodyLarge!.fontSize,
                    function: () {
                      context.read<GiftBloc>().add(UpdateGiftData(
                            gift1CategoryID: gift1CategoryIDController.text,
                            gift1Description: gift1DescriptionController.text,
                            gift1Goal: gift1GoalController.text,
                            gift1Icon: gift1IconController.text,
                            gift2CategoryID: gift2CategoryIDController.text,
                            gift2Description: gift2DescriptionController.text,
                            gift2Goal: gift2GoalController.text,
                            gift2Icon: gift2IconController.text,
                            gift3CategoryID: gift3CategoryIDController.text,
                            gift3Description: gift3DescriptionController.text,
                            gift3Goal: gift3GoalController.text,
                            gift3Icon: gift3IconController.text,
                          ));
                    })),
            Container(
              margin: EdgeInsets.only(
                left: Constants.defaultPadding * 1.5,
                right: Constants.defaultPadding * 1.5,
                bottom: Constants.defaultPadding * 1.5,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding,
                  vertical: Constants.defaultPadding * 1.5),
              decoration: const BoxDecoration(
                  color: Constants.secondBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
                    child: Text(
                      "Подарок #1",
                      style: Constants.textTheme.headlineMedium,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                    child: Text(
                      "В данном блоке вы можете настроить подарок #1 в приложении",
                      style: Constants.textTheme.bodyLarge!
                          .copyWith(color: Constants.middleGrayColor),
                    ),
                  ),
                  Text(
                    "IIKO категория подарка",
                    style: Constants.textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Constants.defaultPadding * 0.5,
                      bottom: Constants.defaultPadding,
                    ),
                    child: DropdownButtonFormField(
                      value: initialIikoCategoryGift1,
                      decoration: InputDecoration(
                          hintText: "Выберите категорию IIKO",
                          hintStyle: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.textFieldGrayColor),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Constants.secondPrimaryColor,
                              )),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Constants.textFieldGrayColor,
                              ))),
                      items: iikoCategories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name,
                                  style: Constants.textTheme.bodyLarge,
                                ),
                              ))
                          .toList(),
                      onChanged: (category) {
                        if (category != null) {
                          gift1CategoryIDController =
                              TextEditingController(text: category.id);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: CustomTextInputField(
                        titleText: "Короткое описание подарка #1",
                        hintText: "Введите небольшое описание подарка",
                        keyboardType: TextInputType.number,
                        controller: gift1DescriptionController),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: CustomTextInputField(
                        titleText: "Начальная сумма активации подарка #1",
                        hintText:
                            "Введите сумму при которой активируется акция",
                        keyboardType: TextInputType.number,
                        controller: gift1GoalController),
                  ),
                  Text(
                    "Иконка подарка",
                    style: Constants.textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Constants.defaultPadding * 0.5,
                      bottom: Constants.defaultPadding,
                    ),
                    child: DropdownButtonFormField(
                      value: gift1IconController.text,
                      decoration: InputDecoration(
                          hintText: "Выберите иконку для подарка #1",
                          hintStyle: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.textFieldGrayColor),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Constants.secondPrimaryColor,
                              )),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Constants.textFieldGrayColor,
                              ))),
                      items: iconsList,
                      onChanged: (icon) {
                        if (icon != null) {
                          gift1IconController =
                              TextEditingController(text: icon);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GiftCheckbox(
                          initialValue: initialIsEnabledGift1,
                          giftBloc: context.read<GiftBloc>(),
                          checkboxType: "isEnabled",
                          giftType: "gift1",
                        ),
                        Flexible(
                          child: Text(
                            "Запустить акцию подарка #1",
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
                        GiftCheckbox(
                          initialValue: initialIsSingleGift1,
                          giftBloc: context.read<GiftBloc>(),
                          checkboxType: "isSingleGift",
                          giftType: "gift1",
                        ),
                        Flexible(
                          child: Text(
                            "Акция не предоставляет выбора (Фиксированный подарок)",
                            style: Constants.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: Constants.defaultPadding * 1.5,
                right: Constants.defaultPadding * 1.5,
                bottom: Constants.defaultPadding * 1.5,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding,
                  vertical: Constants.defaultPadding * 1.5),
              decoration: const BoxDecoration(
                  color: Constants.secondBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
                    child: Text(
                      "Подарок #2",
                      style: Constants.textTheme.headlineMedium,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                    child: Text(
                      "В данном блоке вы можете настроить подарок #2 в приложении",
                      style: Constants.textTheme.bodyLarge!
                          .copyWith(color: Constants.middleGrayColor),
                    ),
                  ),
                  Text(
                    "IIKO категория подарка",
                    style: Constants.textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Constants.defaultPadding * 0.5,
                      bottom: Constants.defaultPadding,
                    ),
                    child: DropdownButtonFormField(
                      value: initialIikoCategoryGift2,
                      decoration: InputDecoration(
                          hintText: "Выберите категорию IIKO",
                          hintStyle: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.textFieldGrayColor),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Constants.secondPrimaryColor,
                              )),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Constants.textFieldGrayColor,
                              ))),
                      items: iikoCategories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name,
                                  style: Constants.textTheme.bodyLarge,
                                ),
                              ))
                          .toList(),
                      onChanged: (category) {
                        if (category != null) {
                          gift2CategoryIDController =
                              TextEditingController(text: category.id);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: CustomTextInputField(
                        titleText: "Короткое описание подарка #2",
                        hintText: "Введите небольшое описание подарка",
                        keyboardType: TextInputType.number,
                        controller: gift2DescriptionController),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: CustomTextInputField(
                        titleText: "Начальная сумма активации подарка #2",
                        hintText:
                            "Введите сумму при которой активируется акция",
                        keyboardType: TextInputType.number,
                        controller: gift2GoalController),
                  ),
                  Text(
                    "Иконка подарка",
                    style: Constants.textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Constants.defaultPadding * 0.5,
                      bottom: Constants.defaultPadding,
                    ),
                    child: DropdownButtonFormField(
                      value: gift2IconController.text,
                      decoration: InputDecoration(
                          hintText: "Выберите иконку для подарка #2",
                          hintStyle: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.textFieldGrayColor),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Constants.secondPrimaryColor,
                              )),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Constants.textFieldGrayColor,
                              ))),
                      items: iconsList,
                      onChanged: (icon) {
                        if (icon != null) {
                          gift2IconController =
                              TextEditingController(text: icon);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GiftCheckbox(
                          initialValue: initialIsEnabledGift2,
                          giftBloc: context.read<GiftBloc>(),
                          checkboxType: "isEnabled",
                          giftType: "gift2",
                        ),
                        Flexible(
                          child: Text(
                            "Запустить акцию подарка #2",
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
                        GiftCheckbox(
                          initialValue: initialIsSingleGift2,
                          giftBloc: context.read<GiftBloc>(),
                          checkboxType: "isSingleGift",
                          giftType: "gift2",
                        ),
                        Flexible(
                          child: Text(
                            "Акция не предоставляет выбора (Фиксированный подарок)",
                            style: Constants.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: Constants.defaultPadding * 1.5,
                right: Constants.defaultPadding * 1.5,
                bottom: Constants.defaultPadding * 1.5,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding,
                  vertical: Constants.defaultPadding * 1.5),
              decoration: const BoxDecoration(
                  color: Constants.secondBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
                    child: Text(
                      "Подарок #3",
                      style: Constants.textTheme.headlineMedium,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                    child: Text(
                      "В данном блоке вы можете настроить подарок #3 в приложении",
                      style: Constants.textTheme.bodyLarge!
                          .copyWith(color: Constants.middleGrayColor),
                    ),
                  ),
                  Text(
                    "IIKO категория подарка",
                    style: Constants.textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Constants.defaultPadding * 0.5,
                      bottom: Constants.defaultPadding,
                    ),
                    child: DropdownButtonFormField(
                      value: initialIikoCategoryGift3,
                      decoration: InputDecoration(
                          hintText: "Выберите категорию IIKO",
                          hintStyle: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.textFieldGrayColor),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Constants.secondPrimaryColor,
                              )),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Constants.textFieldGrayColor,
                              ))),
                      items: iikoCategories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name,
                                  style: Constants.textTheme.bodyLarge,
                                ),
                              ))
                          .toList(),
                      onChanged: (category) {
                        if (category != null) {
                          gift3CategoryIDController =
                              TextEditingController(text: category.id);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: CustomTextInputField(
                        titleText: "Короткое описание подарка #3",
                        hintText: "Введите небольшое описание подарка",
                        keyboardType: TextInputType.number,
                        controller: gift3DescriptionController),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: CustomTextInputField(
                        titleText: "Начальная сумма активации подарка #3",
                        hintText:
                            "Введите сумму при которой активируется акция",
                        keyboardType: TextInputType.number,
                        controller: gift3GoalController),
                  ),
                  Text(
                    "Иконка подарка",
                    style: Constants.textTheme.headlineSmall,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: Constants.defaultPadding * 0.5,
                      bottom: Constants.defaultPadding,
                    ),
                    child: DropdownButtonFormField(
                      value: gift3IconController.text,
                      decoration: InputDecoration(
                          hintText: "Выберите иконку для подарка #3",
                          hintStyle: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.textFieldGrayColor),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 3,
                                color: Constants.secondPrimaryColor,
                              )),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Constants.textFieldGrayColor,
                              ))),
                      items: iconsList,
                      onChanged: (icon) {
                        if (icon != null) {
                          gift3IconController =
                              TextEditingController(text: icon);
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GiftCheckbox(
                          initialValue: initialIsEnabledGift3,
                          giftBloc: context.read<GiftBloc>(),
                          checkboxType: "isEnabled",
                          giftType: "gift3",
                        ),
                        Flexible(
                          child: Text(
                            "Запустить акцию подарка #3",
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
                        GiftCheckbox(
                          initialValue: initialIsSingleGift3,
                          giftBloc: context.read<GiftBloc>(),
                          checkboxType: "isSingleGift",
                          giftType: "gift3",
                        ),
                        Flexible(
                          child: Text(
                            "Акция не предоставляет выбора (Фиксированный подарок)",
                            style: Constants.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GiftCheckbox extends StatefulWidget {
  const GiftCheckbox({
    super.key,
    required this.initialValue,
    required this.giftBloc,
    required this.giftType,
    required this.checkboxType,
  });

  final bool initialValue;
  final GiftBloc giftBloc;
  final String giftType;
  final String checkboxType;

  @override
  State<GiftCheckbox> createState() => _GiftCheckboxState();
}

class _GiftCheckboxState extends State<GiftCheckbox> {
  late bool value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: value,
        activeColor: Constants.primaryColor,
        onChanged: (bool? val) {
          if (val != null) {
            if (widget.checkboxType == "isEnabled") {
              widget.giftBloc.add(GiftIsEnabledChanged(val, widget.giftType));
            } else if (widget.checkboxType == "isSingleGift") {
              widget.giftBloc
                  .add(GiftIsSingleGiftChanged(val, widget.giftType));
            }
            setState(() {
              value = val;
            });
          }
        });
  }
}
