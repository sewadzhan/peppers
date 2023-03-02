part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

//Load all users from Firestore
class LoadUsers extends UserEvent {}
