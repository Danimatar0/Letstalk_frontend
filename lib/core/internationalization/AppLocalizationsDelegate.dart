import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'AppLocalizations.dart';

// Flutter localization uses Delegates for initialization, which is why we need this class
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  final Locale locale;
  const AppLocalizationsDelegate(this.locale);

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'fr'].contains(this.locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations(this.locale);
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
