import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

//Model for restaurant's delivery zones
class DeliveryZone {
  final int cost;
  final List<LatLng> geopoints;
  final String description;
  final Color color;
  final String organizationID;

  DeliveryZone(
      {required this.cost,
      required this.geopoints,
      required this.description,
      required this.color,
      required this.organizationID});

  factory DeliveryZone.fromMap(Map<String, dynamic> map) {
    List<LatLng> geopoints = [];
    var coords = (map['geopoints'] as String).split(',');

    for (int i = 0; i < coords.length; i++) {
      var tmp = coords[i].split(' ');
      geopoints.add(LatLng(double.parse(tmp[1]), double.parse(tmp[0])));
    }

    Color color;

    switch (map['color']) {
      case "yellow":
        color = const Color(0xFFF7FB3F);
        break;
      case "blue":
        color = const Color(0xFF009FF9);
        break;
      case "green":
        color = const Color(0xFF00FF38);
        break;
      default:
        color = Constants.primaryColor;
        break;
    }

    return DeliveryZone(
        cost: map['cost']?.toInt() ?? 0,
        geopoints: geopoints,
        description: map['description'] ?? '',
        color: color,
        organizationID: map['organizationID']);
  }

  factory DeliveryZone.fromJson(String source) =>
      DeliveryZone.fromMap(json.decode(source));
}
