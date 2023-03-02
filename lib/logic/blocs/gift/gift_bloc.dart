import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/gift_goal.dart';
import 'package:pikapika_admin_panel/data/models/gift_progress_bar.dart';
import 'package:pikapika_admin_panel/data/models/iiko_category.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';
import 'package:pikapika_admin_panel/data/repositories/iiko_repository.dart';

part 'gift_event.dart';
part 'gift_state.dart';

class GiftBloc extends Bloc<GiftEvent, GiftState> {
  final FirestoreRepository firestoreRepository;
  final IikoRepository iikoRepository;

  GiftBloc(this.firestoreRepository, this.iikoRepository)
      : super(GiftInitialState()) {
    on<LoadGiftData>(loadGiftDataToState);
    on<UpdateGiftData>(updateGiftDataToState);
    on<GiftIsEnabledChanged>(giftIsEnabledChangedToState);
    on<GiftIsSingleGiftChanged>(giftIsSingleGiftChangedToState);
  }

  //Load the actual list of Gifts from Firestore
  Future<void> loadGiftDataToState(
      LoadGiftData event, Emitter<GiftState> emit) async {
    try {
      emit(GiftLoadingState());

      final GiftProgressBarModel giftGoals =
          await firestoreRepository.getGiftProgressBarModel();

      String token = await iikoRepository.getToken();
      String organization = await iikoRepository.getOrganization(token);
      List<IikoCategory> iikoCategories =
          await iikoRepository.getCategories(token, organization);

      emit(GiftLoadedState(giftGoals, iikoCategories));
    } catch (e) {
      emit(GiftErrorState(e.toString()));
    }
  }

  //Update all gift goal data in Cloud Firestore
  Future<void> updateGiftDataToState(
      UpdateGiftData event, Emitter<GiftState> emit) async {
    try {
      if (state is GiftLoadedState) {
        GiftLoadedState previousState = state as GiftLoadedState;
        emit(GiftSavingState());

        //Fields validation
        if (!fieldsValidation(
            event.gift1Goal, event.gift2Goal, event.gift3Goal)) {
          emit(const GiftErrorState("Введите все необходимые поля корректно"));
          emit(previousState);
          return;
        }

        var updatedGiftData = previousState.giftGoals.copyWith(
            gift1: GiftGoal(
                categoryID: event.gift1CategoryID,
                goal: int.parse(event.gift1Goal),
                description: event.gift1Description,
                icon: event.gift1Icon,
                isSingleGift: previousState.giftGoals.gift1.isSingleGift,
                isEnabled: previousState.giftGoals.gift1.isEnabled),
            gift2: GiftGoal(
                categoryID: event.gift2CategoryID,
                goal: int.parse(event.gift2Goal),
                description: event.gift2Description,
                icon: event.gift2Icon,
                isSingleGift: previousState.giftGoals.gift2.isSingleGift,
                isEnabled: previousState.giftGoals.gift2.isEnabled),
            gift3: GiftGoal(
                categoryID: event.gift3CategoryID,
                goal: int.parse(event.gift3Goal),
                description: event.gift3Description,
                icon: event.gift3Icon,
                isSingleGift: previousState.giftGoals.gift3.isSingleGift,
                isEnabled: previousState.giftGoals.gift3.isEnabled));

        print("YEEEEEEEEEEEEEE");
        print(updatedGiftData);

        await firestoreRepository.updateGiftProgressBarModel(updatedGiftData);

        emit(GiftSuccessSaved());
        emit(GiftLoadedState(updatedGiftData, previousState.iikoCategories));
      }
    } catch (e) {
      emit(GiftErrorState(e.toString()));
    }
  }

  //Fields validation
  bool fieldsValidation(String gift1Goal, String gift2Goal, String gift3Goal) {
    return int.tryParse(gift1Goal) != null &&
        int.tryParse(gift2Goal) != null &&
        int.tryParse(gift3Goal) != null;
  }

  Future<void> giftIsEnabledChangedToState(
      GiftIsEnabledChanged event, Emitter<GiftState> emit) async {
    var previousState = state;
    if (previousState is GiftLoadedState) {
      switch (event.giftType) {
        case "gift1":
          emit(GiftLoadedState(
              previousState.giftGoals.copyWith(
                  gift1: previousState.giftGoals.gift1
                      .copyWith(isEnabled: event.value)),
              previousState.iikoCategories));
          return;
        case "gift2":
          emit(GiftLoadedState(
              previousState.giftGoals.copyWith(
                  gift2: previousState.giftGoals.gift2
                      .copyWith(isEnabled: event.value)),
              previousState.iikoCategories));
          return;
        case "gift3":
          emit(GiftLoadedState(
              previousState.giftGoals.copyWith(
                  gift3: previousState.giftGoals.gift3
                      .copyWith(isEnabled: event.value)),
              previousState.iikoCategories));
          return;
      }
    }
  }

  Future<void> giftIsSingleGiftChangedToState(
      GiftIsSingleGiftChanged event, Emitter<GiftState> emit) async {
    var previousState = state;
    if (previousState is GiftLoadedState) {
      switch (event.giftType) {
        case "gift1":
          emit(GiftLoadedState(
              previousState.giftGoals.copyWith(
                  gift1: previousState.giftGoals.gift1
                      .copyWith(isSingleGift: event.value)),
              previousState.iikoCategories));
          return;
        case "gift2":
          emit(GiftLoadedState(
              previousState.giftGoals.copyWith(
                  gift2: previousState.giftGoals.gift2
                      .copyWith(isSingleGift: event.value)),
              previousState.iikoCategories));
          return;
        case "gift3":
          emit(GiftLoadedState(
              previousState.giftGoals.copyWith(
                  gift3: previousState.giftGoals.gift3
                      .copyWith(isSingleGift: event.value)),
              previousState.iikoCategories));
          return;
      }
    }
  }
}
