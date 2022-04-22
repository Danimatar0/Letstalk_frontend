import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/internationalization/AppLocalizations.dart';

String getCurrentDate() {
  final DateTime now = DateTime.now();
  DateTime date = DateTime(now.year, now.month, now.day);
  return date.toString();
}

/// Get Current Device
bool isAndroid() {
  return GetPlatform.isAndroid;
}

bool isIOS() {
  return GetPlatform.isIOS;
}

bool isWeb() {
  return GetPlatform.isWeb;
}

bool isWindows() {
  return GetPlatform.isWindows;
}

bool isMacOs() {
  return GetPlatform.isMacOS;
}

bool isLinux() {
  return GetPlatform.isLinux;
}

///Get device orientation
Orientation getOrientation(BuildContext context) {
  return context.orientation;
}

///Check if device is on landscape mode
bool isLandscape(BuildContext context) {
  return context.isLandscape;
}

///Check if device is on portrait mode
bool isPortrait(BuildContext context) {
  return context.isPortrait;
}

// This isMobile, isTablet, isDesktop helep us later
bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;

bool isTablet(BuildContext context) =>
    MediaQuery.of(context).size.width < 1100 &&
    MediaQuery.of(context).size.width >= 600;

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 1100;

String translate(var appLanguage, BuildContext context, String key) {
  return AppLocalizations.of(context)!
              .translate(key, appLanguage.appLocal)
              .toString() ==
          'null'
      ? key
      : AppLocalizations.of(context)!
          .translate(key, appLanguage.appLocal)
          .toString();
}

dynamic getValueFromPath(dynamic object, String path) {
  if (path.split('.').length <= 1) {
    return object[path.toString()];
  }
  dynamic firstField = path.split('.')[0];
  dynamic newPathArr = path.split('.');
  newPathArr.removeAt(0);
  String newPath =
      newPathArr.length > 1 ? newPathArr.join('.') : newPathArr.join('');
  dynamic newObject = object[firstField.toString()];

  return getValueFromPath(newObject, newPath);
}
