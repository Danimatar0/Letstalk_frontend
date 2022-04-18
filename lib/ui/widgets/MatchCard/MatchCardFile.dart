import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:letstalk/utils/common.dart';

import '../../../core/models/User.dart';
import '../../../core/providers/CardProvider.dart';

class MatchCard extends StatefulWidget {
  const MatchCard({
    Key? key,
    required this.user,
    required this.isFront,
  }) : super(key: key);
  final User user;
  final bool isFront;

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final cardProvider = Provider.of<CardProvider>(context, listen: false);
      cardProvider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    int getUserAge(String currDate, String dob) {
      var date = DateTime.parse(currDate);
      var dobDate = DateTime.parse(dob);
      var diff = date.difference(dobDate);
      var age = diff.inDays / 365;
      return age.round();
    }

    Widget buildName() => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.user.firstname + ' ' + widget.user.lastname,
              style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 8,
            ),
            Text(getUserAge(getCurrentDate(), widget.user.dob).toString(),
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        );

    Widget buildStatus() => Row(
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

    Widget buildCard() => ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.user.avatar),
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
                      buildName(),
                      const SizedBox(
                        height: 8,
                      ),
                      buildStatus()
                    ],
                  ),
                ),
              )),
        );

    Widget buildFrontCard() => GestureDetector(
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
            return AnimatedContainer(
                duration: Duration(milliseconds: millis),
                curve: Curves.easeInOut,
                transform: rotatedMatrix..translate(position.dx, position.dy),
                child: buildCard());
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
    Widget buildRearCard() => ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.user.avatar),
                    fit: BoxFit.cover,
                    alignment: Alignment(-0.3, 0))),
          ),
        );
    return widget.isFront ? buildFrontCard() : buildRearCard();
  }
}
