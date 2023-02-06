import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:pikapika_admin_panel/data/models/gift_goal.dart';

//Model for progress bar in Gift page
class GiftProgressBarModel extends Equatable {
  final GiftGoal gift1;
  final GiftGoal gift2;
  final GiftGoal gift3;
  final double progressBarHeight;
  final double circullarValue;

  const GiftProgressBarModel(
      {required this.gift1,
      required this.gift2,
      required this.gift3,
      required this.progressBarHeight,
      required this.circullarValue});

  @override
  List<Object?> get props =>
      [gift1, gift2, gift3, progressBarHeight, circullarValue];

  factory GiftProgressBarModel.fromMap(Map<String, dynamic> map) {
    return GiftProgressBarModel(
        gift1: GiftGoal.fromMap(map['gift1']),
        gift2: GiftGoal.fromMap(map['gift2']),
        gift3: GiftGoal.fromMap(map['gift3']),
        progressBarHeight: 0,
        circullarValue: 0);
  }

  factory GiftProgressBarModel.fromJson(String source) =>
      GiftProgressBarModel.fromMap(json.decode(source));

  GiftProgressBarModel copyWith({
    GiftGoal? gift1,
    GiftGoal? gift2,
    GiftGoal? gift3,
    double? progressBarHeight,
    double? circullarValue,
  }) {
    return GiftProgressBarModel(
      gift1: gift1 ?? this.gift1,
      gift2: gift2 ?? this.gift2,
      gift3: gift3 ?? this.gift3,
      progressBarHeight: progressBarHeight ?? this.progressBarHeight,
      circullarValue: circullarValue ?? this.circullarValue,
    );
  }
}
