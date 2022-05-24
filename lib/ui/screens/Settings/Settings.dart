import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:letstalk/core/controllers/LoginController.dart';
import 'package:letstalk/core/internationalization/AppLanguage.dart';
import 'package:letstalk/core/models/LoggedUser.dart';
import 'package:letstalk/core/providers/AuthProvider.dart';
import 'package:letstalk/core/services/AuthService.dart';
import 'package:letstalk/ui/widgets/AppBar/CustomAppBar.dart';
import 'package:letstalk/ui/widgets/CustomButton/CustomButton.dart';
import 'package:letstalk/ui/widgets/Drawer/drawer.dart';
import 'package:letstalk/utils/common.dart';
import 'package:letstalk/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final AuthController _authController = Get.put(AuthController());
  SharedPreferences? prefs;
  bool showPlainPasswd = false;
  bool showPlainConfirmPasswd = false;
  String password = '';
  String confirmpassword = '';
  RangeValues rangeValues = RangeValues(0, 100);
  double selectedRange = 80.0;
  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    LoggedUser currentUser = LoggedUser.fromJson(_authController.user);
    var googleProvider = Provider.of<AuthProvider>(context, listen: false);
    var appLanguage = Provider.of<AppLanguage>(context);
    List availableLanguages = [
      {'id': 1, 'lang': 'English'},
      {'id': 2, 'lang': 'French'}
    ];
    int selectedLanguage = -1;
    Row buildNotificationOptionRow(String title, bool isActive) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]),
          ),
          Transform.scale(
              scale: 0.7,
              child: Switch(
                value: isActive,
                onChanged: (bool val) {},
              ))
        ],
      );
    }

    GestureDetector buildAccountOptionRow(
      BuildContext context,
      IconData iconData,
      String title,
      List<Widget> content,
    ) {
      return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: content,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close")),
                  ],
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(iconData),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    }

    bool isItemSelected(id, List list) {
      for (int i = 0; i < list.length; i++) {
        print(list[i]['id']);
        print(id);
        if (list[i]['id'] == id) {
          // print(id);
          return true;
        }
      }
      return false;
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
        appBar: CustomAppBar(
          controller: _advancedDrawerController,
          withTrailingAction: false,
          withBackButton: true,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(
            children: [
              Text(
                "Settings",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              if (prefs!.getString("provider") == "local")
                buildAccountOptionRow(
                    context, Icons.password_sharp, "Change password", [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //#Password
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200)),
                        ),
                        child: TextFormField(
                          // scrollPadding: _scrollPading,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: !showPlainPasswd,
                          onChanged: (value) {
                            if (value.isNotEmpty && value != '') {
                              setState(() {
                                password = value.trim();
                              });
                            }
                          },
                          validator: (val) => validatePassword(val!, false),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPlainPasswd = !showPlainPasswd;
                                    });
                                  },
                                  icon: Icon(Icons.remove_red_eye)),
                              hintText: translate(
                                  appLanguage, context, 'placeholder.password'),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      //#Confirm Password
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200)),
                        ),
                        child: TextFormField(
                          // scrollPadding: _scrollPading,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: !showPlainConfirmPasswd,
                          onChanged: (value) {
                            if (value.isNotEmpty && value != '') {
                              setState(() {
                                confirmpassword = value.trim();
                              });
                            }
                          },
                          validator: (val) => validatePassword(val!, true),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPlainConfirmPasswd =
                                          !showPlainConfirmPasswd;
                                    });
                                  },
                                  icon: Icon(Icons.remove_red_eye)),
                              hintText: translate(appLanguage, context,
                                  'placeholder.confirmPassword'),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: InputBorder.none),
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            changePassword(currentUser.id, password);
                          },
                          child: Text("Change password")),
                    ],
                  )
                ]),
              buildAccountOptionRow(
                  context, Icons.slideshow_rounded, "Range settings", [
                Text(selectedRange.toStringAsPrecision(2),
                    style: TextStyle(color: Colors.purple)),
                Slider.adaptive(
                    min: 0,
                    max: 100,
                    onChangeStart: (double v) {
                      print('started draggin');
                    },
                    autofocus: true,
                    mouseCursor: MouseCursor.defer,
                    thumbColor: Colors.white,
                    activeColor: Colors.purple,
                    inactiveColor: Colors.grey,
                    label: "Range: ${selectedRange.toString()}",
                    value: selectedRange,
                    onChanged: (double val) {
                      setState(() {
                        selectedRange = val;
                      });
                    })
              ]),
              buildAccountOptionRow(context, Icons.language, "Language", [
                SizedBox(
                  height: .3.sh,
                  child: ListView.separated(
                    itemCount: availableLanguages.length,
                    itemBuilder: (ctx, index) {
                      var language = availableLanguages[index];
                      return ListTile(
                        key: ValueKey(language['id']),
                        title: Text(language['lang']),
                        trailing: selectedLanguage == language['id']
                            ? Icon(Icons.check_circle, color: Colors.green[500])
                            : null,
                        onTap: () {
                          setState(() {
                            selectedLanguage = language['id'];
                          });
                          print(
                              "is ${language['lang']} selected ? ${selectedLanguage == language['id']}");
                          // print(selectedLanguage['id'] == language['id']);
                          print('selected language is $selectedLanguage');
                        },
                      );
                    },
                    separatorBuilder: (ctx, int) {
                      return Divider();
                    },
                  ),
                )
              ]),
              buildAccountOptionRow(
                  context, Icons.security_outlined, "Privacy and security", []),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Icon(
                    Icons.volume_up_outlined,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              buildNotificationOptionRow("Matches", true),

              SizedBox(
                height: 40,
              ),

              Row(
                children: [
                  Icon(
                    Icons.accessibility_rounded,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Accessibility",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                height: 15,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              buildNotificationOptionRow("Dark mode", false),
              // buildNotificationOptionRow("Account activity", true),
              // buildNotificationOptionRow("Opportunity", false),
              Container(
                height: 50,
                child: Center(
                  child: CustomButton(
                      title: "SIGN OUT",
                      onTapCallBack: () {
                        if (prefs!.getString("provider") == "google")
                          googleProvider.handleSignOut();
                        else
                          _authController.logout();
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
