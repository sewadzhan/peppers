import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikapika_admin_panel/data/models/delivery_point.dart';

//Model for contacts information
class ContactsModel {
  final String email;
  final String instagramUrl;
  final String phone;
  final String webSite;
  final String whatsappUrl;
  final String closeHour;
  final String openHour;
  final List<DeliveryPoint> pickupPoints;
  final int minOrderSum;
  final String playMarketUrl;
  final String appStoreUrl;
  final Map<String, bool> paymentMethods;
  final List<String> ranges;

  ContactsModel(
      {required this.email,
      required this.instagramUrl,
      required this.phone,
      required this.webSite,
      required this.whatsappUrl,
      required this.closeHour,
      required this.openHour,
      this.pickupPoints = const [],
      required this.minOrderSum,
      required this.playMarketUrl,
      required this.appStoreUrl,
      required this.paymentMethods,
      required this.ranges});

  factory ContactsModel.fromMap(Map<String, dynamic> data) {
    Map<String, Map<String, dynamic>> pointsMap =
        Map<String, Map<String, dynamic>>.from(data['points']);

    List<DeliveryPoint> points = pointsMap.values.map((point) {
      GeoPoint pos = point['geopoint'];
      return DeliveryPoint(
          address: point['address'],
          latLng: LatLng(pos.latitude, pos.longitude),
          organizationID: point['organizationID']);
    }).toList();

    return ContactsModel(
        email: data["email"],
        instagramUrl: data["instagramUrl"],
        phone: data["phone"],
        webSite: data["webSite"],
        whatsappUrl: data["whatsappUrl"],
        closeHour: data["workingHours"]['close'],
        openHour: data["workingHours"]['open'],
        minOrderSum: data['minimumOrderSum'],
        pickupPoints: points,
        playMarketUrl: data["playMarketUrl"],
        appStoreUrl: data["appStoreUrl"],
        paymentMethods: Map<String, bool>.from(data["paymentMethods"]),
        ranges: List.from(data['ranges']));
  }

  factory ContactsModel.fromJson(String source) =>
      ContactsModel.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'instagramUrl': instagramUrl,
      'phone': phone,
      'webSite': webSite,
      'whatsappUrl': whatsappUrl,
      'workingHours': {"open": openHour, "close": closeHour},
      'minimumOrderSum': minOrderSum,
      'pickupPoints': pickupPoints,
      'playMarketUrl': playMarketUrl,
      'appStoreUrl': appStoreUrl,
      'paymentMethods': paymentMethods,
      'ranges': ranges,
    };
  }

  ContactsModel copyWith({
    String? email,
    String? instagramUrl,
    String? phone,
    String? webSite,
    String? whatsappUrl,
    String? closeHour,
    String? openHour,
    List<DeliveryPoint>? pickupPoints,
    int? minOrderSum,
    String? playMarketUrl,
    String? appStoreUrl,
    Map<String, bool>? paymentMethods,
    List<String>? ranges,
  }) {
    return ContactsModel(
        email: email ?? this.email,
        instagramUrl: instagramUrl ?? this.instagramUrl,
        phone: phone ?? this.phone,
        webSite: webSite ?? this.webSite,
        whatsappUrl: whatsappUrl ?? this.whatsappUrl,
        closeHour: closeHour ?? this.closeHour,
        openHour: openHour ?? this.openHour,
        minOrderSum: minOrderSum ?? this.minOrderSum,
        playMarketUrl: playMarketUrl ?? this.playMarketUrl,
        appStoreUrl: appStoreUrl ?? this.appStoreUrl,
        paymentMethods: paymentMethods ?? this.paymentMethods,
        ranges: ranges ?? this.ranges);
  }
}
