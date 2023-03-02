import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/iiko_discount.dart';
import 'package:pikapika_admin_panel/data/models/promocode.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';
import 'package:pikapika_admin_panel/data/repositories/iiko_repository.dart';

part 'promocode_event.dart';
part 'promocode_state.dart';

class PromocodeBloc extends Bloc<PromocodeEvent, PromocodeState> {
  final FirestoreRepository firestoreRepository;
  final IikoRepository iikoRepository;

  PromocodeBloc(this.firestoreRepository, this.iikoRepository)
      : super(PromocodeInitialState()) {
    on<LoadPromocodeData>(loadPromocodeDataToState);
    on<UpdatePromocodeData>(updatePromocodeDataToState);
    on<AddPromocode>(addPromocodeToState);
    on<DeletePromocode>(deletePromocodeToState);
  }

  //Load the actual list of promocodes from Firestore
  Future<void> loadPromocodeDataToState(
      LoadPromocodeData event, Emitter<PromocodeState> emit) async {
    try {
      emit(PromocodeLoadingState());

      final List<Promocode> promocodes =
          await firestoreRepository.getPromocodes();

      String token = await iikoRepository.getToken();
      String organization = await iikoRepository.getOrganization(token);
      List<IikoDiscount> iikoDiscounts =
          await iikoRepository.getDiscounts(token, organization);

      emit(PromocodeLoadedState(promocodes, iikoDiscounts));
    } catch (e) {
      emit(PromocodeErrorState(e.toString()));
    }
  }

  //Update a certain promocode in Cloud Firestore
  Future<void> updatePromocodeDataToState(
      UpdatePromocodeData event, Emitter<PromocodeState> emit) async {
    try {
      if (state is PromocodeLoadedState) {
        PromocodeLoadedState previousState = state as PromocodeLoadedState;
        emit(PromocodeSavingState());

        //Fields validation
        if (fieldsValidation(event.code, event.startTimeLimit,
            event.finishTimeLimit, event.value, event.type)) {
          emit(const PromocodeErrorState(
              "Введите все необходимые поля корректно"));
          emit(previousState);
          return;
        }

        var updatedPromocode = Promocode(
            id: event.id,
            code: event.code,
            discountID: event.discountID,
            value: double.parse(event.value),
            type: event.type!,
            isActive: event.isActive,
            canBeUsedOnlyOnce: event.canBeUsedOnlyOnce,
            startTimeLimit: event.startTimeLimit,
            finishTimeLimit: event.finishTimeLimit);

        await firestoreRepository.updatePromocodeData(updatedPromocode);

        //Replacing the updated element of list
        var finalList = previousState.promocodes;
        finalList[finalList.indexWhere(
            (element) => element.id == updatedPromocode.id)] = updatedPromocode;

        emit(PromocodeSuccessSaved());
        emit(PromocodeLoadedState(finalList, previousState.iikoDiscounts));
      }
    } catch (e) {
      emit(PromocodeErrorState(e.toString()));
    }
  }

  //Add new promocode to Firestore
  Future<void> addPromocodeToState(
      AddPromocode event, Emitter<PromocodeState> emit) async {
    try {
      if (state is PromocodeLoadedState) {
        PromocodeLoadedState previousState = state as PromocodeLoadedState;
        emit(PromocodeSavingState());

        //Fields validation
        if (fieldsValidation(event.code, event.startTimeLimit,
            event.finishTimeLimit, event.value, event.type)) {
          emit(const PromocodeErrorState(
              "Введите все необходимые поля корректно"));
          emit(previousState);
          return;
        }

        var addedPromocode = Promocode(
            id: '',
            code: event.code,
            discountID: event.discountID,
            value: double.parse(event.value),
            type: event.type!,
            isActive: event.isActive,
            canBeUsedOnlyOnce: event.canBeUsedOnlyOnce,
            startTimeLimit: event.startTimeLimit,
            finishTimeLimit: event.finishTimeLimit);

        var promocodeID =
            await firestoreRepository.addPromocode(addedPromocode);

        List<Promocode> finalList = List.from(previousState.promocodes)
          ..add(addedPromocode.copyWith(id: promocodeID));

        emit(PromocodeSuccessSaved());
        emit(PromocodeLoadedState(finalList, previousState.iikoDiscounts));
      }
    } catch (e) {
      emit(PromocodeErrorState(e.toString()));
    }
  }

  //Delete a certain promocode in Cloud Firestore
  Future<void> deletePromocodeToState(
      DeletePromocode event, Emitter<PromocodeState> emit) async {
    try {
      if (state is PromocodeLoadedState) {
        PromocodeLoadedState previousState = state as PromocodeLoadedState;
        emit(PromocodeDeletingState());

        await firestoreRepository.deletePromocode(event.id);

        //Removing the promocode
        int promocodeItemIndex = previousState.promocodes.indexWhere(
          (item) => item.id == event.id,
        );
        List<Promocode> finalList = List.from(previousState.promocodes)
          ..removeAt(promocodeItemIndex);

        emit(PromocodeSuccessDeleted());
        emit(PromocodeLoadedState(finalList, previousState.iikoDiscounts));
      }
    } catch (e) {
      emit(PromocodeErrorState(e.toString()));
    }
  }

  //Fields validation
  bool fieldsValidation(String code, String startTimeLimit,
      String finishTimeLimit, String value, PromocodeType? type) {
    return code.trim().isEmpty ||
        (startTimeLimit.trim().isEmpty && finishTimeLimit.trim().isNotEmpty) ||
        (startTimeLimit.trim().isNotEmpty && finishTimeLimit.trim().isEmpty) ||
        type == null ||
        double.tryParse(value) == null;
  }
}
