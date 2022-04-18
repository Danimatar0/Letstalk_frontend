import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letstalk/core/models/User.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/CardProvider.dart';
import '../../widgets/MatchCard/MatchCardFile.dart';

class MatchingScreen extends StatelessWidget {
  const MatchingScreen({Key? key}) : super(key: key);

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

    return Container(
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
                buildLogo(),
                const SizedBox(height: 16),
                buildCards(),
                const SizedBox(height: 16),
                buildButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
