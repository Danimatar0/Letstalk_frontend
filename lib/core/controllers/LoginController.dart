import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../models/LoggedUser.dart';

class AuthController extends GetxController {
  RxString loginMethod = ''.obs;
  dynamic user = {}.obs;
  RxBool isLoading = false.obs;

  void setUser(LoggedUser newUser) {
    user = newUser.toJson();
    print('Logged in user is $user');
  }

  void clearUserInfo() {
    user = {};
  }

  void logout() {
    LoggedUser currentUser = LoggedUser.fromJson(user);
    String username = currentUser.username;
    clearUserInfo();
    Get.offAndToNamed('login', arguments: [true, username]);
  }
}
