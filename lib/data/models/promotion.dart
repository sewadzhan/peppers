import 'package:equatable/equatable.dart';

//Promotion model
class Promotion extends Equatable {
  final String imageUrl;
  final String title;
  final String description;
  final String promocode;
  final String id;
  final int order;

  const Promotion(
      {required this.id,
      required this.imageUrl,
      required this.title,
      required this.description,
      required this.order,
      this.promocode = ''});

  @override
  List<Object?> get props => [imageUrl, title, description, promocode, order];

  factory Promotion.fromMap(Map<String, dynamic> map, String id) {
    return Promotion(
      id: id,
      imageUrl: map['imageUrl'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      promocode: map['promocode'] ?? "",
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "imageUrl": imageUrl,
      "title": title,
      "description": description,
      "promocode": promocode,
      "order": order
    };
  }

  Promotion copyWith({
    String? imageUrl,
    String? title,
    String? description,
    String? promocode,
    String? id,
    int? order,
  }) {
    return Promotion(
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        order: order ?? this.order);
  }
}
