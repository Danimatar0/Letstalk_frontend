import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:letstalk/core/constants/constants.dart';
import 'package:letstalk/core/models/LoggedUser.dart';
import 'package:letstalk/core/models/Preference.dart';
import 'package:letstalk/core/providers/AuthProvider.dart';
import 'package:letstalk/core/services/AuthService.dart';
import 'package:letstalk/core/services/LocationService.dart';
import 'package:provider/src/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String username = '';
  String password = '';
  bool showPassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var location = {};
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void storeNotificationToken(String uid) async {
    print("in ma333 $uid");
    // FirebaseMessaging.instance.getToken();
    //Checking my own token in users table in firestore
    // FirebaseFirestore.instance
    //     .collection(FirestoreConstants.pathUserCollection)
    //     // .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .doc(uid)
    //     .set({'pushToken': token}, SetOptions(merge: true));
    // debugPrint("Successfully stored token $token");

    firebaseMessaging.getToken().then((token) {
      debugPrint('push token: $token');
      if (token != null) {
        FirebaseFirestore.instance
            .collection(FirestoreConstants.pathUserCollection)
            .doc(uid)
            .set({'pushToken': token}, SetOptions(merge: true));
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void requestLocation(BuildContext ctx) async {
    print('calling location');
    Position pos = await determinePosition(ctx);

    if (pos != null) {
      List marks =
          await convertCoordinatesToAddresses(pos.longitude, pos.latitude);
      Placemark mark = marks[3];
      setState(() {
        location = {
          'Longitude': pos.longitude,
          'Latitude': pos.latitude,
          'Country': mark.country,
          'CountryCode': mark.isoCountryCode,
          'PostalCode': mark.postalCode
        };
      });
      debugPrint("location is $location");
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      String usernameArgs = Get.arguments != null ? Get.arguments[1] : '';
      if (usernameArgs != '') emailController.text = usernameArgs;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool autofillEmail = Get.arguments != null ? Get.arguments[0] : false;

    var appLanguage = Provider.of<AppLanguage>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final _authController = Get.put(AuthController());
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[
        // Color(0xFF4285F4),
        // Color(0xFF34A853),
        Color(0xFFFBBC05),
        Color(0xFFea4335),
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    bool isEmailFocused = false;
    bool isPasswordFocused = false;
    return Scaffold(
      resizeToAvoidBottomInset:
          (isEmailFocused || isPasswordFocused) ? true : false,
      body: Obx(() => _authController.isLoading.isTrue
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
                        padding: const EdgeInsets.all(20),
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
                                      textInputAction: TextInputAction.next,
                                      controller: emailController,
                                      onTap: () {
                                        setState(() {
                                          isEmailFocused = true;
                                          isPasswordFocused = false;
                                        });
                                      },
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            username = value;
                                          });
                                          // print('us on change $username');
                                        }
                                      },
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
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          isEmailFocused = false;
                                          isPasswordFocused = true;
                                        });
                                      },
                                      controller: passwordController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      obscureText: !showPassword,
                                      onChanged: (value) {
                                        if (value.isNotEmpty && value != '') {
                                          setState(() {
                                            password = value;
                                          });
                                          // print('pass on change $password');
                                        }
                                      },
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  showPassword = !showPassword;
                                                });
                                                print(showPassword);
                                              },
                                              icon: Icon(Icons.remove_red_eye)),
                                          hintText: translate(appLanguage,
                                              context, 'placeholder.password'),
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
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
                                  onTapCallBack: () async {
                                    requestLocation(context);

                                    _authController.isLoading.toggle();
                                    final provider = Provider.of<AuthProvider>(
                                        context,
                                        listen: false);
                                    var req = {
                                      'Email': username == ''
                                          ? emailController.text == ''
                                              ? ''
                                              : emailController.text.trim()
                                          : username.trim(),
                                      'Password': password.trim()
                                    };
                                    var response = await login(req);
                                    if (response == {} ||
                                        response['statusCode'] == 401) {
                                      _authController.isLoading.toggle();
                                      customAlert(
                                          context,
                                          translate(appLanguage, context,
                                              'alert.ErrorTitle'),
                                          'Invalid username or password',
                                          AlertType.error,
                                          AnimationType.fromTop,
                                          Colors.red);
                                      return;
                                    }
                                    String token = response['token'] ?? '';
                                    var userRes = response['user'];
                                    // print('userRes $userRes');
                                    List<Preference> userPrefs = [];
                                    if (userRes['preferences'] != null &&
                                        userRes['preferences'] != []) {
                                      (userRes['preferences'] as List)
                                          .forEach((pref) {
                                        Preference userPref = new Preference(
                                            id: pref['id'],
                                            cuisineCountry:
                                                pref['cuisineCountry'],
                                            cuisineName: pref['cuisineName']);
                                        userPrefs.add(userPref);
                                      });
                                    }
                                    print(
                                        "locationnn mff" + location.toString());
                                    LoggedUser loggedUser = LoggedUser(
                                        id: userRes['id'] ?? -1,
                                        username: userRes['email'] ?? '',
                                        firstname: userRes['firstname'] ?? '',
                                        lastname: userRes['lastname'] ?? '',
                                        imgUrl: userRes['image'] ?? '',
                                        phone: userRes['phoneNumber'] ?? '',
                                        dob: userRes['dob'] ?? '',
                                        gender: userRes['gender'] ?? '',
                                        token: token,
                                        FirebaseId: userRes['firebaseId'] ?? '',
                                        preferences: userPrefs,
                                        longitude: location['Longitude'],
                                        latitude: location['Latitude']);
                                    _authController.setUser(loggedUser);
                                    // _authController.isLoading.toggle();
                                    // userRes['id'] = generateRandomString(28);
                                    // print(userRes['id']);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('isAuthenticated', true);
                                    prefs.setString("provider", "local");
                                    prefs.setDouble("range", 80);
                                    _authController.isLoading.toggle();

                                    Future.delayed(Duration.zero, () {
                                      provider.initializeUserFirebase(userRes);
                                      String userId =
                                          FirebaseAuth.instance.currentUser !=
                                                  null
                                              ? FirebaseAuth
                                                  .instance.currentUser!.uid
                                              : "";
                                      print("userid: $userId");
                                      if (userId != "")
                                        storeNotificationToken(userId);
                                    }).then((value) => Get.toNamed(
                                        loggedUser.imgUrl == ''
                                            ? '/profile'
                                            : '/match'));
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
                                                requestLocation(context);
                                                final provider =
                                                    Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false);
                                                bool isAuth =
                                                    await provider.handleSignIn(
                                                        location, context);
                                                if (isAuth)
                                                  Get.toNamed('/profile');
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
