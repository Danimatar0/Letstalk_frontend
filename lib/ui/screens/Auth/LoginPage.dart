import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/src/provider.dart';
import '../../../core/controllers/LoginController.dart';
import '../../../core/internationalization/AppLanguage.dart';
import '../../../core/providers/GoogleSignInProvider.dart';
import '../../../utils/common.dart';
import '../../../utils/styles.dart';
import '../../widgets/CustomButton/CustomButton.dart';
import '../../widgets/LottieAnimation/LottieAnimation.dart';

class LandingPageMobile extends StatefulWidget {
  const LandingPageMobile({Key? key}) : super(key: key);

  @override
  State<LandingPageMobile> createState() => _LandingPageMobileState();
}

class _LandingPageMobileState extends State<LandingPageMobile> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final _loginController = Get.put(LoginController());
    var appLanguage = Provider.of<AppLanguage>(context);

    final Shader linearGradient = const LinearGradient(
      colors: <Color>[
        // Color(0xFF4285F4),
        // Color(0xFF34A853),
        Color(0xFFFBBC05),
        Color(0xFFea4335),
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() => _loginController.isLoading.isTrue
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                // Colors.red.shade900,
                // Colors.red.shade500,
                // Colors.red.shade400,
                PRIMARY_COLOR,
                Colors.red.shade400,
                Colors.red.shade800
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 80),
                  // #login, #welcome
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60)),
                    ),
                    height: .3.sh,
                    child: const LottieAnimatedWidget(
                      lottieUrl:
                          'https://assets7.lottiefiles.com/packages/lf20_at8qlzeo.json',
                    ),
                  ),
                  const SizedBox(height: 10),
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
                            Container(
                              margin: EdgeInsets.only(bottom: 0.05.sh),
                              child: Text(
                                translate(appLanguage, context, 'drawer.login'),
                                style: const TextStyle(
                                    color: Colors.black26, fontSize: 40),
                              ),
                            ),

                            // #email, #password
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
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: translate(appLanguage,
                                              context, 'placeholder.email'),
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
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
                                      decoration: InputDecoration(
                                          hintText: translate(appLanguage,
                                              context, 'placeholder.password'),
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // #login
                            Container(
                              width: .35.sw,
                              height: .07.sh,
                              child: CustomButton(
                                  title: translate(
                                      appLanguage, context, 'drawer.login'),
                                  color: Colors.white,
                                  bgColor: PRIMARY_COLOR,
                                  onTapCallBack: () {
                                    print('loginn');
                                    // Get.toNamed('/match');
                                  }),
                            ),
                            SizedBox(height: 10),
                            // #login SNS
                            Flexible(
                              child: Text(
                                translate(appLanguage, context, 'text.orWith'),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                    child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 250,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Color.fromRGBO(
                                                        171, 171, 171, .7),
                                                    blurRadius: 20,
                                                    offset: Offset(0, 10)),
                                              ],
                                            ),
                                            child: ListTile(
                                              onTap: () async {
                                                final provider = Provider.of<
                                                        GoogleSignInProvider>(
                                                    context,
                                                    listen: false);
                                                bool isAuth = await provider
                                                    .googleLogin();
                                                if (isAuth)
                                                  Get.toNamed('/match');
                                              },
                                              leading: const Icon(
                                                FontAwesomeIcons.google,
                                                color: PRIMARY_COLOR,
                                              ),
                                              title: Text(
                                                translate(appLanguage, context,
                                                    'loginGoogle'),
                                                style: TextStyle(
                                                    color: PRIMARY_COLOR),
                                              ),
                                            ),
                                          ),
                                        ))),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Don\'t have an account?'),
                                TextButton(
                                    onPressed: () {
                                      Get.toNamed('register');
                                    },
                                    child: Text('Register'))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return LandingPageMobile();
  }
}
