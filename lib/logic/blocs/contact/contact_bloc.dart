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
      print(e);
      emit(ContactsErrorState(e.toString()));
    }
  }

  //Editing a contact information in Cloud Firestore
  Future<void> updateContactDataToState(
      UpdateContactData event, Emitter<ContactState> emit) async {
    try {
      await firestoreRepository.updateContactsData(event.contactsModel);
      emit(ContactLoaded(event.contactsModel));
    } catch (e) {
      print(e);
      emit(ContactsErrorState(e.toString()));
    }
  }
}
