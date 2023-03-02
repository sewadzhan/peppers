import 'package:equatable/equatable.dart';

//IIKO category model
class IikoCategory extends Equatable {
  final String id;
  final String name;

  const IikoCategory({
    required this.name,
    required this.id,
  });

  @override
  List<Object> get props => [id, name];

  factory IikoCategory.fromMap(Map<String, dynamic> map) {
    return IikoCategory(
      id: map['id'] ?? "",
      name: "${map['seoTitle']} (${map['name']})",
    );
  }

  @override
  String toString() {
    return "$name: $id";
  }
}
