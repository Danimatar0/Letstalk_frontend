import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:letstalk/core/controllers/LoginController.dart';
import 'package:letstalk/core/models/LoggedUser.dart';

class ItsAMatch extends StatefulWidget {
  const ItsAMatch({
    Key? key,
    required this.matcheeName,
    required this.matcheeUrl,
    required this.action1,
    required this.action2,
  }) : super(key: key);
  final String matcheeName;
  final String matcheeUrl;
  final Function action1;
  final Function action2;
  @override
  State<ItsAMatch> createState() => _ItsAMatchState();
}

class _ItsAMatchState extends State<ItsAMatch> {
  final AuthController _authController = Get.put(AuthController());
  LoggedUser? currentUser;
  @override
  void initState() {
    super.initState();
    setState(() {
      currentUser = LoggedUser.fromJson(_authController.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withOpacity(50),
        height: 1.sh,
        child: Column(
          children: [
            Text("It's A Match!"),
            Text("You and Dani have liked each other"),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.matcheeUrl),
                  radius: 30,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      currentUser != null ? currentUser!.imgUrl : ''),
                  radius: 30,
                )
              ],
            ),
            ElevatedButton(
              child: Text(
                'Send a Message',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                widget.action1();
              },
            ),
            ElevatedButton(
              child: Text(
                'Keep Swiping',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {
                widget.action2();
              },
            ),
          ],
        ),
      ),
    );
  }
}
