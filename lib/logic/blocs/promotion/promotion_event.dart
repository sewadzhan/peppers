part of 'promotion_bloc.dart';

abstract class PromotionEvent extends Equatable {
  const PromotionEvent();

  @override
  List<Object> get props => [];
}

//Load actual promotions data from Firestore
class LoadPromotionData extends PromotionEvent {}

//Update the data in Cloud Firestore
class UpdatePromotion extends PromotionEvent {
  final String imageUrl;
  final String title;
  final String description;
  final String promocode;
  final String order;
  final String id;

  const UpdatePromotion(
      {required this.imageUrl,
      required this.title,
      required this.description,
      required this.promocode,
      required this.order,
      required this.id});

  @override
  List<Object> get props =>
      [imageUrl, title, description, promocode, order, id];
}

//Add a new promotion in Cloud Firestore
class AddPromotion extends PromotionEvent {
  final String imageUrl;
  final String title;
  final String description;
  final String promocode;
  final String order;

  const AddPromotion(
      {required this.imageUrl,
      required this.title,
      required this.description,
      required this.promocode,
      required this.order});

  @override
  List<Object> get props => [imageUrl, title, description, promocode, order];
}

//Delete certain promotion from Cloud Firestore
class DeletePromotion extends PromotionEvent {
  final String id;

  const DeletePromotion({required this.id});

  @override
  List<Object> get props => [id];
}
