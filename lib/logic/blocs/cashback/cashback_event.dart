part of 'cashback_bloc.dart';

abstract class CashbackEvent extends Equatable {
  const CashbackEvent();

  @override
  List<Object> get props => [];
}

//Load cashback data from Firestore
class LoadCashbackData extends CashbackEvent {}

//Deposit cashback to user account
class CashbackDeposited extends CashbackEvent {
  final int value;
  final String phoneNumber;

  const CashbackDeposited({required this.value, required this.phoneNumber});

  @override
  List<Object> get props => [value, phoneNumber];
}

//Withdraw cashback from user account
class CashbackWithdrawed extends CashbackEvent {
  final int value;
  final String phoneNumber;

  const CashbackWithdrawed({required this.value, required this.phoneNumber});

  @override
  List<Object> get props => [value, phoneNumber];
}

//Change cashback action for further actions after successfull payment
class CashbackActionChanged extends CashbackEvent {
  final CashbackAction cashbackAction;

  const CashbackActionChanged({required this.cashbackAction});

  @override
  List<Object> get props => [cashbackAction];
}

//Update the state without validation
class CashbackStateChanged extends CashbackEvent {
  final CashbackData cashbackData;

  const CashbackStateChanged(this.cashbackData);

  @override
  List<Object> get props => [cashbackData];
}

//Update the isEnabled field
class CashbackIsEnabledChanged extends CashbackEvent {
  final bool value;

  const CashbackIsEnabledChanged(this.value);

  @override
  List<Object> get props => [value];
}
