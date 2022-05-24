import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:letstalk/core/controllers/LoginController.dart';
import 'package:letstalk/core/controllers/MatchController.dart';
import 'package:letstalk/core/models/LoggedUser.dart';
import 'package:letstalk/core/models/User.dart';
import 'package:letstalk/core/services/UtilsService.dart';
import 'package:letstalk/ui/widgets/AppBar/CustomAppBar.dart';
import 'package:letstalk/ui/widgets/CustomButton/CustomButton.dart';
import 'package:letstalk/ui/widgets/MatchCard/ItsAMatch.dart';
import 'package:letstalk/utils/common.dart';
import 'package:letstalk/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/CardProvider.dart';
import '../../widgets/Drawer/drawer.dart';
import '../../widgets/MatchCard/MatchCardFile.dart';
import 'dart:math' as math;

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({Key? key}) : super(key: key);

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen>
    with TickerProviderStateMixin {
  late SharedPreferences _prefs;
  User? cardUser;
  LoggedUser? currentUser;
  late TextEditingController _textEditingController;
  final _authController = Get.put(AuthController());
  final matchController = Get.put(MatchController());
  List users = [];
  RxBool loading = RxBool(true);
  RxDouble avatarRadius = RxDouble(40);

  void animateAvatar() {
    // if (avatarRadius <= 60) {
    Future.delayed(Duration(seconds: 3)).then((value) => setState(() {
          avatarRadius.value = avatarRadius.value * 2;
        }));
    Future.delayed(Duration(seconds: 1)).then((value) {
      setState(() {
        avatarRadius.value = avatarRadius.value / 2;
        currentUser = LoggedUser.fromJson(_authController.user);
      });
      print(avatarRadius);
    });
    // }
  }

  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  void action1() {}
  void action2() {}
  void _handleLike(int idMatchee) async {
    print('liking $idMatchee');
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    var matchDto = {'User1': cardProvider.currentUser.id, 'User2': idMatchee};
    String token = cardProvider.currentUser.token ?? '';
    var resp = await match(matchDto, token);
    print('resp in handle match ==> $resp');
    if (resp['message'] == 'Match 2') {
      print('we have a matchhh wouhouu');

      Get.dialog(ItsAMatch(
          matcheeName: cardUser != null ? cardUser!.firstname : '',
          matcheeUrl: cardUser != null ? cardUser!.avatar : '',
          action1: () => action1(),
          action2: () => action2()));
    }
    cardProvider.like();
  }

  @override
  void initState() {
    super.initState();
    loading.toggle();
    var localProvider;
    Future.delayed(Duration.zero, () {
      localProvider = Provider.of<CardProvider>(context, listen: false);
      localProvider.initializeUsers();
    }).then((value) {
      Future.delayed(Duration(milliseconds: 300), () {
        // print(localProvider.allUsers);
        setState(() {
          users = localProvider.allUsers;
        });
      });
    }).then((value) => loading.toggle());
  }

  Widget buildCoCentricCircles(int nbCircles) {
    LoggedUser user = LoggedUser.fromJson(_authController.user);
    List<Widget> stackChildren = [];
    // for (var v = 0; v < 5000; v++) {
    //   animateAvatar();
    // }
    for (int i = nbCircles; i >= 1; i--) {
      stackChildren.add(Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withOpacity(1.0 - (i / nbCircles)),
          ),
          width: (150 * i).toDouble(),
          height: (150 * i).toDouble(),
          alignment: Alignment.center,
          child: i == 1
              ? Obx(
                  () {
                    double size = avatarRadius.value;
                    print(size);
                    return CircleAvatar(
                      radius: size,
                      backgroundImage: NetworkImage(user.imgUrl, scale: 1.0),
                    );
                  },
                )
              : Container(),
        ),
      ));
    }
    Widget circles = Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: stackChildren,
      ),
    );
    return circles;
  }

  Widget buildNoUsersLeft() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildCoCentricCircles(3)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context, listen: true);

    Widget buildLogo() => Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Let\'s Talk',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        );
    Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: users.isNotEmpty
            ? [
                ElevatedButton(
                    onPressed: () {
                      final provider =
                          Provider.of<CardProvider>(context, listen: false);
                      provider.startPosition();
                      provider.updatePosition(DragUpdateDetails(
                          globalPosition: Offset(0.0, 0.0),
                          localPosition: Offset(-3.0, 0.0)));
                      provider.endPosition();
                      provider.disLike();
                    },
                    child: Icon(Icons.clear, color: Colors.red, size: 40)),
                ElevatedButton(
                    onPressed: () {
                      final provider =
                          Provider.of<CardProvider>(context, listen: false);
                      provider.startPosition();
                      provider.updatePosition(DragUpdateDetails(
                          globalPosition: Offset(0.0, 0.0),
                          localPosition: Offset(-3.0, 0.0)));
                      provider.endPosition();
                      provider.superLike();
                    },
                    child: Icon(Icons.favorite, color: Colors.teal, size: 40)),
                ElevatedButton(
                    onPressed: () {
                      final provider =
                          Provider.of<CardProvider>(context, listen: false);
                      provider.startPosition();
                      provider.updatePosition(DragUpdateDetails(
                          globalPosition: Offset(0.0, 0.0),
                          localPosition: Offset(-3.0, 0.0)));
                      provider.endPosition();

                      _handleLike(
                        matchController.idMatchee.value,
                      );
                    },
                    child: Icon(Icons.star, color: Colors.blue, size: 40)),
              ]
            : [
                CustomButton(
                    title: 'Change your preferences',
                    color: PRIMARY_COLOR,
                    onTapCallBack: () {
                      Get.toNamed('/settings');
                    })
              ]);

    Widget buildCards() {
      ///users is a list of users having the same preference(cuisine) as the logged in user
      return users.isEmpty
          ? buildNoUsersLeft()
          : Stack(
              children: users.map((u) {
              cardUser = (u as User);
              return MatchCard(
                user: u,
                isFront: users.last == u,
                callBack: () {},
              );
            }).toList());
    }

    return AdvancedDrawer(
      backdropColor: CHAIR_COLOR,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900,
            blurRadius: 20.0,
            spreadRadius: 5.0,
            offset: Offset(-20.0, 0.0),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      drawer: const DrawerWidget(),
      child: Scaffold(
        appBar: CustomAppBar(
          controller: _advancedDrawerController,
          withTrailingAction: false,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red.shade200, Colors.black])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 1.sh,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // buildLogo(),
                    // const SizedBox(height: 16),
                    buildCards(),
                    const SizedBox(height: 16),
                    buildButtons()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
