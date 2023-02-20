part of 'promocode_bloc.dart';

abstract class PromocodeState extends Equatable {
  const PromocodeState();

  @override
  List<Object> get props => [];
}

class PromocodeInitialState extends PromocodeState {}

class PromocodeLoadingState extends PromocodeState {}

class PromocodeSavingState extends PromocodeState {}

class PromocodeDeletingState extends PromocodeState {}

class PromocodeSuccessSaved extends PromocodeState {}

class PromocodeSuccessDeleted extends PromocodeState {}

class PromocodeLoadedState extends PromocodeState {
  final List<Promocode> promocodes;
  final List<IikoDiscount> iikoDiscounts;

  const PromocodeLoadedState(this.promocodes, this.iikoDiscounts);

  @override
  List<Object> get props => [promocodes, iikoDiscounts];
}

class PromocodeErrorState extends PromocodeState {
  final String message;

  const PromocodeErrorState(this.message);

  @override
  List<Object> get props => [message];
}
