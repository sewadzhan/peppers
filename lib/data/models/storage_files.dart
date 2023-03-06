import 'package:equatable/equatable.dart';

//Model for files from Firebase Storage
class StorageFile extends Equatable {
  final String name;
  final String url;

  const StorageFile({required this.name, required this.url});

  @override
  List<Object?> get props => [name, url];
}
