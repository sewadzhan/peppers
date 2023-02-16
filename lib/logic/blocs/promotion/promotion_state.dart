part of 'promotion_bloc.dart';

abstract class PromotionState extends Equatable {
  const PromotionState();

  @override
  List<Object?> get props => [];
}

class PromotionInitialState extends PromotionState {}

class PromotionLoadingState extends PromotionState {}

class PromotionSavingState extends PromotionState {}

class PromotionDeletingState extends PromotionState {}

class PromotionSuccessSaved extends PromotionState {}

class PromotionSuccessDeleted extends PromotionState {}

class PromotionLoadedState extends PromotionState {
  final List<Promotion> promotions;

  const PromotionLoadedState({required this.promotions});

  @override
  List<Object?> get props => [promotions];
}

class PromotionErrorState extends PromotionState {
  final String message;

  const PromotionErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
