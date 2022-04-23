import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:letstalk/core/controllers/LoginController.dart';
import 'package:letstalk/utils/styles.dart';

import '../../../core/constants/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.controller,
    required this.withTrailingAction,
    this.trailingActionWidgets,
    this.title = 'Let\'s Talk',
    this.bgColor = CHAIR_COLOR,
    this.textColor = DARK_BLUE_COLOR,
    this.leadingActionWidget,
    this.withBackButton = false,
  }) : super(key: key);
  final AdvancedDrawerController controller;
  final bool withTrailingAction;
  final List<Widget>? trailingActionWidgets;
  final String title;
  final Color? bgColor;
  final Color? textColor;
  final Widget? leadingActionWidget;
  final bool withBackButton;
  @override
  Widget build(BuildContext context) {
    final _authController = Get.put(AuthController());
    void _handleMenuButtonPressed(AdvancedDrawerController controller) {
      controller.showDrawer();
    }

    // print('logged in user ${_authController.user}');
    return AppBar(
        centerTitle: true,
        backgroundColor: bgColor,
        title: Text(
          title,
          style: TextStyle(color: textColor, fontFamily: 'OpenSansSemiBold'),
        ),
        leading: IconButton(
          color: Colors.black,
          onPressed: () => withBackButton
              ? Get.back()
              : _handleMenuButtonPressed(controller),
          icon: withBackButton
              ? Icon(Icons.arrow_back_sharp)
              : ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Iconsax.close_square : Iconsax.menu,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
        ),
        actions: withTrailingAction ? trailingActionWidgets! : null);
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
