import 'package:flutter/material.dart';
import 'package:letstalk/core/constants/IP.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  var data = jsonDecode(response.body);
  // print('RESPONSEEE $data');
  return jsonDecode(response.body);
}

Future<dynamic> getUsersByPreferenceId(int id, String token) async {
  final String url = getIP() + 'Preference/getUsers/$id';
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

Future<dynamic> match(dynamic matchDTO, String token) async {
  final String url = getIP() + 'Match/matching';
  final dynamic response =
      await http.post(Uri.parse(url), headers: <String, String>{
    "Content-Encoding": "gzip",
    "content-type": "application/json; charset=UTF-8",
  }).catchError((error) {
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
