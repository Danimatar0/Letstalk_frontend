import 'package:flutter/material.dart';
import 'package:letstalk/core/constants/IP.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> getCuisines() async {
  final String url = getIP() + 'api/Preference/all';
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

Future<void> fetchPosts() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
      .catchError((err) {
    debugPrint("------------- ERROR -------------");
    debugPrint(err.toString());
  });
  print(jsonDecode(response.body));
}
