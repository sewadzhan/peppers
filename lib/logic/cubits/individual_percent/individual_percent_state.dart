part of 'individual_percent_cubit.dart';

abstract class IndividualPercentState extends Equatable {
  const IndividualPercentState();

  @override
  List<Object> get props => [];
}

class IndividualPercentInitial extends IndividualPercentState {}

class IndividualPercentSaving extends IndividualPercentState {}

class IndividualPercentSuccessSaved extends IndividualPercentState {}

class IndividualPercentError extends IndividualPercentState {
  final String message;

  const IndividualPercentError(this.message);

  @override
  List<Object> get props => [message];
}
