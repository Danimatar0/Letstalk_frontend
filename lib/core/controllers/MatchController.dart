import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../models/LoggedUser.dart';

class MatchController extends GetxController {
  RxInt idMatchee = RxInt(-1);

  void updateMatchee(int newMatchee) {
    idMatchee.value = newMatchee;
    debugPrint('new matchee ==> $newMatchee');
  }
}
