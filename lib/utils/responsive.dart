import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import 'common.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design



  @override
  Widget build(BuildContext context) {
    // If our width is more than 1100 then we consider it a desktop
    if (isDesktop(context)) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (isTablet(context) && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}
