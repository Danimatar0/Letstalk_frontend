import 'package:flutter/material.dart';
import 'package:letstalk/core/constants/IP.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> getCuisines() async {
  final String url = getIP() + 'Preference/all';
  print('calling $url');
  final dynamic response =
      await http.get(Uri.parse(url), headers: <String, String>{
    "Content-Encoding": "gzip",
    "content-type": "application/json; charset=UTF-8",
  }).catchError((error) {
    debugPrint("------------- ERROR -------------");
    debugPrint(error.toString());
  });
  print(jsonDecode(response.body));
  return jsonDecode(response.body);
}

Future<dynamic> getUsersByPreferenceId(String email, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double range = prefs.getDouble("range") ?? 80.0;
  final String url =
      getIP() + 'Preference/getUsersHavingSamePreference/$email/$range';
  print('calling $url');
  final dynamic response =
      await http.get(Uri.parse(url), headers: <String, String>{
    "Content-Encoding": "gzip",
    "content-type": "application/json; charset=UTF-8",
  }).catchError((error) {
    debugPrint("------------- ERROR -------------");
    debugPrint(error.toString());
  });
  List data = jsonDecode(response.body);
  // print('RESPONSEEE $data');
  return data;
}

Future<dynamic> match(dynamic matchDTO, String token) async {
  final String url = getIP() + 'Match/matching';
  final dynamic response = await http
      .post(Uri.parse(url),
          headers: <String, String>{
            "Content-Encoding": "gzip",
            "content-type": "application/json; charset=UTF-8",
          },
          body: jsonEncode(matchDTO))
      .catchError((error) {
    debugPrint("------------- ERROR -------------");
    debugPrint(error.toString());
  });
  var data = jsonDecode(response.body);
  print('RESPONSEEEE $data');
  return data;
  // return data;
}

Future<dynamic> getUserPreference(int userId) async {
  final String url = getIP() + 'Preference/getPreferences/$userId';
  final dynamic response =
      await http.get(Uri.parse(url), headers: <String, String>{
    "Content-Encoding": "gzip",
    "content-type": "application/json; charset=UTF-8",
  }).catchError((error) {
    debugPrint("------------- ERROR -------------");
    debugPrint(error.toString());
  });
  List data = jsonDecode(response.body);
  print('RESPONSEEE $data');
  return data;
}

Future<bool> checkIfMatch(int userId, String fId) async {
  final String url = getIP() + "Match/checkifMatch/$userId/$fId";
  final dynamic response =
      await http.get(Uri.parse(url), headers: <String, String>{
    "Content-Encoding": "gzip",
    "content-type": "application/json; charset=UTF-8",
  }).catchError((error) {
    debugPrint("------------- ERROR -------------");
    debugPrint(error.toString());
  });
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    // print('dataaa $data');
    return data['isMatch'];
  } else {
    print('status code 404');
    return false;
  }
}
