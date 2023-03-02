part of 'gift_bloc.dart';

abstract class GiftEvent extends Equatable {
  const GiftEvent();

  @override
  List<Object> get props => [];
}

//Load actual Gifts data from Firestore
class LoadGiftData extends GiftEvent {}

//Update the data in Cloud Firestore
class UpdateGiftData extends GiftEvent {
  final String gift1CategoryID;
  final String gift1Description;
  final String gift1Goal;
  final String gift1Icon;

  final String gift2CategoryID;
  final String gift2Description;
  final String gift2Goal;
  final String gift2Icon;

  final String gift3CategoryID;
  final String gift3Description;
  final String gift3Goal;
  final String gift3Icon;

  const UpdateGiftData(
      {required this.gift1CategoryID,
      required this.gift1Description,
      required this.gift1Goal,
      required this.gift1Icon,
      required this.gift2CategoryID,
      required this.gift2Description,
      required this.gift2Goal,
      required this.gift2Icon,
      required this.gift3CategoryID,
      required this.gift3Description,
      required this.gift3Goal,
      required this.gift3Icon});
  @override
  List<Object> get props => [
        gift1CategoryID,
        gift1Description,
        gift1Goal,
        gift1Icon,
        gift2CategoryID,
        gift2Description,
        gift2Goal,
        gift2Icon,
        gift3CategoryID,
        gift3Description,
        gift3Goal,
        gift3Icon
      ];
}

//Update the isEnabled field in Cloud Firestore
class GiftIsEnabledChanged extends GiftEvent {
  final bool value;
  final String giftType;

  const GiftIsEnabledChanged(this.value, this.giftType);

  @override
  List<Object> get props => [value, giftType];
}

//Update the isSingleGift field in Cloud Firestore
class GiftIsSingleGiftChanged extends GiftEvent {
  final bool value;
  final String giftType;

  const GiftIsSingleGiftChanged(this.value, this.giftType);

  @override
  List<Object> get props => [value, giftType];
}
