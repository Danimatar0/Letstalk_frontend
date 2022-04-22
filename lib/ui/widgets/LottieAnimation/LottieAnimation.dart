import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimatedWidget extends StatefulWidget {
  const LottieAnimatedWidget({
    Key? key,
    required this.lottieUrl,
  }) : super(key: key);
  final String lottieUrl;
  @override
  _LottieAnimatedWidgetState createState() => _LottieAnimatedWidgetState();
}

class _LottieAnimatedWidgetState extends State<LottieAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lottie.network(
        widget.lottieUrl,
        repeat: true,
        controller: controller,
        onLoaded: (loaded) {
          controller.repeat();
        },
      ),
    );
  }
}
