import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_paybox/paybox.dart';

import 'package:pikapika_admin_panel/data/models/cart_item.dart';
import 'package:pikapika_admin_panel/data/models/checkout.dart';
import 'package:pikapika_admin_panel/data/models/product.dart';
import 'package:pikapika_admin_panel/presentation/config/config.dart';

enum OrderStatus {
  unconfirmed,
  waitCooking,
  readyForCooking,
  cookingStarted,
  cookingCompleted,
  waiting,
  onWay,
  delivered,
  closed,
  cancelled
}

//Model for order
class Order extends Equatable {
  final int id;
  final DateTime dateTime;
  final String phoneNumber;
  final String fullAddress;
  final int deliveryCost;
  final int discount;
  final int subtotal;
  final int total;
  final PaymentMethod paymentMethod;
  final OrderType orderType;
  // final OrderStatus status;
  final List<CartItemModel> cartItems;
  final int cashbackUsed;
  final Card? savedCard;
  final String? savedCardLabel;

  const Order(
      {required this.phoneNumber,
      required this.fullAddress,
      required this.deliveryCost,
      required this.discount,
      required this.subtotal,
      required this.total,
      required this.paymentMethod,
      required this.orderType,
      //required this.status,
      required this.cartItems,
      required this.id,
      required this.dateTime,
      required this.cashbackUsed,
      this.savedCard,
      this.savedCardLabel});

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'dateTime': FieldValue.serverTimestamp(),
      'phoneNumber': phoneNumber,
      'fullAddress': fullAddress,
      'deliveryCost': deliveryCost,
      'discount': discount,
      'subtotal': subtotal,
      'total': total,
      'paymentMethod':
          Config.paymentMethodToString(paymentMethod: paymentMethod),
      'orderType': Config.orderTypeToString(orderType),
      //'status': Config.orderStatusToString(status),
      'cartItems': cartItems.map((x) => x.toMap()).toList(),
      'cashbackUsed': cashbackUsed
    };

    if (paymentMethod == PaymentMethod.savedBankCard) {
      map['savedCardLabel'] = savedCard?.cardHash != null
          ? Config.getCardLabel(savedCard!.cardHash!)
          : "Сохраненной картой";
    }

    return map;
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    List<dynamic> cartItemsMap = List.from(map['cartItems']);

    List<CartItemModel> cartItems = cartItemsMap.map((item) {
      return CartItemModel(
          count: item['count'],
          product: Product(
              title: item['productTitle'],
              price: item['productPrice'],
              iikoID: '',
              imageUrl: '',
              categoryID: '',
              description: '',
              features: const []));
    }).toList();

    Timestamp t = map['dateTime'];

    return Order(
        id: map['id']?.toInt() ?? 0,
        dateTime: t.toDate(),
        phoneNumber: map['phoneNumber'] ?? '',
        fullAddress: map['fullAddress'] ?? '',
        deliveryCost: map['deliveryCost']?.toInt() ?? 0.0,
        discount: map['discount']?.toInt() ?? 0.0,
        subtotal: map['subtotal']?.toInt() ?? 0.0,
        total: map['total']?.toInt() ?? 0.0,
        paymentMethod: Config.paymentMethodFromString(map['paymentMethod']),
        orderType: Config.orderTypeFromString(map['orderType']),
        //status: Config.orderStatusFromString(map['status']),
        cartItems: cartItems,
        cashbackUsed: map['cashbackUsed']?.toInt() ?? 0,
        savedCardLabel: map['savedCardLabel']);
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
        cartItems,
        id,
        dateTime,
        phoneNumber,
        fullAddress,
        deliveryCost,
        discount,
        subtotal,
        paymentMethod,
        total,
        //   status,
        cashbackUsed,
        savedCard,
        savedCardLabel
      ];

  Order copyWith(
      {int? id,
      DateTime? dateTime,
      String? phoneNumber,
      String? fullAddress,
      int? deliveryCost,
      int? discount,
      int? subtotal,
      int? total,
      PaymentMethod? paymentMethod,
      OrderType? orderType,
      // OrderStatus? status,
      List<CartItemModel>? cartItems,
      int? cashbackUsed,
      Card? savedCard,
      String? savedCardLabel}) {
    return Order(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullAddress: fullAddress ?? this.fullAddress,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      discount: discount ?? this.discount,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderType: orderType ?? this.orderType,
      // status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      cashbackUsed: cashbackUsed ?? this.cashbackUsed,
      savedCard: savedCard,
      savedCardLabel: savedCardLabel,
    );
  }
}
