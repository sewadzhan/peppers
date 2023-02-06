import 'package:equatable/equatable.dart';

//Base of all products in menu
abstract class BaseProduct extends Equatable {
  final String categoryID;
  final String title;
  final String imageUrl;
  final String iikoID;
  final int price;

  const BaseProduct(
      {required this.categoryID,
      required this.title,
      required this.imageUrl,
      required this.iikoID,
      required this.price});

  @override
  List<Object> get props => [];
}
