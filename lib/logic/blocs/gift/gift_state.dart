part of 'gift_bloc.dart';

abstract class GiftState extends Equatable {
  const GiftState();

  @override
  List<Object> get props => [];
}

class GiftInitialState extends GiftState {}

class GiftLoadingState extends GiftState {}

class GiftSavingState extends GiftState {}

class GiftSuccessSaved extends GiftState {}

class GiftLoadedState extends GiftState {
  final GiftProgressBarModel giftGoals;
  final List<IikoCategory> iikoCategories;

  const GiftLoadedState(this.giftGoals, this.iikoCategories);

  @override
  List<Object> get props => [giftGoals, iikoCategories];
}

class GiftErrorState extends GiftState {
  final String message;

  const GiftErrorState(this.message);

  @override
  List<Object> get props => [message];
}
