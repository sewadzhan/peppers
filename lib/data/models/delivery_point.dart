import 'package:google_maps_flutter/google_maps_flutter.dart';

//Model for delivery points of restaurant
class DeliveryPoint {
  final String address;
  final LatLng latLng;
  final String organizationID;

  DeliveryPoint(
      {required this.address,
      required this.latLng,
      required this.organizationID});

  @override
  String toString() {
    return "Point address: $address\nLatLng: $latLng\norganizationID: $organizationID";
  }
}
