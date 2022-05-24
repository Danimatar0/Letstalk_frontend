import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:letstalk/core/controllers/LoginController.dart';
import 'package:letstalk/core/models/LoggedUser.dart';
import 'package:letstalk/core/services/UtilsService.dart';
import 'package:letstalk/utils/common.dart';

import '../models/User.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  final authController = Get.put(AuthController());
  Offset _position = Offset.zero;
  bool _isDragging = false;
  Size _screenSize = Size.zero;
  double _angle = 0;
  List<User> _allUsers = [];
  LoggedUser currentUser = new LoggedUser(
      id: -1,
      username: 'username',
      firstname: 'firstname',
      lastname: 'lastname',
      imgUrl: 'imgUrl',
      preferences: []);
  //--------------//
  Offset get position => _position;
  bool get isDragging => _isDragging;
  Size get screenSize => _screenSize;
  double get angle => _angle;
  List<User> get allUsers => _allUsers;

  void initializeUsers() {
    currentUser = LoggedUser.fromJson(authController.user);
    // print(currentUser.token!);
    resetUsers(currentUser.token ?? "");
  }

  void setScreenSize(Size s) {
    _screenSize = s;
    notifyListeners();
  }

  void startPosition() {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    // print('details on update $details');
    _position += details.delta;
    final x = _position.dx;
    // print('old angle $angle');
    //45 is the maximum of angle allowed while dragging the card around
    _angle = 45 * x / screenSize.width;
    // print('new angle $angle');

    notifyListeners();
  }

  void endPosition() {
    // print('end position');
    _isDragging = false;
    notifyListeners();
    final status = getStatus();
    if (status != null) {
      print(status.toString().split('.').last.toUpperCase());
      // FlutterToast.cancel();
      // FlutterToast.showToast(
      //     msg: status.toString().split('.').last.toUpperCase(), fontSize: 36);
    }
    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        disLike();
        break;
      case CardStatus.superLike:
        superLike();
        break;
      default:
        resetPosition();
    }
    resetPosition();
  }

  void resetPosition() {
    _position = Offset.zero;
    _isDragging = false;
    _angle = 0;
    notifyListeners();
  }

  void resetUsers(String token) async {
    print('resetting users');
    List tmp = await getUsersByPreferenceId(currentUser.id, token);
    // print('tmpppp $tmp');
    List<User> listusers = [];
    tmp.forEach((e) {
      // print('e --> $e');
      // print('curr id ${currentUser.id}');
      // bool samePerson = e['id'] == currentUser.id ? true : false;
      // print('same person ? $samePerson');
      // if (!samePerson) {
      listusers.add(User(
          id: e['id'] ?? -1,
          firstname: e['firstname'] ?? '',
          lastname: e['lastname'] ?? '',
          email: e['email'] ?? '',
          phone: e['phoneNumber'] ?? '',
          avatar: e['image'] ?? '',
          about: '',
          dob: e['dob'] ?? ''));
      // }
    });
    _allUsers = listusers.reversed.toList();
    notifyListeners();
    print('all userss -> $_allUsers');
  }

  CardStatus? getStatus() {
    final x = _position.dx;
    final y = _position.dy;
    const delta = 100;
    //x is not greater than 20 pixels
    bool forceSuperLike = x.abs() < 20;
    if (x >= delta) {
      return CardStatus.like;
    } else if (x <= -delta) {
      return CardStatus.dislike;
    } else if (y <= -delta / 2 && forceSuperLike) {
      return CardStatus.superLike;
    }
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    print('liking');
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (allUsers.isEmpty) return;
    await Future.delayed(Duration(milliseconds: 200));
    allUsers.removeLast();
    resetPosition();
  }

  void disLike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();
    notifyListeners();
  }
}
