import 'package:flutter/material.dart';
import 'package:letstalk/core/constants/IP.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/LoggedUser.dart';

Future<dynamic> register(dynamic user) async {
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
  return json.decode(response.body);
}

Future<dynamic> login(dynamic user) async {
  LoggedUser loggedUser;
  final url = getIP() + "login";
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
  dynamic data = jsonDecode(response.body);

  return data;
}
