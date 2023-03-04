part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

//Load all users from Firestore
class LoadUsers extends UserEvent {}

//Change the individual percent of certain user
class UserIndividualPercentChanged extends UserEvent {
  final String phoneNumber;
  final int? percent;

  const UserIndividualPercentChanged(this.phoneNumber, this.percent);

  @override
  List<Object> get props => [phoneNumber];
}
