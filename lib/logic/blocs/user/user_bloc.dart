import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peppers_admin_panel/data/models/pikapika_user.dart';
import 'package:peppers_admin_panel/data/repositories/firestore_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreRepository firestoreRepository;

  UserBloc(this.firestoreRepository) : super(UserInitialState()) {
    on<LoadUsers>(loadUsersToState);
    on<UserIndividualPercentChanged>(userIndividualPercentChangedToState);
  }

  //Load the actual list of Users from Firestore
  Future<void> loadUsersToState(
      LoadUsers event, Emitter<UserState> emit) async {
    try {
      emit(UserLoadingState());

      final List<PikapikaUser> users = await firestoreRepository.getAllUsers();

      emit(UserLoadedState(users));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  //Change the individual percent of certain user
  Future<void> userIndividualPercentChangedToState(
      UserIndividualPercentChanged event, Emitter<UserState> emit) async {
    try {
      var previousState = state;
      if (previousState is UserLoadedState) {
        int userIndex = previousState.users
            .indexWhere((user) => user.phoneNumber == event.phoneNumber);

        List<PikapikaUser> users = List.from(previousState.users);

        users[userIndex] = previousState.users[userIndex]
            .copyWith(individualCashbackPercent: event.percent);
        emit(UserLoadedState(users));
      }
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }
}
