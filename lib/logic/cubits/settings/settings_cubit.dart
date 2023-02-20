import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/cashback_data.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';
import 'package:pikapika_admin_panel/logic/blocs/cashback/cashback_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/contact/contact_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final FirestoreRepository firestoreRepository;
  final ContactBloc contactBloc;
  final CashbackBloc cashbackBloc;
  SettingsCubit(this.firestoreRepository, this.contactBloc, this.cashbackBloc)
      : super(SettingsInitial());

  //Update Settings in Cloud Firestore
  Future<void> updateSettings({
    required String percentCashback,
    required String appStoreUrl,
    required String playMarketUrl,
    required String minOrderSum,
  }) async {
    try {
      if (contactBloc.state is ContactLoaded &&
          cashbackBloc.state is CashbackLoaded) {
        emit(SettingsSaving());

        //Validation
        if (int.tryParse(percentCashback) == null ||
            int.tryParse(minOrderSum) == null ||
            appStoreUrl.trim().isEmpty ||
            playMarketUrl.trim().isEmpty) {
          emit(const SettingsError(
              "Введите корректно все необходимые данные для сохранения"));
          emit(SettingsInitial());
          return;
        }

        var contactBlocState = (contactBloc.state as ContactLoaded);
        var cashbackBlocState = (cashbackBloc.state as CashbackLoaded);
        var updatedContactModel = contactBlocState.contactsModel.copyWith(
            appStoreUrl: appStoreUrl,
            playMarketUrl: playMarketUrl,
            minOrderSum: int.parse(minOrderSum),
            paymentMethods: contactBlocState.contactsModel.paymentMethods);

        await firestoreRepository.updateCashbackData(
            cashbackBlocState.cashbackData.isEnabled,
            int.parse(percentCashback));
        await firestoreRepository.updateContactsData(updatedContactModel);

        contactBloc.add(ContactStateChanged(updatedContactModel));
        cashbackBloc.add(CashbackStateChanged(cashbackBlocState.cashbackData
            .copyWith(
                percent: int.parse(percentCashback),
                isEnabled: cashbackBlocState.cashbackData.isEnabled)));

        emit(SettingsSuccessSaved());
        emit(SettingsInitial());
      }
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }
}
