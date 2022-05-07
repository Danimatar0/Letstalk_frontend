import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:letstalk/core/services/AuthService.dart';
import '../../utils/common.dart';
import '../constants/constants.dart';
import '../controllers/LoginController.dart';
import '../models/LoggedUser.dart';
import '../models/models.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;
  final _authController = Get.put(AuthController());

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.prefs,
    required this.firebaseFirestore,
  });

  String? getUserFirebaseId() {
    return prefs.getString(FirestoreConstants.id);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn &&
        prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  void setSharedPreferences(dynamic user) async {
    print('setting prefs for ${user['firebaseId']}');
    await prefs.setString(FirestoreConstants.id, user['firebaseId']);
    await prefs.setString(FirestoreConstants.nickname, user['firstname'] ?? "");
    await prefs.setString(FirestoreConstants.photoUrl, user['image'] ?? "");
    await prefs.setString(FirestoreConstants.aboutMe, user['aboutMe'] ?? '');
  }

  void initializeUserFirebase(dynamic user) async {
    print('fetching documents for user ${user['firebaseId']}');
    final QuerySnapshot result = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.id, isEqualTo: user['firebaseId'])
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.isEmpty) {
      // Writing data to server because here is a new user
      print('writing data to server');
      SetOptions options = SetOptions(merge: true);
      // print(user['firstname']);
      String firstname = user['firstname'] ?? '';
      String lastname = user['lastname'] ?? '';
      String nickname = '$firstname $lastname';
      firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(user['firebaseId'])
          .set({
        FirestoreConstants.nickname: nickname,
        FirestoreConstants.photoUrl: user['image'],
        FirestoreConstants.id: user['firebaseId'],
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        FirestoreConstants.chattingWith: null
      }, options).then((value) => print('user added to firestore'));
      // print('heree');
      // Write data to local storage
      // User? currentUser = U;
      setSharedPreferences(user);
    } else {
      // Already sign up, just get data from firestore
      print('already sign up');
      documents.forEach((d) {
        print('document -> ${d.data()}');
      });
      String firstname = user['firstname'] ?? '';
      String lastname = user['lastname'] ?? '';
      String nickname = '$firstname $lastname';
      firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(user['firebaseId'])
          .update({
        FirestoreConstants.nickname: nickname,
        FirestoreConstants.photoUrl: user['image'],
        FirestoreConstants.id: user['firebaseId'],
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        FirestoreConstants.chattingWith: null
      }).then((value) => print('user updated in firestore'));
      DocumentSnapshot documentSnapshot = documents[0];
      UserChat userChat = UserChat.fromDocument(documentSnapshot);
      var userChatObj = {
        'id': userChat.id,
        'firstname': firstname,
        'lastname': lastname,
        'image': userChat.photoUrl,
        'aboutMe': userChat.aboutMe,
        'firebaseId': user['firebaseId'],
      };
      print('after userobj');
      // Write data to local
      setSharedPreferences(userChatObj);
    }
  }

  Future<bool> handleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();
    // print('1');
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    // print('2');

    if (googleUser != null) {
      // print('inn');
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      // print(googleAuth.idToken.toString());
      // print(googleAuth.accessToken);
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      User? firebaseUser =
          (await firebaseAuth.signInWithCredential(credential)).user;
      // print(firebaseUser);
      if (firebaseUser != null) {
        List<String> fullName = firebaseUser.displayName.toString().split(" ");
        var checkUser = await checkUserExistsLocally(
            firebaseUser.email!, googleAuth.accessToken!);
        if (checkUser.status == 404) {
          var userObj = {
            'Firstname': fullName[0],
            'Lastname': fullName[1],
            'Email': firebaseUser.email!,
            'Phone': firebaseUser.phoneNumber,
            'DOB': '',
            'Password': generateRandomString(28),
            'Gender': '',
            'FirebaseId': firebaseUser.uid,
            'Preference': Null
          };
          register(userObj);
        }

        LoggedUser loggedUser = LoggedUser(
            id: -1,
            username: firebaseUser.email!,
            firstname: fullName[0],
            lastname: fullName[1],
            phone: firebaseUser.phoneNumber,
            imgUrl: firebaseUser.photoURL!,
            FirebaseId: firebaseUser.uid);
        _authController.setUser(loggedUser);
        prefs.setBool('isAuthenticated', true);
        prefs.setString('username', firebaseUser.email!);
        // prefs.setString("FirebaseId", firebaseUser.uid);
        _authController.isLoading.toggle();
        dynamic user = {
          'id': -1,
          'firstname': loggedUser.firstname,
          'lastname': loggedUser.lastname,
          'image': loggedUser.imgUrl,
          'firebaseId': firebaseUser.uid,
        };
        initializeUserFirebase(user);
        var localUser = await checkUserExistsLocally(
            prefs.getString('username')!, googleAuth.accessToken!);
        print(localUser);
        // final QuerySnapshot result = await firebaseFirestore
        //     .collection(FirestoreConstants.pathUserCollection)
        //     .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
        //     .get();
        // // print('results -> $result');
        // final List<DocumentSnapshot> documents = result.docs;
        // if (documents.isEmpty) {
        //   // Writing data to server because here is a new user
        //   firebaseFirestore
        //       .collection(FirestoreConstants.pathUserCollection)
        //       .doc(firebaseUser.uid)
        //       .set({
        //     FirestoreConstants.nickname: firebaseUser.displayName,
        //     FirestoreConstants.photoUrl: firebaseUser.photoURL,
        //     FirestoreConstants.id: firebaseUser.uid,
        //     'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        //     FirestoreConstants.chattingWith: null
        //   });

        //   // Write data to local storage
        //   User? currentUser = firebaseUser;
        //   await prefs.setString(FirestoreConstants.id, currentUser.uid);
        //   await prefs.setString(
        //       FirestoreConstants.nickname, currentUser.displayName ?? "");
        //   await prefs.setString(
        //       FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
        // } else {
        //   // Already sign up, just get data from firestore
        //   DocumentSnapshot documentSnapshot = documents[0];
        //   UserChat userChat = UserChat.fromDocument(documentSnapshot);
        //   // Write data to local
        //   await prefs.setString(FirestoreConstants.id, userChat.id);
        //   await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
        //   await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
        //   await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
        // }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      print('not signed in');
      return false;
    }
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    _authController.isLoading.toggle();
    Get.offAndToNamed('login');
  }
}
