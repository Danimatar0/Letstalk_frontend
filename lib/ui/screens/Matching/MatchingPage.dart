import 'dart:async';
import 'dart:math';

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
  List<User> users = RxList<User>();
  RxBool loading = RxBool(true);
  RxDouble avatarRadius = RxDouble(40);
  LoggedUser? user;
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

      Get.dialog(AlertDialog(
        content: ItsAMatch(
            matcheeName: cardUser != null ? cardUser!.firstname : '',
            matcheeUrl: cardUser != null ? cardUser!.avatar : '',
            action1: () => action1(),
            action2: () => action2()),
      ));
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
      final size = MediaQuery.of(context).size;
      localProvider.setScreenSize(size);
    }).then((value) {
      Future.delayed(Duration(milliseconds: 300), () {
        // print(localProvider.allUsers);
        setState(() {
          users = localProvider.allUsers;
        });
      });
    }).then((value) => loading.toggle());
    setState(() {
      user = LoggedUser.fromJson(_authController.user);
    });
  }

  int getUserAge(String currDate, String dob) {
    currDate = currDate.split(" ")[0];
    dob = '${dob.split("-")[2]}-${dob.split("-")[1]}-${dob.split("-")[0]}';
    String year = currDate.split('-')[0];
    String month = currDate.split('-')[1];
    String day = currDate.split('-')[2];
    String dateToFormat = '$year-$month-$day';
    var date = DateTime.parse(dateToFormat);
    var dobDate = DateTime.parse(dob);
    var diff = date.difference(dobDate);
    // print('dtf $date');
    // print('dob date $dobDate');
    var age = diff.inDays / 365;
    // print('user age $age');
    return age.round();
  }

  Widget buildName(User us) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              us.firstname + ' ' + us.lastname,
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(getUserAge(getCurrentDate(), us.dob).toString(),
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      );

  Widget buildStatus(User us) => Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          ),
          const SizedBox(
            width: 8,
          ),
          Text('Recently Active',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      );

  Widget buildCard(User us) {
    print("avatar: " + us.avatar);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
          decoration: us.avatar == ''
              ? null
              : BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(us.avatar),
                      fit: BoxFit.cover,
                      alignment: Alignment(-0.3, 0))),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1])),
            child: Container(
              padding: const EdgeInsets.all(20),
              height: .7.sh,
              child: Column(
                children: [
                  const Spacer(),
                  buildName(us),
                  const SizedBox(
                    height: 8,
                  ),
                  buildStatus(us)
                ],
              ),
            ),
          )),
    );
  }

  Widget buildFrontCard(User us) => GestureDetector(
        child: LayoutBuilder(builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          final position = provider.position;
          final millis = provider.isDragging ? 0 : 400;
          final angle = provider.angle * pi / 180;
          final center = constraints.smallest.center(Offset.zero);
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);
          print("here");
          return AnimatedContainer(
              duration: Duration(milliseconds: millis),
              curve: Curves.easeInOut,
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: buildCard(us));
        }),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition();
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
      );
  Widget buildRearCard(User us) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            child: us.avatar == ''
                ? CircleAvatar(
                    child: Container(
                      color: PRIMARY_COLOR,
                    ),
                  )
                : null,
            decoration: us.avatar == ''
                ? null
                : BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(us.avatar),
                        fit: BoxFit.cover,
                        alignment: Alignment(-0.3, 0)))),
      );
  Widget buildCoCentricCircles(int nbCircles) {
    // LoggedUser user = LoggedUser.fromJson(_authController.user);
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
                    // print(size);
                    return CircleAvatar(
                      radius: size,
                      backgroundImage: user!.imgUrl == ''
                          ? null
                          : NetworkImage(user!.imgUrl, scale: 1.0),
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
        children: [
          buildCoCentricCircles(3),
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 40),
              child: Text(
                "OOPS! We couldn't find any user in your area or your food partner, Be patient ;)",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;

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
                      Get.toNamed('/profile', arguments: [true]);
                    })
              ]);

    Widget buildCards() {
      ///users is a list of users having the same preference(cuisine) as the logged in user
      return Container(
          child: FutureBuilder<dynamic>(
        future: getUsersByPreferenceId(user!.username, user!.token!),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          // print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              //zedla shi oops kaza
              return const Text('Error');
            } else if (snapshot.hasData) {
              List myUsers = snapshot.data;
              print("my fucking userss $myUsers");
              return myUsers.isEmpty
                  ? buildNoUsersLeft()
                  : SizedBox(
                      height: .4.sh,
                      child: Stack(
                          children: myUsers.map((u) {
                        print("u -> $u");
                        User cardUser = User.fromMap(u);
                        bool isLastCard = myUsers.last == cardUser;
                        final cardProvider =
                            Provider.of<CardProvider>(context, listen: false);
                        // cardProvider.setScreenSize(size);
                        if (isLastCard)
                          matchController.updateMatchee(cardUser.id);
                        return isLastCard
                            ? buildFrontCard(cardUser)
                            : buildRearCard(cardUser);
                        // return MatchCard(
                        //   user: cardUser,
                        //   isFront: true,
                        //   callBack: () {},
                        // );
                      }).toList()),
                    );
            } else {
              return buildNoUsersLeft();
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ));
      // return Obx(() {
      //   print("users empty ?? ${users.isEmpty}");
      //   return users.isEmpty
      //       ? buildNoUsersLeft()
      //       : Stack(
      //           children: users.map((u) {
      //           cardUser = (u as User);
      //           return MatchCard(
      //             user: u,
      //             isFront: users.last == u,
      //             callBack: () {},
      //           );
      //         }).toList());
      // });
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
