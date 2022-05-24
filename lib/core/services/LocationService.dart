import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:letstalk/utils/common.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const String _kLocationServicesDisabledMessage =
    'Location services are disabled.';
const String _kPermissionDeniedMessage = 'Permission denied.';
const String _kPermissionDeniedForeverMessage = 'Permission denied forever.';
const String _kPermissionGrantedMessage = 'Permission granted.';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition(BuildContext ctx) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    customAlert(ctx, 'Error', 'Kindly enable location services in your device',
        AlertType.error, AnimationType.fromTop, Colors.purple);
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      customAlert(
          ctx,
          'Error',
          'Kindly enable location services in your device',
          AlertType.error,
          AnimationType.fromTop,
          Colors.purple);
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    customAlert(ctx, 'Error', 'Kindly enable location services in your device',
        AlertType.error, AnimationType.fromTop, Colors.purple);
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  // print('heree');
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10));
}

Future<List<dynamic>> convertCoordinatesToAddresses(
    double long, double lat) async {
  List results = [];
  return await placemarkFromCoordinates(lat, long);
}
