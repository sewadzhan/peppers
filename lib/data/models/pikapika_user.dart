import 'dart:convert';

import 'package:equatable/equatable.dart';

//Model of Pikapika user
class PikapikaUser extends Equatable {
  final String phoneNumber;
  final String name;
  final String email;
  final String birthday;
  final int cashback;
  final int? individualCashbackPercent;

  const PikapikaUser(
      {required this.phoneNumber,
      required this.name,
      required this.email,
      required this.birthday,
      this.cashback = 0,
      this.individualCashbackPercent});

  @override
  List<Object?> get props =>
      [phoneNumber, name, email, birthday, cashback, individualCashbackPercent];

  @override
  String toString() {
    return "Pikapika user: $phoneNumber name: $name  email: $email birthday: $birthday cashback: $cashback individualCashbackPercent: $individualCashbackPercent";
  }

  factory PikapikaUser.fromMap(Map<String, dynamic> map) {
    return PikapikaUser(
        phoneNumber: map["phoneNumber"] ?? "",
        name: map["name"] ?? "",
        email: map["email"] ?? "",
        birthday: map["birthday"] ?? "",
        cashback: map["cashback"] ?? 0,
        individualCashbackPercent: map["individualCashbackPercent"]);
  }

  factory PikapikaUser.fromJson(String source) =>
      PikapikaUser.fromMap(json.decode(source));

  PikapikaUser copyWith(
      {String? phoneNumber,
      String? name,
      String? email,
      String? birthday,
      int? cashback,
      int? individualCashbackPercent}) {
    return PikapikaUser(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        email: email ?? this.email,
        birthday: birthday ?? this.birthday,
        cashback: cashback ?? this.cashback,
        individualCashbackPercent: individualCashbackPercent);
  }
}
