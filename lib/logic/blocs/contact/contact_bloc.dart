import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/contacts.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final FirestoreRepository firestoreRepository;
  ContactBloc(this.firestoreRepository) : super(ContactInitial()) {
    on<LoadContactData>(loadContactDataToState);
    on<UpdateContactData>(updateContactDataToState);
  }

  //Loading actual contact information from Cloud Firestore
  Future<void> loadContactDataToState(
      LoadContactData event, Emitter<ContactState> emit) async {
    emit(ContactLoading());
    try {
      final ContactsModel contactsModel =
          await firestoreRepository.getContactsData();
      emit(ContactLoaded(contactsModel));
    } catch (e) {
      emit(ContactsError(e.toString()));
    }
  }

  //Editing the contact information in Cloud Firestore
  Future<void> updateContactDataToState(
      UpdateContactData event, Emitter<ContactState> emit) async {
    if (state is ContactLoaded) {
      try {
        emit(ContactSaving());
        if (event.contactsModel.email.trim().isEmpty ||
            event.contactsModel.phone.trim().isEmpty ||
            event.contactsModel.webSite.trim().isEmpty ||
            event.contactsModel.whatsappUrl.trim().isEmpty ||
            event.contactsModel.instagramUrl.trim().isEmpty ||
            event.contactsModel.openHour.trim().isEmpty ||
            event.contactsModel.closeHour.trim().isEmpty) {
          emit(const ContactsError(
              "Введите все необходимые данные для сохранения"));
          emit(ContactLoaded(event.contactsModel));
          return;
        }

        await firestoreRepository.updateContactsData(event.contactsModel);
        emit(ContactSuccessSaved());
      } catch (e) {
        print(e);
        emit(ContactsError(e.toString()));
      }
      emit(ContactLoaded(event.contactsModel));
    }
  }
}
