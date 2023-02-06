part of 'promotion_bloc.dart';

abstract class PromotionState extends Equatable {
  const PromotionState();

  @override
  List<Object?> get props => [];
}

class PromotionInitialState extends PromotionState {}

class PromotionLoadingState extends PromotionState {}

class PromotionLoadedState extends PromotionState {
  final List<Promotion> promotions;

  const PromotionLoadedState({required this.promotions});

  @override
  List<Object?> get props => [promotions];
}

class PromotionErrorState extends PromotionState {}
