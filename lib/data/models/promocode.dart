import 'package:equatable/equatable.dart';

//Types of promocode (percent descount or fixed value discount)
enum PromocodeType { percent, flexible, fixed }

//Promocode model
class Promocode extends Equatable {
  final PromocodeType type;
  final String code;
  final String discountID;
  final double value;
  final bool isActive;
  final bool canBeUsedOnlyOnce;
  final String startTimeLimit;
  final String finishTimeLimit;
  final String id;

  const Promocode({
    required this.type,
    required this.code,
    required this.discountID,
    required this.value,
    required this.isActive,
    required this.id,
    this.canBeUsedOnlyOnce = false,
    this.startTimeLimit = "",
    this.finishTimeLimit = "",
  });

  @override
  List<Object> get props =>
      [id, type, code, discountID, value, canBeUsedOnlyOnce];

  factory Promocode.fromMap(Map<String, dynamic> map, String id) {
    PromocodeType type;

    switch (map['type']) {
      case "percent":
        type = PromocodeType.percent;
        break;
      default:
        type = PromocodeType.fixed;
    }
    return Promocode(
        id: id,
        type: type,
        code: map['code'] ?? '',
        discountID: map['discountID'] ?? '',
        value: map['value']?.toDouble() ?? 0.0,
        isActive: map['isActive'],
        canBeUsedOnlyOnce: map['canBeUsedOnlyOnce'] ?? false,
        startTimeLimit:
            map['hourlyLimit'] == null ? "" : map['hourlyLimit']['start'],
        finishTimeLimit:
            map['hourlyLimit'] == null ? "" : map['hourlyLimit']['finish']);
  }
  Map<String, dynamic> toMap() {
    var typeStr = type == PromocodeType.percent ? "percent" : "value";
    return {
      'type': typeStr,
      'code': code,
      'discountID': discountID,
      'value': value,
      'isActive': isActive,
      'canBeUsedOnlyOnce': canBeUsedOnlyOnce,
      'hourlyLimit': {"start": startTimeLimit, "finish": finishTimeLimit}
    };
  }

  Promocode copyWith({
    PromocodeType? type,
    String? code,
    String? discountID,
    double? value,
    bool? isActive,
    bool? canBeUsedOnlyOnce,
    String? startTimeLimit,
    String? finishTimeLimit,
    String? id,
  }) {
    return Promocode(
        type: type ?? this.type,
        code: code ?? this.code,
        discountID: discountID ?? this.discountID,
        value: value ?? this.value,
        isActive: isActive ?? this.isActive,
        id: id ?? this.id);
  }
}
