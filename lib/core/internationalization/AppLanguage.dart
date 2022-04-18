import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class that saves the chosen language in SharedPreferences
class AppLanguage extends ChangeNotifier {
  late Locale _appLocale;

  Locale get appLocal => _appLocale;

  // fetch saved language from SharedPreferences (from phone)
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code').toString());
    return Null;
  }

// change lanugage then save and notify listeners
  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();

    if (_appLocale == type) {
      return;
    }
    if (type == Locale("fr")) {
      _appLocale = Locale("fr");
      await prefs.setString('language_code', 'fr');
      await prefs.setString('countryCode', 'FR');
    } else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }
}
