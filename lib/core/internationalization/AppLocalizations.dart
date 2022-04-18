import 'package:flutter/cupertino.dart';
import "Languages.dart";

// class that fetches appropriate values based on language and returns the values
class AppLocalizations {
  late Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  late Map<dynamic, dynamic> _localizedStrings;

  // This method will be called from every widget which needs a localized text
  String translate(String key, Locale locale) {
    this.locale = locale;
    // get appropriate values based on language
    setLocalizedString();

    return _localizedStrings[key].toString();
  }

  void setLocalizedString() {
    dynamic jsonString = Languages.fr;

    if (locale.languageCode == 'en') {
      jsonString = Languages.en;
    }

    _localizedStrings = jsonString.map((key, value) {
      return MapEntry(key.toString(), value.toString());
    });
  }
}
