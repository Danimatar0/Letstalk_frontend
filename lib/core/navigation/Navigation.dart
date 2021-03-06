import 'package:get/get.dart';
import 'package:letstalk/ui/screens/Auth/RegisterPage.dart';
import 'package:letstalk/ui/screens/Chat/ChatsScreen.dart';
import 'package:letstalk/ui/screens/Matching/Chatting.dart';
import 'package:letstalk/ui/screens/Matching/MatchingPage.dart';
import 'package:letstalk/ui/screens/Settings/Settings.dart';

import '../../ui/screens/Auth/LoginPage.dart';
import '../../ui/screens/Auth/Profile.dart';

class Navigation {
  // Screen Routes List
  List<GetPage<dynamic>> routes = [
    // Main route and Home Page
    // GetPage(name: '/home', page: () => ListingChatsPage()),
    GetPage(name: '/login', page: () => LandingPageMobile()),
    GetPage(name: '/register', page: () => Register()),
    GetPage(name: '/match', page: () => MatchingScreen()),
    GetPage(name: '/chats', page: () => ChatPage()),
    GetPage(name: '/listchats', page: () => ListingChatsPage()),
    GetPage(name: '/profile', page: () => ProfilePage()),
    GetPage(name: '/settings', page: () => SettingsPage()),
  ];

  List<GetPage<dynamic>> getNavigationList() {
    return this.routes;
  }
}
