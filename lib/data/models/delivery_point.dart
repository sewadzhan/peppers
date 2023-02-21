import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Model for delivery points of restaurant
class DeliveryPoint {
  final String address;
  final LatLng latLng;
  final String organizationID;
  final String id;

  DeliveryPoint(
      {required this.id,
      required this.address,
      required this.latLng,
      required this.organizationID});

  @override
  String toString() {
    return "Point address: $address\nLatLng: $latLng\norganizationID: $organizationID\n id: $id";
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'geopoint': GeoPoint(latLng.latitude, latLng.longitude),
      'organizationID': organizationID
    };
  }
}
