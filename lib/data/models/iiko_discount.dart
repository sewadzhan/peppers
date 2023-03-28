import 'package:equatable/equatable.dart';
import 'package:peppers_admin_panel/data/models/promocode.dart';

//Promocode model
class IikoDiscount extends Equatable {
  final PromocodeType type;
  final String id;
  final double value;

  const IikoDiscount({
    required this.type,
    required this.value,
    required this.id,
  });

  @override
  List<Object> get props => [id, type, value];

  factory IikoDiscount.fromMap(Map<String, dynamic> map) {
    PromocodeType type = PromocodeType.fixed;

    switch (map['mode']) {
      case "Percent":
        type = PromocodeType.percent;
        break;
      case "FlexibleSum":
        type = PromocodeType.flexible;
        break;
      case "FixedSum":
        type = PromocodeType.fixed;
        break;
    }
    return IikoDiscount(
      id: map['id'],
      type: type,
      value: type == PromocodeType.percent ? map['percent'] : map['sum'],
    );
  }

  @override
  String toString() {
    switch (type) {
      case PromocodeType.percent:
        return "Процентная скидка на $value%";
      case PromocodeType.flexible:
        return "Гибкая скидка";
      case PromocodeType.fixed:
        return "Фиксированная скидка на $value₸";
    }
  }
}
