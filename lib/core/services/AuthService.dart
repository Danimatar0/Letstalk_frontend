import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:letstalk/core/constants/IP.dart';
import 'package:http/http.dart' as http;
import 'package:letstalk/utils/common.dart';
import 'dart:convert';

import '../models/LoggedUser.dart';

Future<dynamic> register(dynamic user) async {
  debugPrint("calling register");
  var url = getIP() + 'Auth/register';
  final response = await http
      .post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'accept': 'application/json',
    },
    body: json.encode(user),
  )
      .catchError((error) {
    debugPrint('------------- ERROR -------------');
    debugPrint(error.toString());
  });
  var data = jsonDecode(response.body);
  // print('RESPPP $data');
  return data;
}

Future<dynamic> login(dynamic user) async {
  LoggedUser loggedUser;
  final url = getIP() + "Auth/login";
  final response = await http
      .post(
    Uri.parse(url),
    headers: <String, String>{
      "Content-Encoding": "gzip",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user),
  )
      .catchError((error) {
    debugPrint("------------- ERROR ----------");
    debugPrint(error.toString());
  });
  var data = {};
  if (response.body.isNotEmpty) {
    data = jsonDecode(response.body);
  } else {
    print('response body is empty');
  }
  return data;
}

Future<dynamic> checkUserExistsLocally(String email, String token) async {
  final url = getIP() + "Auth/checkUserExists/${email}";
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      "Content-Encoding": "gzip",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  ).catchError((error) {
    debugPrint("------------- ERROR ----------");
    debugPrint(error.toString());
  });
  if (response.statusCode == 400 || response.statusCode == 404) return null;
  return jsonDecode(response.body);
}

Future<dynamic> updateUser(dynamic user, String token) async {
  final url = getIP() + "Auth/update";
  final response = await http
      .post(
    Uri.parse(url),
    headers: <String, String>{
      "Content-Encoding": "gzip",
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(user),
  )
      .catchError((error) {
    debugPrint("------------- ERROR ----------");
    debugPrint(error.toString());
  });
  if (response.body.isNotEmpty) {
    return jsonDecode(response.body);
  } else {
    print('response body is empty');
    return null;
  }
}

Future<void> changePassword(int id, String password) async {
  final url = getIP() + "Auth/changePassword/$id";
  final response = await http
      .post(
    Uri.parse(url),
    headers: <String, String>{
      "Content-Encoding": "gzip",
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: password,
  )
      .catchError((error) {
    debugPrint("------------- ERROR ----------");
    debugPrint(error.toString());
  });
  if (response.statusCode == 200) {
    Fluttertoast.showToast(msg: 'Password Successfully Changed');
  } else {
    Fluttertoast.showToast(msg: 'Password Change Failed');
  }
}
