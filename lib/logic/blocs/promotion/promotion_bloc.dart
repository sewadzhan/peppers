import 'dart:developer';

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
    on<UpdatePromotion>(updatePromotionDataToState);
    on<AddPromotion>(addPromotionToState);
    on<DeletePromotion>(deletePromotionDataToState);
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
      emit(PromotionErrorState(e.toString()));
    }
  }

  //Update a certain promotion in Cloud Firestore
  Future<void> updatePromotionDataToState(
      UpdatePromotion event, Emitter<PromotionState> emit) async {
    try {
      if (state is PromotionLoadedState) {
        PromotionLoadedState previousState = state as PromotionLoadedState;
        emit(PromotionSavingState());

        //Fields validation
        if (event.title.trim().isEmpty ||
            event.imageUrl.isEmpty ||
            int.tryParse(event.order) == null) {
          emit(const PromotionErrorState(
              "Введите все необходимые поля корректно"));
          emit(previousState);
          return;
        }

        var updatedPromotion = Promotion(
            promocode: event.promocode,
            id: event.id,
            imageUrl: event.imageUrl,
            title: event.title,
            description: event.description,
            order: int.parse(event.order));

        await firestoreRepository.updatePromotionData(updatedPromotion);

        //Replacing the updated element of list
        var finalList = previousState.promotions;
        finalList[finalList.indexWhere(
            (element) => element.id == updatedPromotion.id)] = updatedPromotion;

        emit(PromotionSuccessSaved());
        emit(PromotionLoadedState(promotions: finalList));
      }
    } catch (e) {
      emit(PromotionErrorState(e.toString()));
    }
  }

  //Add new promotion to Firestore
  Future<void> addPromotionToState(
      AddPromotion event, Emitter<PromotionState> emit) async {
    try {
      if (state is PromotionLoadedState) {
        PromotionLoadedState previousState = state as PromotionLoadedState;
        emit(PromotionSavingState());

        //Fields validation
        if (event.title.trim().isEmpty ||
            event.imageUrl.isEmpty ||
            int.tryParse(event.order) == null) {
          emit(const PromotionErrorState(
              "Введите все необходимые поля корректно"));
          emit(previousState);
          return;
        }

        var addedPromotion = Promotion(
            id: "",
            imageUrl: event.imageUrl,
            title: event.title,
            description: event.description,
            promocode: event.promocode,
            order: int.parse(event.order));

        var promotionID =
            await firestoreRepository.addPromotion(addedPromotion);

        log(promotionID);

        List<Promotion> finalList = List.from(previousState.promotions)
          ..add(addedPromotion.copyWith(id: promotionID));

        emit(PromotionSuccessSaved());
        emit(PromotionLoadedState(promotions: finalList));
      }
    } catch (e) {
      emit(PromotionErrorState(e.toString()));
    }
  }

  //Delete a certain promotion in Cloud Firestore
  Future<void> deletePromotionDataToState(
      DeletePromotion event, Emitter<PromotionState> emit) async {
    try {
      if (state is PromotionLoadedState) {
        PromotionLoadedState previousState = state as PromotionLoadedState;
        emit(PromotionDeletingState());

        await firestoreRepository.deletePromotionData(event.id);

        //Removing the promotion
        int promotionItemIndex = previousState.promotions.indexWhere(
          (item) => item.id == event.id,
        );
        List<Promotion> finalList = List.from(previousState.promotions)
          ..removeAt(promotionItemIndex);

        emit(PromotionSuccessDeleted());
        emit(PromotionLoadedState(promotions: finalList));
      }
    } catch (e) {
      emit(PromotionErrorState(e.toString()));
    }
  }
}
