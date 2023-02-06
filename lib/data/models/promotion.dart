import 'dart:convert';

import 'package:equatable/equatable.dart';

//Promotion model
class Promotion extends Equatable {
  final String imageUrl;
  final String title;
  final String description;
  final String promocode;
  final String id;

  const Promotion(
      {required this.id,
      required this.imageUrl,
      required this.title,
      required this.description,
      this.promocode = ''});

  @override
  List<Object?> get props => [imageUrl, title, description, promocode];

  factory Promotion.fromMap(Map<String, dynamic> map) {
    return Promotion(
      id: map['id'],
      imageUrl: map['imageUrl'],
      title: map['title'],
      description: map['description'],
      promocode: map['promocode'],
    );
  }

  factory Promotion.fromJson(String source) =>
      Promotion.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "imageUrl": imageUrl,
      "title": title,
      "description": description,
      "promocode": promocode
    };
  }
}
