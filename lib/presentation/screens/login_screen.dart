import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peppers_admin_panel/logic/blocs/login/form_submission_status.dart';
import 'package:peppers_admin_panel/logic/blocs/login/login_bloc.dart';
import 'package:peppers_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:peppers_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';
import 'package:peppers_admin_panel/presentation/config/responsive.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    //Changing theme for small devices
    Constants.checkThemeForSmallDevices(width);

    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.formStatus is SubmissionFailedStatus) {
          var errorSnackBar = Constants.errorSnackBar(
              context, (state.formStatus as SubmissionFailedStatus).message,
              duration: const Duration(milliseconds: 1000));
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        } else if (state.formStatus is SubmissionSuccessStatus) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.successSnackBar(
              context, "Вы успешно авторизовались",
              duration: const Duration(milliseconds: 1600)));
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: SizedBox(
          width: width,
          height: height,
          child: Row(
            children: [
              !Responsive.isMobile(context)
                  ? Expanded(
                      child: Container(
                      color: Constants.primaryColor,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/logo/logo.svg",
                          color: Constants.whiteColor,
                          width: 300,
                        ),
                      ),
                    ))
                  : const SizedBox.shrink(),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Constants.defaultPadding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text("Добро пожаловать 👋 ",
                        style: Constants.textTheme.displayLarge),
                    SizedBox(height: Constants.defaultPadding),
                    Text(
                        "Введите электронную почту и пароль для входа в аккаунт",
                        style: Constants.textTheme.bodyLarge),
                    Padding(
                      padding: EdgeInsets.only(
                        top: Constants.defaultPadding * 2,
                      ),
                      child: CustomTextInputField(
                          onChanged: (String word) {
                            context
                                .read<LoginBloc>()
                                .add(LoginEmailChanged(word));
                          },
                          titleText: "Email",
                          hintText: "Введите электронную почту",
                          showBorder: false,
                          controller: emailController),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: Constants.defaultPadding,
                          bottom: Constants.defaultPadding),
                      child: CustomTextInputField(
                          isObscure: true,
                          onChanged: (String word) {
                            context
                                .read<LoginBloc>()
                                .add(LoginPasswordChanged(word));
                          },
                          titleText: "Пароль",
                          hintText: "Введите пароль",
                          showBorder: false,
                          controller: passwordController),
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return CustomElevatedButton(
                            autoFocus: true,
                            isLoading: state.formStatus is FormSubmittingStatus,
                            text: "Вход",
                            width: 150,
                            function: () {
                              context.read<LoginBloc>().add(LoginSubmitted());
                            });
                      },
                    ),
                    const Spacer()
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
