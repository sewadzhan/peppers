part of 'pickup_point_bloc.dart';

abstract class PickupPointEvent extends Equatable {
  const PickupPointEvent();

  @override
  List<Object> get props => [];
}

//Load actual promocodes data from Firestore
class LoadPickupPointData extends PickupPointEvent {}

//Update the data in Cloud Firestore
class UpdatePickupPointData extends PickupPointEvent {
  final String address;
  final String latlng;
  final String organizationID;
  final String id;

  const UpdatePickupPointData(
      {required this.address,
      required this.latlng,
      required this.organizationID,
      required this.id});

  @override
  List<Object> get props => [address, latlng, organizationID, id];
}

//Add a new promocode in Cloud Firestore
class AddPickupPoint extends PickupPointEvent {
  final String address;
  final String latlng;
  final String organizationID;

  const AddPickupPoint({
    required this.address,
    required this.latlng,
    required this.organizationID,
  });

  @override
  List<Object> get props => [address, latlng, organizationID];
}

//Delete certain promocode from Cloud Firestore
class DeletePickupPoint extends PickupPointEvent {
  final String id;

  const DeletePickupPoint({required this.id});

  @override
  List<Object> get props => [id];
}
