import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';
import 'package:pikapika_admin_panel/logic/blocs/user/user_bloc.dart';

part 'individual_percent_state.dart';

class IndividualPercentCubit extends Cubit<IndividualPercentState> {
  final FirestoreRepository firestoreRepository;
  final UserBloc usersBloc;
  IndividualPercentCubit(this.firestoreRepository, this.usersBloc)
      : super(IndividualPercentInitial());

  //Update IndividualPercent in Cloud Firestore
  Future<void> updateIndividualPercent({
    required String phoneNumber,
    required String percent,
  }) async {
    try {
      emit(IndividualPercentSaving());

      //Validation
      if (percent != "") {
        if (phoneNumber.isEmpty || int.tryParse(percent) == null) {
          emit(const IndividualPercentError(
              "Введите корректные данные для сохранения"));
          return;
        }
      }

      if (percent.isEmpty) {
        await firestoreRepository.editUser(
            phoneNumber, {'individualCashbackPercent': FieldValue.delete()});
      } else {
        await firestoreRepository.editUser(
            phoneNumber, {'individualCashbackPercent': int.parse(percent)});
      }

      //Update the userBloc state with new data
      usersBloc.add(
          UserIndividualPercentChanged(phoneNumber, int.tryParse(percent)));

      emit(IndividualPercentSuccessSaved());
    } catch (e) {
      emit(IndividualPercentError(e.toString()));
    }
  }
}
