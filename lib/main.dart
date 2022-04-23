import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letstalk/ui/screens/Matching/MatchingPage.dart';
import 'package:letstalk/utils/styles.dart';
import 'package:provider/provider.dart';

import 'core/internationalization/AppLanguage.dart';
import 'core/internationalization/AppLocalizationsDelegate.dart';
import 'core/navigation/Navigation.dart';
import 'core/providers/CardProvider.dart';
import 'core/providers/GoogleSignInProvider.dart';
import 'core/providers/MenuProvider.dart';
import 'ui/screens/Auth/LoginPage.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  // await dotenv.load(fileName: ".env");
  AppLanguage appLanguage = AppLanguage();
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;
  const MyApp({Key? key, required this.appLanguage}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MenuProvider(),
        child: ChangeNotifierProvider(
            create: (context) => GoogleSignInProvider(),
            child: ChangeNotifierProvider<CardProvider>(
                create: (context) => CardProvider(),
                child: ChangeNotifierProvider<AppLanguage>(
                    create: (_) => appLanguage,
                    child:
                        Consumer<AppLanguage>(builder: (context, model, child) {
                      return MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (context) => MenuProvider(),
                            ),
                          ],
                          child: ScreenUtilInit(
                            designSize: const Size(1920, 1080),
                            builder: (context) => GetMaterialApp(
                              scrollBehavior: const ScrollBehavior(),
                              debugShowCheckedModeBanner: false,
                              title: 'Let\'s Talk',
                              theme: ThemeData(
                                  primarySwatch: Colors.red,
                                  elevatedButtonTheme: ElevatedButtonThemeData(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 8,
                                          primary: Colors.white,
                                          shape: const CircleBorder(),
                                          minimumSize: const Size.square(80)))),
                              home: Stack(
                                children: const [
                                  LandingPageMobile(),
                                ],
                              ),
                              getPages: Navigation().getNavigationList(),
                              supportedLocales: const [
                                Locale('en', 'US'),
                                Locale('fr',
                                    'FR'), // we want french and english languages
                              ],
                              localizationsDelegates: [
                                AppLocalizationsDelegate(appLanguage.appLocal),
                                GlobalMaterialLocalizations.delegate,
                                GlobalWidgetsLocalizations.delegate,
                              ],
                            ),
                          ));
                    })))));
  }
}
