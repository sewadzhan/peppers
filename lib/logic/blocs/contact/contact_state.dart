part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final ContactsModel contactsModel;

  const ContactLoaded(this.contactsModel);

  @override
  List<Object> get props => [contactsModel];
}

class ContactsErrorState extends ContactState {
  final String message;

  const ContactsErrorState(this.message);

  @override
  List<Object> get props => [message];
}
