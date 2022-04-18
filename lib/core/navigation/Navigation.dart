import 'package:get/get.dart';
import 'package:letstalk/ui/screens/Matching/MatchingPage.dart';

import '../../ui/screens/Home/HomePage.dart';

class Navigation {
  // Screen Routes List
  List<GetPage<dynamic>> routes = [
    // Main route and Home Page
    GetPage(name: '/', page: () => Home()),
    GetPage(name: '/match', page: () => MatchingScreen()),
  ];

  List<GetPage<dynamic>> getNavigationList() {
    return this.routes;
  }
}
