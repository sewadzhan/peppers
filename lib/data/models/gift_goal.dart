import 'dart:convert';

import 'package:equatable/equatable.dart';

//Model for gift goal in progress bar
class GiftGoal extends Equatable {
  final String categoryID;
  final int goal;
  final String description;
  final String icon;
  final bool isSingleGift;
  //is active for adding gift to cart
  final bool isActive;
  final bool isEnabled;

  const GiftGoal(
      {required this.categoryID,
      required this.goal,
      required this.description,
      required this.icon,
      required this.isSingleGift,
      this.isActive = false,
      required this.isEnabled});

  @override
  List<Object?> get props =>
      [categoryID, goal, isSingleGift, isActive, isEnabled];

  factory GiftGoal.fromMap(Map<String, dynamic> map) {
    return GiftGoal(
      categoryID: map['categoryID'],
      goal: map['goal'],
      description: map['description'] ?? '',
      icon: map['icon'],
      isSingleGift: map['isSingleGift'] ?? false,
      isActive: false,
      isEnabled: map['isEnabled'] ?? true,
    );
  }

  factory GiftGoal.fromJson(String source) =>
      GiftGoal.fromMap(json.decode(source));

  GiftGoal copyWith({
    String? categoryID,
    int? goal,
    String? description,
    String? icon,
    bool? isSingleGift,
    bool? isActive,
    bool? isEnabled,
  }) {
    return GiftGoal(
      categoryID: categoryID ?? this.categoryID,
      goal: goal ?? this.goal,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isSingleGift: isSingleGift ?? this.isSingleGift,
      isActive: isActive ?? this.isActive,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
