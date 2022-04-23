import 'package:flutter/material.dart';
import '../../../utils/styles.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          color: YELLOW_COLOR,
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
