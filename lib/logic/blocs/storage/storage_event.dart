part of 'storage_bloc.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();

  @override
  List<Object> get props => [];
}

class LoadStorageFiles extends StorageEvent {}

class UploadStorageFile extends StorageEvent {
  final Uint8List bytes;
  final String fileName;

  const UploadStorageFile(this.bytes, this.fileName);

  @override
  List<Object> get props => [bytes, fileName];
}

class DeleteStorageFile extends StorageEvent {
  final String fileName;

  const DeleteStorageFile(this.fileName);

  @override
  List<Object> get props => [fileName];
}
