import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:letstalk/core/internationalization/AppLanguage.dart';
import 'package:letstalk/core/providers/providers.dart';
import 'package:letstalk/utils/common.dart';
import 'package:letstalk/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/controllers/LoginController.dart';
import '../../../core/models/LoggedUser.dart';
import '../../../core/providers/GoogleSignInProvider.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authController = Get.put(AuthController());
    LoggedUser currentUser = LoggedUser.fromJson(_authController.user);
    var googleProvider = Provider.of<AuthProvider>(context, listen: false);
    var appLanguage = Provider.of<AppLanguage>(context);
    SharedPreferences? prefs;
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
    });
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 80.0,
                  height: 80.0,
                  margin: const EdgeInsets.only(
                    left: 20,
                    top: 24.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child:
                      (currentUser.imgUrl == null || currentUser.imgUrl == '')
                          ? Container(
                              color: PRIMARY_COLOR,
                            )
                          : Image.network(currentUser.imgUrl)),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  currentUser.firstname + " " + currentUser.lastname,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Divider(
                color: Colors.grey.shade800,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/match');
                },
                leading: const Icon(Icons.home_outlined),
                title: Text(translate(appLanguage, context, 'drawer.match')),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/listchats');
                },
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text(translate(appLanguage, context, 'drawer.chats')),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(color: Colors.grey.shade800),
              ListTile(
                onTap: () {
                  Get.toNamed('/profile');
                },
                leading: const Icon(Iconsax.profile),
                title: Text(translate(appLanguage, context, 'drawer.profile')),
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/settings');
                },
                leading: const Icon(Iconsax.setting_2),
                title: Text(translate(appLanguage, context, 'drawer.settings')),
              ),
              ListTile(
                onTap: () {
                  Get.toNamed('/support');
                },
                leading: const Icon(Iconsax.support),
                title: Text(translate(appLanguage, context, 'drawer.support')),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: ListTile(
                  onTap: () {
                    // _authController.isLoading.toggle();

                    if (prefs!.getString("provider") == "google")
                      googleProvider.handleSignOut();
                    else
                      _authController.logout();
                  },
                  title: Text(
                    translate(appLanguage, context, 'drawer.logout'),
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: IconButton(
                      onPressed: () {
                        // _authController.isLoading.toggle();
                        if (prefs!.getString("provider") == "google")
                          googleProvider.handleSignOut();
                        else
                          _authController.logout();
                        // else
                        //   _authController.logout();
                      },
                      icon: const Icon(Icons.logout)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
