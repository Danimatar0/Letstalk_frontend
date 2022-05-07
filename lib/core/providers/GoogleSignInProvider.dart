import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/common.dart';
import '../controllers/LoginController.dart';
import '../models/LoggedUser.dart';
import '../services/AuthService.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn(scopes: [
    "https://www.googleapis.com/auth/contacts.readonly",
  ]);
  late GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  final _authController = Get.put(AuthController());
  late SharedPreferences prefs;

  Future<List<dynamic>> getUserContacts() async {
    const HOST = "https://people.googleapis.com";
    const ENDPOINT =
        "/v1/people/me/connections?personFields=names,emailAddresses,phoneNumbers";
    final url = HOST + ENDPOINT;
    final headers = await user.authHeaders;
    dynamic response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        "Authorization": headers['Authorization']!,
        "Content-Encoding": "gzip",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).catchError((error) {
      debugPrint("------------- ERROR ----------");
      debugPrint(error.toString());
    });
    dynamic data = jsonDecode(response.body);
    List<dynamic> connections = data['connections'];
    print('connections => $connections');
    return connections;
  }

  Future<bool> googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    prefs = await SharedPreferences.getInstance();
    _authController.isLoading.toggle();
    if (googleUser == null) return false;
    _user = googleUser;
    final googleAuth = await _user.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential authCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (authCred.user != null) {
      if (authCred.user!.emailVerified) {
        print('successfully logged in with user ${authCred.user}');
        List<String> fullname =
            authCred.user!.displayName.toString().split(" ");
        var user = await checkUserExistsLocally(
            authCred.user!.email!, googleAuth.accessToken!);
        if (user.status == 404) {
          var userObj = {
            'Firstname': fullname[0],
            'Lastname': fullname[1],
            'Email': authCred.user!.email!,
            'Phone': authCred.user!.phoneNumber,
            'DOB': '',
            'Password': generateRandomString(28),
            'Gender': '',
            'FirebaseId': authCred.user!.uid,
            'Preference': Null
          };
          register(userObj);
        }

        LoggedUser loggedUser = LoggedUser(
          id: -1,
          username: authCred.user!.email!,
          firstname: fullname[0],
          lastname: fullname[1],
          imgUrl: authCred.user!.photoURL!,
          preferences: [],
          FirebaseId: authCred.user!.uid,
        );
        _authController.setUser(loggedUser);
        prefs.setBool('isAuthenticated', true);
        prefs.setString('username', authCred.user!.email!);
        _authController.isLoading.toggle();
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> googleLogout() async {
    prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    prefs.setBool('isAuthenticated', false);
    prefs.setString('username', '');
    Get.offAndToNamed('/login');
  }
}
