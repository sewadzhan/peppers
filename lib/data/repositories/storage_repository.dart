import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:pikapika_admin_panel/data/models/storage_files.dart';
import 'package:pikapika_admin_panel/data/providers/storage_provider.dart';

class StorageRepository {
  final StorageProvider storageProvider;

  StorageRepository(this.storageProvider);

  Future<String> uploadFile(
      {required Uint8List bytes, required String fileName}) async {
    return await storageProvider.uploadFile(bytes: bytes, fileName: fileName);
  }

  Future<List<StorageFile>> getStorageFiles() async {
    ListResult listResult = await storageProvider.listFiles();
    List<StorageFile> storageFiles = [];

    for (var e in listResult.items) {
      var url = await e.getDownloadURL();
      storageFiles.add(StorageFile(name: e.name, url: url));
    }

    return storageFiles;
  }

  Future<void> removeFile(String fileName) async {
    await storageProvider.removeFile(fileName);
  }
}
