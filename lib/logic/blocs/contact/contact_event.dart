part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}

//Load actual data from Firestore
class LoadContactData extends ContactEvent {}

//Update the data in Cloud Firestore
class UpdateContactData extends ContactEvent {
  final ContactsModel contactsModel;

  const UpdateContactData(this.contactsModel);

  @override
  List<Object> get props => [contactsModel];
}
