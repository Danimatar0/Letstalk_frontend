import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:letstalk/core/constants/constants.dart';

import '../constants/FirestoreConstants.dart';

class HomeProvider extends ChangeNotifier {
  final FirebaseFirestore firebaseFirestore;

  HomeProvider({required this.firebaseFirestore});

  Future<void> updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getStreamFireStore(
      String pathCollection, int limit, String? textSearch,
      {String iduserFrom = '',
      String iduserTo = '',
      bool alreadyChatExists = false}) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(pathCollection)
          .limit(limit)
          .where(FirestoreConstants.idFrom,
              isEqualTo: iduserFrom) //fetch chats  where the user is the sender
          .where(FirestoreConstants.idTo,
              isNotEqualTo:
                  iduserFrom) // fetch chats where the user is not the receiver
          .where(FirestoreConstants.nickname,
              isEqualTo:
                  textSearch) //fetch chats where chat user nickname is equal to textSearch
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(pathCollection)
          .limit(limit)
          // .where(FirestoreConstants.idFrom,
          //     isEqualTo: iduserFrom) //fetch chats  where the user is the sender
          // .where(FirestoreConstants.idTo,
          //     isNotEqualTo:
          //         iduserFrom) // fetch chats where the user is not the receiver
          .snapshots();
    }
  }
}
