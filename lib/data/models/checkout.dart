import 'package:equatable/equatable.dart';
import 'package:flutter_paybox/paybox.dart';
import 'package:pikapika_admin_panel/data/models/address.dart';
import 'package:pikapika_admin_panel/data/models/delivery_point.dart';

enum OrderType { delivery, pickup }
enum DeliveryTimeType { fast, certainTime, none }
enum PaymentMethod {
  applePay,
  googlePay,
  cash,
  nonCash,
  bankCard,
  savedBankCard
}

//Model for Checkout page
class Checkout extends Equatable {
  final OrderType orderType;
  final Address address;
  final DeliveryTimeType deliveryTime;
  final int numberOfPersons;
  final PaymentMethod paymentMethod;
  final DeliveryPoint? pickupPoint;
  final String certainTimeOrder;
  final int deliveryCost;
  final String organizationID;
  final String comments;
  final Card? savedCard;
  final int changeWith;

  const Checkout(
      {required this.orderType,
      required this.address,
      required this.deliveryTime,
      required this.numberOfPersons,
      required this.paymentMethod,
      required this.pickupPoint,
      required this.certainTimeOrder,
      required this.deliveryCost,
      required this.organizationID,
      required this.comments,
      required this.savedCard,
      required this.changeWith});

  @override
  List<Object?> get props => [
        orderType,
        address,
        deliveryTime,
        numberOfPersons,
        paymentMethod,
        pickupPoint,
        certainTimeOrder,
        deliveryCost,
        organizationID,
        comments,
        savedCard,
        changeWith
      ];

  Checkout copyWith(
      {OrderType? orderType,
      Address? address,
      DeliveryTimeType? deliveryTime,
      int? numberOfPersons,
      PaymentMethod? paymentMethod,
      DeliveryPoint? pickupPoint,
      String? certainTimeOrder,
      int? deliveryCost,
      String? organizationID,
      String? comments,
      Card? savedCard,
      int? changeWith}) {
    return Checkout(
      orderType: orderType ?? this.orderType,
      address: address ?? this.address,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      numberOfPersons: numberOfPersons ?? this.numberOfPersons,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      pickupPoint: pickupPoint ?? this.pickupPoint,
      certainTimeOrder: certainTimeOrder ?? this.certainTimeOrder,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      organizationID: organizationID ?? this.organizationID,
      comments: comments ?? this.comments,
      savedCard: savedCard ?? this.savedCard,
      changeWith: changeWith ?? this.changeWith,
    );
  }
}
