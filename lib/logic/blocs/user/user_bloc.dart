import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/pikapika_user.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirestoreRepository firestoreRepository;

  UserBloc(this.firestoreRepository) : super(UserInitialState()) {
    on<LoadUsers>(loadUsersToState);
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
}
