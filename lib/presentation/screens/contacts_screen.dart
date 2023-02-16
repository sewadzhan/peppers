import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/contact/contact_bloc.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController instaController = TextEditingController();
    TextEditingController websiteController = TextEditingController();
    TextEditingController whatsappController = TextEditingController();
    TextEditingController workingHourOpenController = TextEditingController();
    TextEditingController workingHourCloseController = TextEditingController();

    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is ContactSuccessSaved) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.successSnackBar(
              context, "Данные успешно сохранены",
              duration: const Duration(milliseconds: 1600)));
        } else if (state is ContactsError) {
          var errorSnackBar = Constants.errorSnackBar(context, state.message,
              duration: const Duration(milliseconds: 1000));
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        }
      },
      builder: (context, state) {
        if (state is ContactInitial || state is ContactLoading) {
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
        if (state is ContactLoaded) {
          emailController =
              TextEditingController(text: state.contactsModel.email);
          phoneController =
              TextEditingController(text: state.contactsModel.phone);
          instaController =
              TextEditingController(text: state.contactsModel.instagramUrl);
          websiteController =
              TextEditingController(text: state.contactsModel.webSite);
          whatsappController =
              TextEditingController(text: state.contactsModel.whatsappUrl);
          workingHourOpenController =
              TextEditingController(text: state.contactsModel.openHour);
          workingHourCloseController =
              TextEditingController(text: state.contactsModel.closeHour);
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: Constants.defaultPadding * 0.5,
                      right: Constants.defaultPadding * 2,
                      bottom: Constants.defaultPadding * 0.5),
                  child: CustomElevatedButton(
                      text: "Сохранить",
                      width: 120,
                      isLoading: state is ContactSaving,
                      height: 43,
                      fontSize: Constants.textTheme.bodyLarge!.fontSize,
                      function: () {
                        context.read<ContactBloc>().add(UpdateContactData(
                            (state as ContactLoaded).contactsModel.copyWith(
                                email: emailController.text,
                                instagramUrl: instaController.text,
                                phone: phoneController.text,
                                whatsappUrl: whatsappController.text,
                                openHour: workingHourOpenController.text,
                                closeHour: workingHourCloseController.text,
                                webSite: websiteController.text)));
                      }),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: Constants.defaultPadding * 2,
                    right: Constants.defaultPadding * 2,
                    bottom: Constants.defaultPadding * 2,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding,
                      vertical: Constants.defaultPadding * 1.5),
                  decoration: const BoxDecoration(
                      color: Constants.secondBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.5),
                        child: Text(
                          "Контактная информация",
                          style: Constants.textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding * 1.5),
                        child: Text(
                          "Базовые контактные данные ресторана для страницы \"Контакты\"",
                          style: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.middleGrayColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: CustomTextInputField(
                            titleText: "Email",
                            hintText: "Введите электронную почту",
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: CustomTextInputField(
                            titleText: "Мобильный телефон",
                            hintText: "Введите мобильный телефон  ",
                            keyboardType: TextInputType.phone,
                            controller: phoneController),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: CustomTextInputField(
                            titleText: "URL сайта ресторана",
                            hintText: "Введите URL сайта",
                            keyboardType: TextInputType.url,
                            controller: websiteController),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: CustomTextInputField(
                            titleText: "Instagram URL",
                            hintText: "Введите URL Instagram",
                            keyboardType: TextInputType.url,
                            controller: instaController),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: CustomTextInputField(
                            titleText: "Whatsapp URL",
                            hintText: "Введите URL Whatsapp",
                            keyboardType: TextInputType.url,
                            controller: whatsappController),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: Constants.defaultPadding * 2,
                      right: Constants.defaultPadding * 2,
                      bottom: Constants.defaultPadding * 2),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding,
                      vertical: Constants.defaultPadding * 1.5),
                  decoration: const BoxDecoration(
                      color: Constants.secondBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.5),
                        child: Text(
                          "График работы ресторана",
                          style: Constants.textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding * 1.5),
                        child: Text(
                          "Введите время открытия и закрытия заведения",
                          style: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.middleGrayColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomTextInputField(
                                  titleText: "Время открытия",
                                  pickerType: Picker.time,
                                  hintText: "Введите время открытия ресторана",
                                  controller: workingHourOpenController),
                            ),
                            const SizedBox(
                              width: Constants.defaultPadding,
                            ),
                            Expanded(
                              child: CustomTextInputField(
                                  titleText: "Время закрытия",
                                  pickerType: Picker.time,
                                  hintText: "Введите время закрытия ресторана",
                                  controller: workingHourCloseController),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
