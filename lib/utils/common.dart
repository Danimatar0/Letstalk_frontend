import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../core/internationalization/AppLanguage.dart';
import '../core/internationalization/AppLocalizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final toast = FToast();

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

showToast(
  BuildContext context,
  message,
  duration,
  color,
  double pTop,
  double pLeft,
  EdgeInsetsGeometry geometry, {
  bool translateMessage = true,
  double? textWidth,
  void Function()? onTap, // TODO **********************************************
  bool? withTrailingButton = false,
}) {
  toast.init(context);
  // if (!toastVisible) return;
  var applang = Provider.of<AppLanguage>(context, listen: false);
  Widget buildToast = Container(
    padding: geometry,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SizedBox(
        //   width: .05.sw,
        // ),
        textWidth != null
            ? Container(
                width: textWidth,
                child: Text(
                  translateMessage
                      ? translate(applang, context, message)
                      : message,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Flexible(
                child: Text(
                  translateMessage
                      ? translate(applang, context, message)
                      : message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
        withTrailingButton != null
            ? withTrailingButton
                ? IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      toast.removeCustomToast();
                    },
                  )
                : Container()
            : Container(),
        // CloseButton(
        //   color: Colors.white,
        // )
      ],
    ),
  );
  // Custom Toast Position

  toast.showToast(
      child: buildToast,
      toastDuration: duration,
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: MouseRegion(
            cursor:
                onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
            child: GestureDetector(
              child: child,
              onTap: () {
                if (onTap != null) {
                  onTap();
                  toast.removeCustomToast();
                }
              },
            ),
          ),
          top: pTop,
          left: pLeft,
        );
      });
}

customAlert(context, title, desc, type, animationType, textColor) {
  Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  var alertStyle = AlertStyle(
      animationType: animationType,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: const Color(0xffBEBEBE),
        ),
      ),
      titleStyle: TextStyle(
        color: textColor,
      ),
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.topCenter);
  Alert(
    context: context,
    type: type,
    style: alertStyle,
    title: title,
    desc: desc,
    alertAnimation: fadeAlertAnimation,
  ).show();

  //this method is called to open dialog on iconPress
  openDialog(Color barrierColor, dynamic tBuilder, dynamic pBuilder,
      dynamic tDuration) {
    showGeneralDialog(
        context: context,
        barrierColor: barrierColor,
        transitionBuilder: tBuilder,
        pageBuilder: pBuilder,
        transitionDuration: tDuration,
        barrierDismissible: true);
  }
}

String generateRandomString(int length) {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
