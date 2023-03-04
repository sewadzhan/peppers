import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/cashback/cashback_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/contact/contact_bloc.dart';
import 'package:pikapika_admin_panel/logic/cubits/settings/settings_cubit.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController percentController = TextEditingController();
    TextEditingController minOrderController = TextEditingController();
    TextEditingController appStoreURLController = TextEditingController();
    TextEditingController googlePlayURLController = TextEditingController();

    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, settingsState) {
        if (settingsState is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.errorSnackBar(
              context, settingsState.message,
              duration: const Duration(milliseconds: 1000)));
        } else if (settingsState is SettingsSuccessSaved) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.successSnackBar(
              context, "Данные успешно сохранены",
              duration: const Duration(milliseconds: 1600)));
        }
      },
      child: BlocBuilder<CashbackBloc, CashbackState>(
        builder: (context, cashbackState) {
          return BlocBuilder<ContactBloc, ContactState>(
            builder: (context, contactState) {
              if (!(contactState is ContactLoaded &&
                  cashbackState is CashbackLoaded)) {
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
              minOrderController = TextEditingController(
                  text: contactState.contactsModel.minOrderSum.toString());
              appStoreURLController = TextEditingController(
                  text: contactState.contactsModel.appStoreUrl);
              googlePlayURLController = TextEditingController(
                  text: contactState.contactsModel.playMarketUrl);
              percentController = TextEditingController(
                  text: cashbackState.cashbackData.percent.toString());

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: Constants.defaultPadding * 0.5,
                            right: Constants.defaultPadding * 1.5,
                            bottom: Constants.defaultPadding * 0.5),
                        child: BlocBuilder<SettingsCubit, SettingsState>(
                          builder: (context, state) {
                            return CustomElevatedButton(
                                text: "Сохранить",
                                width: 120,
                                isLoading: context.read<SettingsCubit>().state
                                    is SettingsSaving,
                                height: 43,
                                fontSize:
                                    Constants.textTheme.bodyLarge!.fontSize,
                                function: () {
                                  context.read<SettingsCubit>().updateSettings(
                                        percentCashback: percentController.text,
                                        appStoreUrl: appStoreURLController.text,
                                        playMarketUrl:
                                            googlePlayURLController.text,
                                        minOrderSum: minOrderController.text,
                                      );
                                });
                          },
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: Constants.defaultPadding * 0.5),
                              child: Text(
                                "Настройки cashback",
                                style: Constants.textTheme.headlineMedium,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: Constants.defaultPadding * 1.5),
                              child: Text(
                                "В данном блоке вы можете настроить cashback систему приложения",
                                style: Constants.textTheme.bodyLarge!
                                    .copyWith(color: Constants.middleGrayColor),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: Constants.defaultPadding,
                              ),
                              child: CustomTextInputField(
                                  titleText: "Процент cashback'a",
                                  hintText:
                                      "Введите процент накопительных баллов",
                                  keyboardType: TextInputType.number,
                                  controller: percentController),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: Constants.defaultPadding,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                      value:
                                          cashbackState.cashbackData.isEnabled,
                                      activeColor: Constants.primaryColor,
                                      onChanged: (bool? val) {
                                        if (val != null) {
                                          context.read<CashbackBloc>().add(
                                              CashbackIsEnabledChanged(val));
                                        }
                                      }),
                                  Flexible(
                                    child: Text(
                                      "Включить систему накопительных баллов ",
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: Constants.defaultPadding * 1.5),
                                child: Text(
                                  "Дополнительные настройки",
                                  style: Constants.textTheme.headlineMedium,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: Constants.defaultPadding,
                                ),
                                child: CustomTextInputField(
                                    titleText: "Минимальная сумма заказа",
                                    hintText:
                                        "Введите min сумму для оформления заказа",
                                    keyboardType: TextInputType.number,
                                    controller: minOrderController),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: Constants.defaultPadding,
                                ),
                                child: CustomTextInputField(
                                    titleText: "App Store URL",
                                    hintText:
                                        "Введите URL приложения в App Store",
                                    keyboardType: TextInputType.number,
                                    controller: appStoreURLController),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: Constants.defaultPadding,
                                ),
                                child: CustomTextInputField(
                                    titleText: "Google Play URL",
                                    hintText:
                                        "Введите URL приложения в Google Play",
                                    keyboardType: TextInputType.number,
                                    controller: googlePlayURLController),
                              ),
                            ]),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: Constants.defaultPadding * 0.5),
                              child: Text(
                                "Настройки методов оплаты",
                                style: Constants.textTheme.headlineMedium,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: Constants.defaultPadding * 1.5),
                              child: Text(
                                "В данном блоке вы можете настроить доступность всех методов оплат в приложении",
                                style: Constants.textTheme.bodyLarge!
                                    .copyWith(color: Constants.middleGrayColor),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: Constants.defaultPadding,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: contactState.contactsModel
                                          .paymentMethods['bankCard'],
                                      activeColor: Constants.primaryColor,
                                      onChanged: (bool? val) {
                                        if (val != null) {
                                          context.read<ContactBloc>().add(
                                              ContactPaymentMethodChanged(
                                                  'bankCard', val));
                                        }
                                      }),
                                  Flexible(
                                    child: Text(
                                      "Банковская карта",
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
                                      value: contactState
                                          .contactsModel.paymentMethods['cash'],
                                      activeColor: Constants.primaryColor,
                                      onChanged: (bool? val) {
                                        if (val != null) {
                                          context.read<ContactBloc>().add(
                                              ContactPaymentMethodChanged(
                                                  'cash', val));
                                        }
                                      }),
                                  Flexible(
                                    child: Text(
                                      "Наличный расчет",
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
                                      value: contactState.contactsModel
                                          .paymentMethods['nonCash'],
                                      activeColor: Constants.primaryColor,
                                      onChanged: (bool? val) {
                                        if (val != null) {
                                          context.read<ContactBloc>().add(
                                              ContactPaymentMethodChanged(
                                                  'nonCash', val));
                                        }
                                      }),
                                  Flexible(
                                    child: Text(
                                      "Безналичный расчет (Каспи)",
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
                                      value: contactState.contactsModel
                                          .paymentMethods['savedCard'],
                                      activeColor: Constants.primaryColor,
                                      onChanged: (bool? val) {
                                        if (val != null) {
                                          context.read<ContactBloc>().add(
                                              ContactPaymentMethodChanged(
                                                  'savedCard', val));
                                        }
                                      }),
                                  Flexible(
                                    child: Text(
                                      "Сохраненной картой",
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
