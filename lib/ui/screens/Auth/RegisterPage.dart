import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/GoogleSignInProvider.dart';
import '../../../utils/styles.dart';
import '../../widgets/CustomButton/CustomButton.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[
      // Color(0xFF4285F4),
      // Color(0xFF34A853),
      Color(0xFFFBBC05),
      Color(0xFFea4335),
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  ///This variable indicates if the screen is loading or not, having a type of [RxBool]
  RxBool isLoading = RxBool(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          PRIMARY_COLOR,
          Colors.red.shade400,
          Colors.red.shade800
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: .003.sh,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 0.05.sh),
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.black26, fontSize: 40),
                        ),
                      ),

                      //#firstname,#lastname,#phone,#dob,#email, #password
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(171, 171, 171, .7),
                                blurRadius: 20,
                                offset: Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200)),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                    hintText: "Firstname",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200)),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                    hintText: "Lastname",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200)),
                              ),
                              child: TextField(
                                onTap: () {
                                  Get.dialog(CalendarDatePicker(
                                      initialDate: DateTime(2020),
                                      firstDate: DateTime(2021),
                                      lastDate: DateTime(2022),
                                      onDateChanged: (DateTime d) {
                                        print('selected date is $d');
                                      }));
                                },
                                decoration: const InputDecoration(
                                    hintText: "Date of birth",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200)),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200)),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: .05.sh),
                      // #register
                      Container(
                        width: .35.sw,
                        height: .07.sh,
                        child: CustomButton(
                            title: 'Register',
                            color: Colors.white,
                            bgColor: Colors.purple.shade700,
                            onTapCallBack: () {
                              print('registerr');
                              // Get.toNamed('/match');
                            }),
                      ),
                      SizedBox(height: .014.sh),
                      // #login SNS
                      const Flexible(
                        child: Text(
                          "Or with",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // SizedBox(height: .015.sh),
                      Row(
                        children: [
                          Expanded(
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                margin: EdgeInsets.only(top: .01.sh),
                                height: .05.sh,
                                child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                    onPressed: () async {
                                      final provider =
                                          Provider.of<GoogleSignInProvider>(
                                              context,
                                              listen: false);
                                      bool isAuth =
                                          await provider.googleLogin();
                                      if (isAuth) Get.toNamed('/match');
                                    },
                                    icon: FaIcon(FontAwesomeIcons.google,
                                        color: PRIMARY_COLOR),
                                    label: Text(
                                      'Sign In with Google',
                                      style: TextStyle(
                                          color: PRIMARY_COLOR, fontSize: 8),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
