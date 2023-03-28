import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:peppers_admin_panel/data/models/base_product.dart';

//Model for cart item
class CartItemModel extends Equatable {
  final BaseProduct product;
  final int count;

  const CartItemModel({required this.product, required this.count});

  CartItemModel copyWith({
    BaseProduct? product,
    int? count,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [product, count];

  @override
  String toString() {
    return "Product title: ${product.title} count: $count";
  }

  Map<String, dynamic> toMap() {
    return {
      'productTitle': product.title,
      'productPrice': product.price,
      'count': count,
    };
  }

  String toJson() => json.encode(toMap());
}
