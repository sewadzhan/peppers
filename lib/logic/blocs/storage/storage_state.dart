part of 'storage_bloc.dart';

abstract class StorageState extends Equatable {
  const StorageState();

  @override
  List<Object> get props => [];
}

class StorageInitial extends StorageState {}

class StorageLoading extends StorageState {}

class StorageLoaded extends StorageState {
  final List<StorageFile> storageFiles;

  const StorageLoaded(this.storageFiles);

  @override
  List<Object> get props => [storageFiles];
}

class StorageUploading extends StorageState {}

class StorageSuccessUploaded extends StorageState {}

class StorageDeleting extends StorageState {}

class StorageFileSuccessDeleted extends StorageState {}

class StorageErrorState extends StorageState {
  final String message;

  const StorageErrorState(this.message);

  @override
  List<Object> get props => [message];
}
