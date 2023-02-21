part of 'pickup_point_bloc.dart';

abstract class PickupPointState extends Equatable {
  const PickupPointState();

  @override
  List<Object> get props => [];
}

class PickupPointInitialState extends PickupPointState {}

class PickupPointLoadingState extends PickupPointState {}

class PickupPointSavingState extends PickupPointState {}

class PickupPointDeletingState extends PickupPointState {}

class PickupPointSuccessSaved extends PickupPointState {}

class PickupPointSuccessDeleted extends PickupPointState {}

class PickupPointLoadedState extends PickupPointState {
  final List<IikoOrganization> iikoOrganizations;

  const PickupPointLoadedState(this.iikoOrganizations);

  @override
  List<Object> get props => [iikoOrganizations];
}

class PickupPointErrorState extends PickupPointState {
  final String message;

  const PickupPointErrorState(this.message);

  @override
  List<Object> get props => [message];
}
