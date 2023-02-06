part of 'promotion_bloc.dart';

abstract class PromotionEvent extends Equatable {
  const PromotionEvent();

  @override
  List<Object> get props => [];
}

//Load actual promotions data from Firestore
class LoadPromotionData extends PromotionEvent {}

//Update the data in Cloud Firestore
class UpdatePromotionData extends PromotionEvent {
  final Promotion promotion;

  const UpdatePromotionData(this.promotion);

  @override
  List<Object> get props => [promotion];
}

//Add a new promotion in Cloud Firestore
class AddPromotion extends PromotionEvent {
  final Promotion promotion;

  const AddPromotion(this.promotion);

  @override
  List<Object> get props => [promotion];
}
