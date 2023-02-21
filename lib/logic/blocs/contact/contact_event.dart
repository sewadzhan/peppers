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

//Update the state without validation
class ContactStateChanged extends ContactEvent {
  final ContactsModel contactsModel;

  const ContactStateChanged(this.contactsModel);

  @override
  List<Object> get props => [contactsModel];
}

//Update the data in Cloud Firestore
class ContactPaymentMethodChanged extends ContactEvent {
  final String paymentMethod;
  final bool value;

  const ContactPaymentMethodChanged(this.paymentMethod, this.value);

  @override
  List<Object> get props => [paymentMethod, value];
}

//Update the data in Cloud Firestore
class ContactPickupPointsChanged extends ContactEvent {
  final List<DeliveryPoint> pickupPoints;

  const ContactPickupPointsChanged(this.pickupPoints);

  @override
  List<Object> get props => [pickupPoints];
}
