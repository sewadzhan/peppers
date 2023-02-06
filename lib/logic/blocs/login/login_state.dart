part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final FormSubmissionStatus formStatus;

  const LoginState(
      {this.email = "",
      this.password = "",
      this.formStatus = const InitialFormStatus()});

  LoginState copyWith(
      {String? email, String? password, FormSubmissionStatus? formStatus}) {
    return LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }

  @override
  List<Object> get props => [email, password, formStatus];
}
