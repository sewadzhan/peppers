import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peppers_admin_panel/data/repositories/auth_repository.dart';

import 'form_submission_status.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(const LoginState()) {
    on<LoginSubmitted>((event, emit) async {
      try {
        emit(state.copyWith(formStatus: const FormSubmittingStatus()));

        User? user =
            await authRepository.loginWithEmail(state.email, state.password);

        if (state.email.trim().isEmpty || state.password.trim().isEmpty) {
          emit(state.copyWith(
              formStatus: const SubmissionFailedStatus(
                  "Введите все необходимые данные")));
        } else if (user == null) {
          emit(state.copyWith(
              formStatus: const SubmissionFailedStatus(
                  "Некорректный email или пароль")));
        } else {
          emit(state.copyWith(
              formStatus: const SubmissionSuccessStatus(),
              email: "",
              password: ""));
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "invalid-email":
            emit(state.copyWith(
                formStatus:
                    const SubmissionFailedStatus("Введите корректный email")));
            break;
          case "invalid-password":
            emit(state.copyWith(
                formStatus:
                    const SubmissionFailedStatus("Пользователь не найден")));
            break;
          default:
            emit(state.copyWith(
                formStatus:
                    const SubmissionFailedStatus("Пользователь не найден")));
        }
      } catch (e) {
        emit(state.copyWith(
            formStatus: const SubmissionFailedStatus("Произошла ошибка")));
      }
      emit(state.copyWith(formStatus: const InitialFormStatus()));
    });
    on<LoginEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
      return;
    });
    on<LoginPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
      return;
    });
  }
}
