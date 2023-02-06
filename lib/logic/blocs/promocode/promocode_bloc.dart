import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/promocode.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';

part 'promocode_event.dart';
part 'promocode_state.dart';

class PromocodeBloc extends Bloc<PromocodeEvent, PromocodeState> {
  final FirestoreRepository firestoreRepository;

  PromocodeBloc(this.firestoreRepository) : super(PromocodeInitial()) {
    on<LoadPromocodeData>(loadPromocodeDataToState);
    on<UpdatePromocodeData>(updatePromocodeDataToState);
    on<AddPromocode>(addPromocodeToState);
  }

  //Load the actual list of promocodes from Firestore
  Future<void> loadPromocodeDataToState(
      LoadPromocodeData event, Emitter<PromocodeState> emit) async {
    try {
      emit(PromocodeLoading());

      final List<Promocode> promocodes =
          await firestoreRepository.getPromocodes();

      emit(PromocodeLoadSuccess(promocodes));
    } catch (e) {
      emit(PromocodeFailure(e.toString()));
    }
  }

  //Update a certain promocode in Cloud Firestore
  Future<void> updatePromocodeDataToState(
      UpdatePromocodeData event, Emitter<PromocodeState> emit) async {
    try {
      if (state is PromocodeLoadSuccess) {
        await firestoreRepository.updatePromocodeData(event.promocode);

        //Replacing the updated element of list
        var finalList = (state as PromocodeLoadSuccess).promocodes;
        finalList[finalList.indexWhere(
            (element) => element.id == event.promocode.id)] = event.promocode;

        emit(PromocodeLoadSuccess(finalList));
      }
    } catch (e) {
      emit(PromocodeFailure(e.toString()));
    }
  }

  //Add new promocode to Firestore
  Future<void> addPromocodeToState(
      AddPromocode event, Emitter<PromocodeState> emit) async {
    try {
      if (state is PromocodeLoadSuccess) {
        await firestoreRepository.addPromocode(event.promocode);

        List<Promocode> finalList =
            List.from((state as PromocodeLoadSuccess).promocodes)
              ..add(event.promocode);

        emit(PromocodeLoadSuccess(finalList));
      }
    } catch (e) {
      emit(PromocodeFailure(e.toString()));
    }
  }
}
