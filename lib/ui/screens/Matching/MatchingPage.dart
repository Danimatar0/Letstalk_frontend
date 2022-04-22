import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:letstalk/core/models/User.dart';
import 'package:letstalk/ui/widgets/AppBar/CustomAppBar.dart';
import 'package:letstalk/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/CardProvider.dart';
import '../../widgets/Drawer/drawer.dart';
import '../../widgets/MatchCard/MatchCardFile.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({Key? key}) : super(key: key);

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  late SharedPreferences _prefs;
  late TextEditingController _textEditingController;
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
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
          children: [
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

                  provider.like();
                },
                child: Icon(Icons.star, color: Colors.blue, size: 40)),
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
          ],
        );

    Widget buildCards() {
      final provider = Provider.of<CardProvider>(context, listen: true);
      final users = provider.allUsers;

      return users.isEmpty
          ? Center(
              child: ElevatedButton(
                  onPressed: () {
                    provider.resetUsers();
                  },
                  child:
                      Text('Restart', style: TextStyle(color: Colors.black))))
          : Stack(
              children: users
                  .map((u) => MatchCard(
                        user: u,
                        isFront: users.last == u,
                      ))
                  .toList());
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
        appBar: CustomAppBar(controller: _advancedDrawerController),
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
