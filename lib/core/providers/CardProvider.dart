import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:letstalk/core/controllers/LoginController.dart';
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

  //--------------//
  Offset get position => _position;
  bool get isDragging => _isDragging;
  Size get screenSize => _screenSize;
  double get angle => _angle;
  List<User> get allUsers => _allUsers;

  CardProvider() {
    int idPref = -1;
    // String token = getValueFromPath(authController.user,'token');
    resetUsers(idPref,"");
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

  void resetUsers(int prefId, String token) async {
    print('resetting users');
    List tmp = await getUsersByPreferenceId(prefId, token);
    _allUsers = <User>[
      User(
          id: 1,
          firstname: 'Dani',
          lastname: 'Matar',
          email: 'dani.matar@gmail.com',
          phone: '+96101010101',
          avatar:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1000&q=60',
          about: 'Helloo',
          dob: '2000-05-05'),
      User(
          id: 2,
          firstname: 'Mona',
          lastname: 'Jefferson',
          email: 'toni.matar@gmail.com',
          phone: '+96101010101',
          avatar:
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1000&q=60',
          about: 'Helloo',
          dob: '2000-05-05'),
      User(
          id: 3,
          firstname: 'Alex',
          lastname: 'Kardashoan',
          email: 'alex.kard@gmail.com',
          phone: '+96101010101',
          avatar:
              'https://images.unsplash.com/file-1646172372557-6258c0de0873image',
          about: 'Helloo',
          dob: '2000-05-05'),
      User(
          id: 4,
          firstname: 'Toni',
          lastname: 'Matar',
          email: 'mona.deff@gmail.com',
          phone: '+96101010101',
          avatar:
              'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8cmFuZG9tJTIwcGVvcGxlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1000&q=60',
          about: 'Helloo',
          dob: '2000-05-05')
    ].reversed.toList();
    notifyListeners();
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
