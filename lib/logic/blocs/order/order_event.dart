part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

//Load all orders from Firestore
class LoadOrders extends OrderEvent {}
