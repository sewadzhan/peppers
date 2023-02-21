import 'package:equatable/equatable.dart';

//IIKO organisation model
class IikoOrganization extends Equatable {
  final String id;
  final String name;

  const IikoOrganization({
    required this.name,
    required this.id,
  });

  @override
  List<Object> get props => [id, name];

  factory IikoOrganization.fromMap(Map<String, dynamic> map) {
    return IikoOrganization(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
    );
  }
}
