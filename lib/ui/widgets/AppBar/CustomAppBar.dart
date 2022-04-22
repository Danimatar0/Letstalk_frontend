import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:letstalk/utils/styles.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final AdvancedDrawerController controller;

  @override
  Widget build(BuildContext context) {
    void _handleMenuButtonPressed(AdvancedDrawerController controller) {
      controller.showDrawer();
    }

    return AppBar(
      centerTitle: true,
      backgroundColor: CHAIR_COLOR,
      title: const Text(
        'Let\'s Talk',
        style: TextStyle(fontFamily: 'OpenSansSemiBold'),
      ),
      leading: IconButton(
        color: Colors.black,
        onPressed: () => _handleMenuButtonPressed(controller),
        icon: ValueListenableBuilder<AdvancedDrawerValue>(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
