import 'package:equatable/equatable.dart';

import 'package:pikapika_admin_panel/data/models/gift_product.dart';

//Model for choosing gift in "Choose Gift" Screen
class GiftChooseModel extends Equatable {
  final GiftProduct product;
  final bool value;

  const GiftChooseModel(this.product, this.value);

  @override
  List<Object?> get props => [product, value];

  GiftChooseModel copyWith({
    GiftProduct? product,
    bool? value,
  }) {
    return GiftChooseModel(
      product ?? this.product,
      value ?? this.value,
    );
  }
}
