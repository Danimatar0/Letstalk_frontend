import 'package:flutter/material.dart';

import '../core/constants/constants.dart';

const PRIMARY_COLOR = Color(0XFFFD297b);
const SECONDARY_COLOR = Color(0XFFFFCA3A);
const CHAIR_COLOR = Color(0XFFFF655B);
var RED_COLOR = Colors.red.shade600;
var GREEN_COLOR = Colors.green.shade600;
var BLUE_COLOR = Colors.blue.shade600;
var YELLOW_COLOR = Colors.yellow.shade600;
var ORANGE_COLOR = Colors.orange.shade600;
var PURPLE_COLOR = Colors.purple.shade700;
const DARK_BLUE_COLOR = ColorConstants.primaryColor;

class Themes {
  static final light = ThemeData.light().copyWith(
    backgroundColor: Colors.red,
  );
  static final dark = ThemeData.dark().copyWith(
    backgroundColor: Colors.black,
    buttonColor: Colors.white,
  );
}
