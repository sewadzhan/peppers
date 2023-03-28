import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:peppers_admin_panel/data/models/delivery_point.dart';
import 'package:peppers_admin_panel/data/models/iiko_organization.dart';
import 'package:peppers_admin_panel/data/repositories/firestore_repository.dart';
import 'package:peppers_admin_panel/data/repositories/iiko_repository.dart';
import 'package:peppers_admin_panel/logic/blocs/contact/contact_bloc.dart';

part 'pickup_point_event.dart';
part 'pickup_point_state.dart';

class PickupPointBloc extends Bloc<PickupPointEvent, PickupPointState> {
  final FirestoreRepository firestoreRepository;
  final IikoRepository iikoRepository;
  final ContactBloc contactBloc;

  PickupPointBloc(
      this.firestoreRepository, this.iikoRepository, this.contactBloc)
      : super(PickupPointInitialState()) {
    on<LoadPickupPointData>(loadPickupPointDataToState);
    on<AddPickupPoint>(addPickupPointToState);
    on<UpdatePickupPointData>(updatePickupPointDataToState);
    on<DeletePickupPoint>(deletePickupPointToState);
  }

  //Load the actual list of PickupPoints from Firestore
  Future<void> loadPickupPointDataToState(
      LoadPickupPointData event, Emitter<PickupPointState> emit) async {
    try {
      emit(PickupPointLoadingState());

      String token = await iikoRepository.getToken();
      var iikoOrganizations = await iikoRepository.getAllOrganizations(token);

      emit(PickupPointLoadedState(iikoOrganizations));
    } catch (e) {
      emit(PickupPointErrorState(e.toString()));
    }
  }

  //Add new pickup point to Firestore
  Future<void> addPickupPointToState(
      AddPickupPoint event, Emitter<PickupPointState> emit) async {
    try {
      if (state is PickupPointLoadedState) {
        var previousState = state as PickupPointLoadedState;
        emit(PickupPointSavingState());

        //Validation
        if (event.address.trim().isEmpty ||
            event.organizationID.trim().isEmpty ||
            event.latlng.isEmpty) {
          emit(const PickupPointErrorState(
              "Введите корректные данные для сохранения"));
          emit(PickupPointLoadedState(previousState.iikoOrganizations));
          return;
        }

        DeliveryPoint addedPickupPoint = DeliveryPoint(
            id: event.address,
            address: event.address,
            latLng: LatLng(double.parse(event.latlng.split(',')[0]),
                double.parse(event.latlng.split(',')[1])),
            organizationID: event.organizationID);
        var currentPickupPoints =
            (contactBloc.state as ContactLoaded).contactsModel.pickupPoints;
        currentPickupPoints.add(addedPickupPoint);

        await firestoreRepository.updatePickupPointData(addedPickupPoint);
        contactBloc.add(ContactPickupPointsChanged(currentPickupPoints));

        emit(PickupPointSuccessSaved());
        emit(PickupPointLoadedState(previousState.iikoOrganizations));
      }
    } catch (e) {
      emit(PickupPointErrorState(e.toString()));
    }
  }

  //Update the pickup point to Firestore
  Future<void> updatePickupPointDataToState(
      UpdatePickupPointData event, Emitter<PickupPointState> emit) async {
    try {
      if (state is PickupPointLoadedState) {
        var previousState = state as PickupPointLoadedState;
        emit(PickupPointSavingState());

        //Validation
        if (event.address.trim().isEmpty ||
            event.organizationID.trim().isEmpty ||
            event.latlng.isEmpty) {
          emit(const PickupPointErrorState(
              "Введите корректные данные для сохранения"));
          emit(PickupPointLoadedState(previousState.iikoOrganizations));
          return;
        }

        DeliveryPoint updatedPickupPoint = DeliveryPoint(
            id: event.id,
            address: event.address,
            latLng: LatLng(double.parse(event.latlng.split(',')[0]),
                double.parse(event.latlng.split(',')[1])),
            organizationID: event.organizationID);

        var currentPickupPoints =
            (contactBloc.state as ContactLoaded).contactsModel.pickupPoints;
        //Replacing the updated element of list
        currentPickupPoints[currentPickupPoints.indexWhere(
            (element) => element.id == event.id)] = updatedPickupPoint;

        await firestoreRepository.updatePickupPointData(updatedPickupPoint);
        contactBloc.add(ContactPickupPointsChanged(currentPickupPoints));

        emit(PickupPointSuccessSaved());
        emit(PickupPointLoadedState(previousState.iikoOrganizations));
      }
    } catch (e) {
      emit(PickupPointErrorState(e.toString()));
    }
  }

  //Delete the pickup point to Firestore
  Future<void> deletePickupPointToState(
      DeletePickupPoint event, Emitter<PickupPointState> emit) async {
    try {
      if (state is PickupPointLoadedState) {
        var previousState = state as PickupPointLoadedState;
        emit(PickupPointDeletingState());

        var currentPickupPoints =
            (contactBloc.state as ContactLoaded).contactsModel.pickupPoints;

        //Removing the pickup point
        int pickupPointItemIndex = currentPickupPoints.indexWhere(
          (item) => item.id == event.id,
        );
        List<DeliveryPoint> finalList = List.from(currentPickupPoints)
          ..removeAt(pickupPointItemIndex);

        await firestoreRepository.deletePickupPointData(event.id);
        contactBloc.add(ContactPickupPointsChanged(finalList));

        emit(PickupPointSuccessDeleted());
        emit(PickupPointLoadedState(previousState.iikoOrganizations));
      }
    } catch (e) {
      emit(PickupPointErrorState(e.toString()));
    }
  }
}
