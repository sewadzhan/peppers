import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pikapika_admin_panel/data/models/storage_files.dart';
import 'package:pikapika_admin_panel/data/repositories/storage_repository.dart';

part 'storage_event.dart';
part 'storage_state.dart';

//Bloc for Firebase storage
class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final StorageRepository storageRepository;

  StorageBloc(this.storageRepository) : super(StorageInitial()) {
    on<LoadStorageFiles>(loadStorageFilesToState);
    on<UploadStorageFile>(uploadStorageFileToState);
    on<DeleteStorageFile>(deleteStorageFileToState);
  }

  //Load all Firebase Storage files (from promotions folder)
  Future<void> loadStorageFilesToState(
      LoadStorageFiles event, Emitter<StorageState> emit) async {
    if (state is StorageInitial) {
      try {
        emit(StorageLoading());

        List<StorageFile> storageFiles =
            await storageRepository.getStorageFiles();

        emit(StorageLoaded(storageFiles));
      } catch (e) {
        emit(StorageErrorState(e.toString()));
      }
    }
  }

  //Upload some file to Firebase Storage
  Future<void> uploadStorageFileToState(
      UploadStorageFile event, Emitter<StorageState> emit) async {
    if (state is StorageLoaded) {
      try {
        var storageFiles = (state as StorageLoaded).storageFiles;
        emit(StorageUploading());

        String url = await storageRepository.uploadFile(
            fileName: event.fileName, bytes: event.bytes);

        storageFiles.add(StorageFile(name: event.fileName, url: url));
        emit(StorageSuccessUploaded());
        emit(StorageLoaded(storageFiles));
      } catch (e) {
        emit(StorageErrorState(e.toString()));
      }
    }
  }

  //Delete image from Firebase Storage
  Future<void> deleteStorageFileToState(
      DeleteStorageFile event, Emitter<StorageState> emit) async {
    if (state is StorageLoaded) {
      try {
        var storageFiles = (state as StorageLoaded).storageFiles;
        emit(StorageDeleting());

        await storageRepository.removeFile(event.fileName);

        //Removing the image
        int imageItemIndex = storageFiles.indexWhere(
          (item) => item.name == event.fileName,
        );
        List<StorageFile> finalList = List.from(storageFiles)
          ..removeAt(imageItemIndex);

        emit(StorageFileSuccessDeleted());
        emit(StorageLoaded(finalList));
      } catch (e) {
        emit(StorageErrorState(e.toString()));
      }
    }
  }
}
