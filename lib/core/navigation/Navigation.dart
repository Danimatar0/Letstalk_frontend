import 'package:get/get.dart';
import 'package:letstalk/ui/screens/Auth/RegisterPage.dart';
import 'package:letstalk/ui/screens/Matching/Chatting.dart';
import 'package:letstalk/ui/screens/Matching/MatchingPage.dart';

import '../../ui/screens/Auth/LoginPage.dart';
import '../../ui/screens/Auth/Profile.dart';
import '../../ui/screens/Home/HomePage.dart';

class Navigation {
  // Screen Routes List
  List<GetPage<dynamic>> routes = [
    // Main route and Home Page
    GetPage(name: '/', page: () => HomePage()),
    GetPage(name: '/login', page: () => LandingPageMobile()),
    GetPage(name: '/register', page: () => Register()),
    GetPage(name: '/match', page: () => MatchingScreen()),
    GetPage(name: '/chats', page: () => ChatPage()),
    GetPage(name: '/listchats', page: () => ChatPage()),
    GetPage(name: '/profile', page: () => UserProfile()),
  ];

  List<GetPage<dynamic>> getNavigationList() {
    return this.routes;
  }
}
