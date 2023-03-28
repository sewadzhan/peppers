import 'package:equatable/equatable.dart';

import 'package:peppers_admin_panel/data/models/cart_item.dart';
import 'package:peppers_admin_panel/data/models/promocode.dart';

//Cart model
class Cart extends Equatable {
  final List<CartItemModel> items;
  final Promocode? activePromocode;

  const Cart(this.items, {this.activePromocode});

  int get subtotal => items.fold(
      0,
      (previousValue, element) =>
          previousValue + element.product.price * element.count);

  int get giftSubtotal => items.fold(0, (previousValue, element) {
        if (element.product.categoryID !=
            "0ede2705-fbda-4d38-9bff-fd7e65704175") {
          return previousValue + element.product.price * element.count;
        }
        return previousValue;
      });

  int get discount {
    if (activePromocode != null) {
      switch (activePromocode!.type) {
        case PromocodeType.percent:
          return (subtotal / 100.0 * activePromocode!.value).toInt();
        case PromocodeType.flexible:
          return activePromocode!.value.toInt();
        case PromocodeType.fixed:
          return activePromocode!.value.toInt();
      }
    }
    return 0;
  }

  @override
  List<Object?> get props => [items, activePromocode];

  Cart copyWith({
    List<CartItemModel>? items,
    Promocode? activePromocode,
  }) {
    return Cart(
      items ?? this.items,
      activePromocode: activePromocode ?? this.activePromocode,
    );
  }
}
