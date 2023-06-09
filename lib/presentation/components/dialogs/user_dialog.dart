import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peppers_admin_panel/data/models/pikapika_user.dart';
import 'package:peppers_admin_panel/logic/cubits/individual_percent/individual_percent_cubit.dart';
import 'package:peppers_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:peppers_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class UserDialog extends StatelessWidget {
  final PikapikaUser user;

  const UserDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var percentController = TextEditingController(
        text: user.individualCashbackPercent == null
            ? ""
            : user.individualCashbackPercent.toString());
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
                          bottom: Constants.defaultPadding * 1.5),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Детали аккаунта ${user.phoneNumber}",
                              style: Constants.textTheme.displaySmall,
                            ),
                            Tooltip(
                              message: "История заказов",
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: const CircleBorder(),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/orders.svg',
                                  color: Constants.primaryColor,
                                  width: 15,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/orderHistory',
                                      arguments: user.phoneNumber);
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding,
                      ),
                      child: CustomTextInputField(
                          titleText: "Имя",
                          hintText: "",
                          onlyRead: true,
                          keyboardType: TextInputType.text,
                          controller: TextEditingController(text: user.name)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding,
                      ),
                      child: CustomTextInputField(
                          titleText: "Email",
                          hintText: "",
                          onlyRead: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: TextEditingController(text: user.email)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding,
                      ),
                      child: CustomTextInputField(
                          titleText: "Дата рождения",
                          hintText: "",
                          onlyRead: true,
                          keyboardType: TextInputType.text,
                          controller:
                              TextEditingController(text: user.birthday)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomTextInputField(
                              width: 150,
                              titleText: "Накопительные баллы",
                              hintText: "",
                              onlyRead: true,
                              keyboardType: TextInputType.text,
                              controller: TextEditingController(
                                  text: user.cashback.toString())),
                          const SizedBox(width: 5),
                          Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: SvgPicture.asset(
                              "assets/icons/pikapika.svg",
                              width: 25,
                              color: Constants.primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding,
                      ),
                      child: CustomTextInputField(
                          width: 150,
                          titleText: "Индивидуальный процент cashback'a",
                          hintText: "",
                          //onlyRead: true,
                          keyboardType: TextInputType.text,
                          controller: percentController),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocConsumer<IndividualPercentCubit,
                            IndividualPercentState>(
                          listener: (context, state) {
                            if (state is IndividualPercentError) {
                              var errorSnackBar = Constants.errorSnackBar(
                                  context, state.message,
                                  duration: const Duration(milliseconds: 1000));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(errorSnackBar);
                            }
                          },
                          builder: (context3, state) {
                            return CustomElevatedButton(
                                text: "Сохранить",
                                width: 130,
                                isLoading: state is IndividualPercentSaving,
                                height: 43,
                                fontSize:
                                    Constants.textTheme.bodyLarge!.fontSize,
                                function: () {
                                  context
                                      .read<IndividualPercentCubit>()
                                      .updateIndividualPercent(
                                          phoneNumber: user.phoneNumber,
                                          percent: percentController.text);
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
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
