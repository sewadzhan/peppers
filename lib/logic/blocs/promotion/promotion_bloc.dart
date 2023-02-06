import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/promotion.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';

part 'promotion_event.dart';
part 'promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final FirestoreRepository firestoreRepository;

  PromotionBloc(this.firestoreRepository) : super(PromotionInitialState()) {
    on<LoadPromotionData>(loadPromotionDataToState);
    on<UpdatePromotionData>(updatePromotionDataToState);
    on<AddPromotion>(addPromotionToState);
  }

  //Load the actual list of promotions from Firestore
  Future<void> loadPromotionDataToState(
      LoadPromotionData event, Emitter<PromotionState> emit) async {
    try {
      emit(PromotionLoadingState());

      final List<Promotion> promotions =
          await firestoreRepository.getPromotions();
      emit(PromotionLoadedState(promotions: promotions));
    } catch (e) {
      emit(PromotionErrorState());
    }
  }

  //Update a certain promotion in Cloud Firestore
  Future<void> updatePromotionDataToState(
      UpdatePromotionData event, Emitter<PromotionState> emit) async {
    try {
      if (state is PromotionLoadedState) {
        await firestoreRepository.updatePromotionData(event.promotion);

        //Replacing the updated element of list
        var finalList = (state as PromotionLoadedState).promotions;
        finalList[finalList.indexWhere(
            (element) => element.id == event.promotion.id)] = event.promotion;

        emit(PromotionLoadedState(promotions: finalList));
      }
    } catch (e) {
      emit(PromotionErrorState());
    }
  }

  //Add new promotion to Firestore
  Future<void> addPromotionToState(
      AddPromotion event, Emitter<PromotionState> emit) async {
    try {
      if (state is PromotionLoadedState) {
        await firestoreRepository.addPromotion(event.promotion);

        List<Promotion> finalList =
            List.from((state as PromotionLoadedState).promotions)
              ..add(event.promotion);

        emit(PromotionLoadedState(promotions: finalList));
      }
    } catch (e) {
      emit(PromotionErrorState());
    }
  }
}
