import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum AddressType { home, work, other }

//Model for customer's addresses
class Address extends Equatable {
  final String id;
  final String address;
  final String apartmentOrOffice;
  final AddressType type;
  final LatLng geopoint;

  const Address(
      {required this.id,
      required this.address,
      required this.apartmentOrOffice,
      required this.type,
      required this.geopoint});

  @override
  List<Object?> get props => [address, apartmentOrOffice, type, geopoint];

  factory Address.fromMap(Map<String, dynamic> map) {
    AddressType type;
    GeoPoint pos = map['geopoint'];

    switch (map['type']) {
      case "home":
        type = AddressType.home;
        break;
      case "work":
        type = AddressType.work;
        break;
      default:
        type = AddressType.other;
    }

    return Address(
        id: map['id'] ?? '',
        address: map['address'] ?? '',
        apartmentOrOffice: map['apartmentOrOffice'] ?? '',
        type: type,
        geopoint: LatLng(pos.latitude, pos.longitude));
  }

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source));

  String typeToString(AddressType type) {
    switch (type) {
      case AddressType.home:
        return "home";
      case AddressType.work:
        return "work";
      default:
        return "other";
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'apartmentOrOffice': apartmentOrOffice,
      'type': typeToString(type),
      'geopoint': GeoPoint(geopoint.latitude, geopoint.longitude)
    };
  }
}
