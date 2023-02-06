import 'dart:convert';

import 'package:equatable/equatable.dart';

//Types of promocode (percent descount or fixed value discount)
enum PromocodeType { percent, value }

//Promocode model
class Promocode extends Equatable {
  final PromocodeType type;
  final String code;
  final String discountID;
  final double value;
  final bool isActive;
  final String id;

  const Promocode({
    required this.type,
    required this.code,
    required this.discountID,
    required this.value,
    required this.isActive,
    required this.id,
  });

  @override
  List<Object> get props => [type, code, discountID, value, id];

  factory Promocode.fromMap(Map<String, dynamic> map) {
    PromocodeType type;

    switch (map['type']) {
      case "percent":
        type = PromocodeType.percent;
        break;
      default:
        type = PromocodeType.value;
    }
    return Promocode(
        id: map['id'] ?? '',
        type: type,
        code: map['code'] ?? '',
        discountID: map['discountID'] ?? '',
        value: map['value']?.toDouble() ?? 0.0,
        isActive: map['isActive']);
  }

  factory Promocode.fromJson(String source) =>
      Promocode.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'code': code,
      'discountID': discountID,
      'value': value,
      'isActive': isActive,
    };
  }
}
