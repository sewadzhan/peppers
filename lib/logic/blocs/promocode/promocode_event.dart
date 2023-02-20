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
  final PromocodeType? type;
  final String code;
  final String discountID;
  final String value;
  final bool isActive;
  final bool canBeUsedOnlyOnce;
  final String startTimeLimit;
  final String finishTimeLimit;
  final String id;

  const UpdatePromocodeData(
      {required this.type,
      required this.code,
      required this.discountID,
      required this.value,
      required this.isActive,
      required this.canBeUsedOnlyOnce,
      required this.startTimeLimit,
      required this.finishTimeLimit,
      required this.id});

  @override
  List<Object> get props => [
        code,
        value,
        isActive,
        canBeUsedOnlyOnce,
        startTimeLimit,
        finishTimeLimit,
        id
      ];
}

//Add a new promocode in Cloud Firestore
class AddPromocode extends PromocodeEvent {
  final PromocodeType? type;
  final String code;
  final String discountID;
  final String value;
  final bool isActive;
  final bool canBeUsedOnlyOnce;
  final String startTimeLimit;
  final String finishTimeLimit;

  const AddPromocode({
    required this.type,
    required this.code,
    required this.discountID,
    required this.value,
    required this.isActive,
    required this.canBeUsedOnlyOnce,
    required this.startTimeLimit,
    required this.finishTimeLimit,
  });

  @override
  List<Object> get props => [
        code,
        value,
        isActive,
        canBeUsedOnlyOnce,
        startTimeLimit,
        finishTimeLimit,
      ];
}

//Delete certain promocode from Cloud Firestore
class DeletePromocode extends PromocodeEvent {
  final String id;

  const DeletePromocode({required this.id});

  @override
  List<Object> get props => [id];
}
