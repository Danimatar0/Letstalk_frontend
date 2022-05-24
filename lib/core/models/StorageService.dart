import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final storage.FirebaseStorage _storage = storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await _storage.ref('usersImages/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print('FIREBASE ERROR: $e');
    }
  }
}
