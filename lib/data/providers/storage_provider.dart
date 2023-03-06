import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageProvider {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(
      {required Uint8List bytes, required String fileName}) async {
    var result =
        await firebaseStorage.ref('promotions/$fileName').putData(bytes);

    return result.ref.getDownloadURL();
  }

  Future<ListResult> listFiles() async {
    ListResult results = await firebaseStorage.ref('promotions').listAll();
    return results;
  }

  Future<void> removeFile(String fileName) async {
    await firebaseStorage.ref('promotions/$fileName').delete();
  }
}
