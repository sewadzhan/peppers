import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:peppers_admin_panel/data/models/cashback_data.dart';
import 'package:peppers_admin_panel/data/repositories/firestore_repository.dart';

part 'cashback_event.dart';
part 'cashback_state.dart';

//Bloc for cashback
class CashbackBloc extends Bloc<CashbackEvent, CashbackState> {
  final FirestoreRepository firestoreRepository;

  CashbackBloc(this.firestoreRepository) : super(CashbackInitial()) {
    on<LoadCashbackData>(loadCashbackDataToState);
    on<CashbackStateChanged>(cashbackStateChangedToState);
    on<CashbackIsEnabledChanged>(cashbackIsEnabledChangedToState);
  }

  //Load cashback info data (percent value, is enabled or not)
  Future<void> loadCashbackDataToState(
      LoadCashbackData event, Emitter<CashbackState> emit) async {
    if (state is CashbackInitial) {
      try {
        emit(CashbackLoading());

        CashbackData cashbackData = await firestoreRepository.getCashbackData();

        emit(CashbackLoaded(cashbackData));
      } catch (e) {
        print("loadCashbackDataToState EXCEPTION: $e");
      }
    }
  }

  //Change the state without validation
  cashbackStateChangedToState(
      CashbackStateChanged event, Emitter<CashbackState> emit) {
    emit(CashbackLoaded(event.cashbackData));
  }

  //Change the isEnabled field
  cashbackIsEnabledChangedToState(
      CashbackIsEnabledChanged event, Emitter<CashbackState> emit) {
    var cashbackState = state;
    if (cashbackState is CashbackLoaded) {
      emit(CashbackLoaded(
          cashbackState.cashbackData.copyWith(isEnabled: event.value)));
    }
  }
}
