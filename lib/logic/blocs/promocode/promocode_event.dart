part of 'promocode_bloc.dart';

abstract class PromocodeEvent extends Equatable {
  const PromocodeEvent();

  @override
  List<Object> get props => [];
}

//Load actual promocodes data from Firestore
class LoadPromocodeData extends PromocodeEvent {}

//Update the data in Cloud Firestore
class UpdatePromocodeData extends PromocodeEvent {
  final Promocode promocode;

  const UpdatePromocodeData(this.promocode);

  @override
  List<Object> get props => [promocode];
}

//Add a new promocode in Cloud Firestore
class AddPromocode extends PromocodeEvent {
  final Promocode promocode;

  const AddPromocode(this.promocode);

  @override
  List<Object> get props => [promocode];
}
