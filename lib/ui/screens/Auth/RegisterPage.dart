// import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:letstalk/core/models/LoggedUser.dart';
import 'package:letstalk/core/models/User.dart';
import 'package:letstalk/core/providers/providers.dart';
import 'package:letstalk/utils/common.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../core/controllers/LoginController.dart';
import '../../../core/internationalization/AppLanguage.dart';
import '../../../core/providers/GoogleSignInProvider.dart';
import '../../../core/services/AuthService.dart';
import '../../../core/services/UtilsService.dart';
import '../../../utils/styles.dart';
import '../../widgets/CustomButton/CustomButton.dart';

enum Genders { Male, Female, Others }

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

  ///Local variables holding the value of each registration field
  String firstname = '';
  String lastname = '';
  String email = '';
  String password = '';
  String confirmpassword = '';
  String dob = '';
  String phone = '';
  List selectedCuisines = [];
  List fetchedCuisines = [];
  var selectedCuisine = {};
  String selectedGender = 'Male';

  ///Boolean variables that are used to check if the passwords text should be visible or not
  bool showPlainPasswd = false;
  bool showPlainConfirmPasswd = false;

  String? validatePassword(String value, bool isConfirmation) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      }
      if (isConfirmation) {
        if (value != password) {
          return 'Passwords do not match';
        }
      } else {
        return null;
      }
    }
  }

  ///This variable holds the GetXController of AuthController
  late AuthController _authController = Get.put(AuthController());
  TextEditingController dobEditingController = TextEditingController();
  int currentPage = 0;
  late PageController _controller;

  DateTime selectedDate = DateTime.now();
  DateTime firstDate = DateTime(1922, 1);
  DateTime lastDate = DateTime(DateTime(DateTime.now().year).year + 100);
  late AuthProvider _authProvider;
  EdgeInsets _scrollPading = EdgeInsets.only(bottom: 0);
  @override
  void initState() {
    super.initState();
    // _authController.isLoading.toggle();
    setState(() {
      _controller = PageController(initialPage: currentPage);
    });

    Future.delayed(Duration.zero, () async {
      List temp = await getCuisines();
      setState(() {
        fetchedCuisines = temp;
      });
      if (kDebugMode) {
        print('fetched cuisines -> $fetchedCuisines');
      }
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleOnRadioChanged(var newVal) {
    setState(() {
      selectedGender = newVal;
    });
  }

  List<Widget> buildPageViewChildren(AppLanguage appLanguage) {
    List<Widget> pageViewChildren = [];
    pageViewChildren.add(
      Container(
        height: 1.sh,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              //#Firstname
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  scrollPadding: _scrollPading,
                  toolbarOptions: ToolbarOptions(
                      copy: true, paste: true, selectAll: true, cut: true),
                  onChanged: (value) {
                    if (value.isNotEmpty && value != '') {
                      setState(() {
                        firstname = value.trim();
                      });
                    }
                  },
                  validator: (val) =>
                      firstname == '' ? "Enter a valid firstname" : null,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.perm_identity_sharp),
                      hintText: translate(
                          appLanguage, context, 'placeholder.firstname'),
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
              //#Lastname
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: TextFormField(
                  scrollPadding: _scrollPading,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  toolbarOptions: ToolbarOptions(
                      copy: true, paste: true, selectAll: true, cut: true),
                  onChanged: (value) {
                    if (value.isNotEmpty && value != '') {
                      setState(() {
                        lastname = value.trim();
                      });
                    }
                  },
                  validator: (val) =>
                      lastname == '' ? "Enter a valid lastname" : null,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.perm_identity_sharp),
                      hintText: translate(
                          appLanguage, context, 'placeholder.lastname'),
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
              //#Email
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: TextFormField(
                  scrollPadding: _scrollPading,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  toolbarOptions: ToolbarOptions(
                      copy: true, paste: true, selectAll: true, cut: true),
                  onChanged: (value) {
                    if (value.isNotEmpty && value != '') {
                      setState(() {
                        email = value.trim();
                      });
                    }
                  },
                  validator: (val) => (email == '' || !email.isEmail)
                      ? "Enter a valid email"
                      : null,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.email_outlined),
                    hintText:
                        translate(appLanguage, context, 'placeholder.email'),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
              //#Phone
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: TextFormField(
                  scrollPadding: _scrollPading,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                  toolbarOptions: ToolbarOptions(
                      copy: true, paste: true, selectAll: true, cut: true),
                  onChanged: (value) {
                    if (value.isNotEmpty && value != '') {
                      setState(() {
                        phone = value.trim();
                      });
                    }
                  },
                  validator: (val) => (phone == '' || !phone.isPhoneNumber)
                      ? "Enter a valid phone number"
                      : null,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.phone_iphone_sharp),
                      hintText:
                          translate(appLanguage, context, 'placeholder.phone'),
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
              //#DOB
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: TextField(
                  controller: dobEditingController,
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: firstDate,
                      lastDate: lastDate,
                    );
                    if (date != null) {
                      String dateString = DateFormat('dd-MM-yyyy').format(date);
                      setState(() {
                        dob = dateString;
                      });
                      dobEditingController.text = dob;
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.date_range_outlined),
                      hintText:
                          translate(appLanguage, context, 'placeholder.dob'),
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
              //#Gender
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Wrap(children: [
                  Text('Gender :', style: TextStyle(color: Colors.grey)),
                  ListTile(
                    leading: Radio(
                        value: 'Male',
                        groupValue: selectedGender,
                        onChanged: (val) => _handleOnRadioChanged(val)),
                    title: Text('Male'),
                  ),
                  ListTile(
                    leading: Radio(
                        value: 'Female',
                        groupValue: selectedGender,
                        onChanged: (val) => _handleOnRadioChanged(val)),
                    title: Text('Female'),
                  ),
                  ListTile(
                    leading: Radio(
                        value: 'Other',
                        groupValue: selectedGender,
                        onChanged: (val) => _handleOnRadioChanged(val)),
                    title: Text('Other'),
                  ),
                ]),
              ),
              //#Password
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: TextFormField(
                  scrollPadding: _scrollPading,
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
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: TextFormField(
                  scrollPadding: _scrollPading,
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
                              showPlainConfirmPasswd = !showPlainConfirmPasswd;
                            });
                          },
                          icon: Icon(Icons.remove_red_eye)),
                      hintText: translate(
                          appLanguage, context, 'placeholder.confirmPassword'),
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none),
                ),
              ),
              // Container(
              //     height: .1.sh,
              //     padding: const EdgeInsets.all(10),
              //     decoration: BoxDecoration(
              //       border:
              //           Border(bottom: BorderSide(color: Colors.grey.shade200)),
              //     ),
              //     child: ExpansionTile(
              //       title: Text('Preferences'),
              //       children: fetchedCuisines
              //           .map((e) => ListTile(
              //                 title: Text(e['cuisineName']),
              //                 onTap: () {
              //                   print('selected preference -> $e');
              //                 },
              //               ))
              //           .toList(),
              //     )
              //     // DropdownSearch<
              //     //     dynamic>.multiSelection(
              //     //   mode: Mode.MENU,
              //     //   items: fetchedCuisines,
              //     //   dropdownSearchDecoration:
              //     //       InputDecoration(
              //     //           border:
              //     //               OutlineInputBorder(
              //     //                   borderRadius:
              //     //                       BorderRadius
              //     //                           .circular(
              //     //                               10)),
              //     //           alignLabelWithHint: true,
              //     //           hintText: translate(
              //     //               appLanguage,
              //     //               context,
              //     //               'text.cuisinePreferences')),
              //     //   searchFieldProps: TextFieldProps(
              //     //       controller:
              //     //           cuisineEditingController,
              //     //       decoration: const InputDecoration(
              //     //         suffixIcon: Icon(Icons.search),
              //     //       ),
              //     //       showCursor: true),
              //     //   showSearchBox: true,
              //     //   showClearButton: true,
              //     //   showSelectedItems: true,
              //     //   maxHeight: .1.sh,
              //     //   compareFn: (item, selectedItem) =>
              //     //       item['id'] == selectedItem['id'],
              //     //   scrollbarProps: ScrollbarProps(
              //     //     thickness: 7,
              //     //   ),
              //     //   clearButtonSplashRadius: 20,
              //     //   selectedItems: selectedCuisines,
              //     //   popupSelectionWidget:
              //     //       (BuildContext ctx, item,
              //     //               isSelected) =>
              //     //           (isSelected)
              //     //               ? Icon(Icons.check_circle,
              //     //                   color:
              //     //                       Colors.green[500])
              //     //               : Container(),
              //     //   onChanged: (List cuisines) {
              //     //     print(
              //     //         'selected cuisines $cuisines');
              //     //     if (cuisines.isNotEmpty) {
              //     //       setState(() {
              //     //         selectedCuisines = cuisines;
              //     //       });
              //     //     }
              //     //   },
              //     // ),
              SizedBox(height: 30),
              // #register
              Container(
                // width: .4.sw,
                height: .07.sh,
                child: Row(
                  mainAxisAlignment: currentPage == 0
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                        title: 'Choose your preference',
                        color: Colors.white,
                        bgColor: PRIMARY_COLOR,
                        onTapCallBack: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                          // Get.toNamed('/match');
                        }),
                  ],
                ),
              ),

              //     ),
            ],
          ),
        ),
      ),
    );
    pageViewChildren.add(
      Container(
          height: 1.sh,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: fetchedCuisines
                      .map((e) => ListTile(
                            title: Text(e['cuisineName']),
                            onTap: () {
                              print('selected preference -> $e');
                              if (selectedCuisine.isEmpty &&
                                  selectedCuisines.isEmpty) {
                                setState(() {
                                  selectedCuisine = e;
                                  selectedCuisines.add(e);
                                });
                              } else {
                                setState(() {
                                  selectedCuisine = {};
                                  selectedCuisines.remove(e);
                                });
                              }
                            },
                            trailing: e['id'] == selectedCuisine['id']
                                ? Icon(Icons.check_circle,
                                    color: Colors.green[500])
                                : null,
                          ))
                      .toList(),
                ),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: currentPage == 0
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                          title: 'Go back',
                          color: Colors.white,
                          bgColor: PRIMARY_COLOR,
                          onTapCallBack: () {
                            _controller.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                            // Get.toNamed('/match');
                          }),
                      Obx(
                        () => _authController.isLoading.isTrue
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                title: translate(
                                    appLanguage, context, 'button.signup'),
                                color: Colors.white,
                                bgColor: PRIMARY_COLOR,
                                onTapCallBack: () {
                                  onRegister(appLanguage);
                                  // Get.toNamed('/match');
                                }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          // DropdownSearch<
          //     dynamic>.multiSelection(
          //   mode: Mode.MENU,
          //   items: fetchedCuisines,
          //   dropdownSearchDecoration:
          //       InputDecoration(
          //           border:
          //               OutlineInputBorder(
          //                   borderRadius:
          //                       BorderRadius
          //                           .circular(
          //                               10)),
          //           alignLabelWithHint: true,
          //           hintText: translate(
          //               appLanguage,
          //               context,
          //               'text.cuisinePreferences')),
          //   searchFieldProps: TextFieldProps(
          //       controller:
          //           cuisineEditingController,
          //       decoration: const InputDecoration(
          //         suffixIcon: Icon(Icons.search),
          //       ),
          //       showCursor: true),
          //   showSearchBox: true,
          //   showClearButton: true,
          //   showSelectedItems: true,
          //   maxHeight: .1.sh,
          //   compareFn: (item, selectedItem) =>
          //       item['id'] == selectedItem['id'],
          //   scrollbarProps: ScrollbarProps(
          //     thickness: 7,
          //   ),
          //   clearButtonSplashRadius: 20,
          //   selectedItems: selectedCuisines,
          //   popupSelectionWidget:
          //       (BuildContext ctx, item,
          //               isSelected) =>
          //           (isSelected)
          //               ? Icon(Icons.check_circle,
          //                   color:
          //                       Colors.green[500])
          //               : Container(),
          //   onChanged: (List cuisines) {
          //     print(
          //         'selected cuisines $cuisines');
          //     if (cuisines.isNotEmpty) {
          //       setState(() {
          //         selectedCuisines = cuisines;
          //       });
          //     }
          //   },
          // ),

          ),
    );
    return pageViewChildren;
  }

  void onRegister(AppLanguage lang) async {
    _authController.isLoading.toggle();
    if (firstname == '' ||
        lastname == '' ||
        email == '' ||
        phone == '' ||
        dob == '' ||
        password == '' ||
        confirmpassword == '' ||
        selectedCuisine == {} ||
        selectedGender == '') {
      customAlert(
          context,
          translate(lang, context, 'alert.ErrorTitle'),
          translate(lang, context, 'alert.requiredError'),
          AlertType.error,
          AnimationType.fromTop,
          Colors.red);
      return;
    } else {
      var prefObj = {
        'id': selectedCuisine['id'],
        'cuisineName': selectedCuisine['cuisineName'],
        'cuisineCountry': selectedCuisine['cuisineCountry'],
      };
      var userObj = {
        'Firstname': firstname,
        'Lastname': lastname,
        'Email': email,
        'Phone': phone,
        'DOB': dob,
        'Password': password,
        'Gender': selectedGender,
        'FirebaseId': generateRandomString(28),
        'Preference': prefObj
      };
      print('creating user $userObj..');
      var response = await register(userObj);
      if (response['statusCode'] != 200 && response['statusCode'] != 201) {
        customAlert(
            context,
            translate(lang, context, 'alert.ErrorTitle'),
            response['message'].toString(),
            AlertType.error,
            AnimationType.fromTop,
            Colors.red);
        _authController.isLoading.toggle();
        return;
      } else {
        // dynamic userResponse = response['user'];
        // LoggedUser user = LoggedUser(
        //     id: userResponse['Id'],
        //     username: userResponse['Email'],
        //     firstname: userResponse['Firstname'],
        //     lastname: userResponse['Lastname'],
        //     imgUrl: userResponse['ImageUrl'],
        //     token: response['token']);
        // _authController.setUser(user);
        // dynamic user = response['user'];
        // print('user from response => $user');
        // user['Id'] = generateRandomString(28);
        // _authProvider.fetchFirebaseDocuments(user);
        _authController.isLoading.toggle();
        customAlert(
            context,
            translate(lang, context, 'alert.SuccessTitle'),
            translate(lang, context, 'alert.register.success'),
            AlertType.success,
            AnimationType.fromTop,
            Colors.green);
        Get.offAllNamed('login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page!.round();
        _scrollPading = EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 5);
      });
      // print('current page : $currentPage');
    });
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Obx(() => _authController.isLoading.isTrue
            ? Center(child: CircularProgressIndicator(color: Colors.purple))
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                      PRIMARY_COLOR,
                      Colors.red.shade400,
                      Colors.red.shade800
                    ])),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(171, 171, 171, .7),
                                blurRadius: 20,
                                offset: Offset(0, 10)),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.black26, fontSize: 40),
                                  ),
                                ),
                                SizedBox(
                                  height: .8.sh,
                                  child: PageView(
                                    scrollDirection: Axis.horizontal,
                                    controller: _controller,
                                    children:
                                        buildPageViewChildren(appLanguage),
                                  ),
                                ),
                                //#firstname,#lastname,#phone,#dob,#email, #password
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   child: Column(
                                //     children: [
                                //       Container(
                                //         padding: const EdgeInsets.all(10),
                                //         decoration: BoxDecoration(
                                //           border: Border(
                                //               bottom: BorderSide(
                                //                   color: Colors.grey.shade200)),
                                //         ),
                                //         child: TextFormField(
                                //           autovalidateMode: AutovalidateMode
                                //               .onUserInteraction,
                                //           toolbarOptions: ToolbarOptions(
                                //               copy: true,
                                //               paste: true,
                                //               selectAll: true,
                                //               cut: true),
                                //           onChanged: (value) {
                                //             if (value.isNotEmpty &&
                                //                 value != '') {
                                //               setState(() {
                                //                 firstname = value;
                                //               });
                                //             }
                                //           },
                                //           validator: (val) => firstname == ''
                                //               ? "Enter a valid firstname"
                                //               : null,
                                //           decoration: InputDecoration(
                                //               suffixIcon: Icon(
                                //                   Icons.perm_identity_sharp),
                                //               hintText: translate(
                                //                   appLanguage,
                                //                   context,
                                //                   'placeholder.firstname'),
                                //               hintStyle:
                                //                   TextStyle(color: Colors.grey),
                                //               border: InputBorder.none),
                                //         ),
                                //       ),
                                //       Container(
                                //         padding: const EdgeInsets.all(10),
                                //         decoration: BoxDecoration(
                                //           border: Border(
                                //               bottom: BorderSide(
                                //                   color: Colors.grey.shade200)),
                                //         ),
                                //         child: TextFormField(
                                //           autovalidateMode: AutovalidateMode
                                //               .onUserInteraction,
                                //           toolbarOptions: ToolbarOptions(
                                //               copy: true,
                                //               paste: true,
                                //               selectAll: true,
                                //               cut: true),
                                //           onChanged: (value) {
                                //             if (value.isNotEmpty &&
                                //                 value != '') {
                                //               setState(() {
                                //                 lastname = value;
                                //               });
                                //             }
                                //           },
                                //           validator: (val) => lastname == ''
                                //               ? "Enter a valid lastname"
                                //               : null,
                                //           decoration: InputDecoration(
                                //               suffixIcon: Icon(
                                //                   Icons.perm_identity_sharp),
                                //               hintText: translate(
                                //                   appLanguage,
                                //                   context,
                                //                   'placeholder.lastname'),
                                //               hintStyle:
                                //                   TextStyle(color: Colors.grey),
                                //               border: InputBorder.none),
                                //         ),
                                //       ),
                                //       Container(
                                //         padding: const EdgeInsets.all(10),
                                //         decoration: BoxDecoration(
                                //           border: Border(
                                //               bottom: BorderSide(
                                //                   color: Colors.grey.shade200)),
                                //         ),
                                //         child: TextField(
                                //           onTap: () {
                                //             Get.dialog(CalendarDatePicker(
                                //                 initialDate: DateTime(2020),
                                //                 firstDate: DateTime(2021),
                                //                 lastDate: DateTime(2022),
                                //                 onDateChanged: (DateTime d) {
                                //                   print('selected date is $d');
                                //                 }));
                                //           },
                                //           decoration: InputDecoration(
                                //               suffixIcon: Icon(
                                //                   Icons.date_range_outlined),
                                //               hintText: translate(appLanguage,
                                //                   context, 'placeholder.dob'),
                                //               hintStyle:
                                //                   TextStyle(color: Colors.grey),
                                //               border: InputBorder.none),
                                //         ),
                                //       ),
                                //       Container(
                                //         padding: const EdgeInsets.all(10),
                                //         decoration: BoxDecoration(
                                //           border: Border(
                                //               bottom: BorderSide(
                                //                   color: Colors.grey.shade200)),
                                //         ),
                                //         child: TextFormField(
                                //           autovalidateMode: AutovalidateMode
                                //               .onUserInteraction,
                                //           toolbarOptions: ToolbarOptions(
                                //               copy: true,
                                //               paste: true,
                                //               selectAll: true,
                                //               cut: true),
                                //           onChanged: (value) {
                                //             if (value.isNotEmpty &&
                                //                 value != '') {
                                //               setState(() {
                                //                 phone = value;
                                //               });
                                //             }
                                //           },
                                //           validator: (val) => (phone == '' ||
                                //                   !phone.isPhoneNumber)
                                //               ? "Enter a valid phone number"
                                //               : null,
                                //           decoration: InputDecoration(
                                //               suffixIcon: Icon(
                                //                   Icons.phone_iphone_sharp),
                                //               hintText: translate(appLanguage,
                                //                   context, 'placeholder.phone'),
                                //               hintStyle:
                                //                   TextStyle(color: Colors.grey),
                                //               border: InputBorder.none),
                                //         ),
                                //       ),
                                //       Container(
                                //         padding: const EdgeInsets.all(10),
                                //         decoration: BoxDecoration(
                                //           border: Border(
                                //               bottom: BorderSide(
                                //                   color: Colors.grey.shade200)),
                                //         ),
                                //         child: TextFormField(
                                //           autovalidateMode: AutovalidateMode
                                //               .onUserInteraction,
                                //           toolbarOptions: ToolbarOptions(
                                //               copy: true,
                                //               paste: true,
                                //               selectAll: true,
                                //               cut: true),
                                //           onChanged: (value) {
                                //             if (value.isNotEmpty &&
                                //                 value != '') {
                                //               setState(() {
                                //                 email = value;
                                //               });
                                //             }
                                //           },
                                //           validator: (val) =>
                                //               (email == '' || !email.isEmail)
                                //                   ? "Enter a valid email"
                                //                   : null,
                                //           decoration: InputDecoration(
                                //             suffixIcon:
                                //                 Icon(Icons.email_outlined),
                                //             hintText: translate(appLanguage,
                                //                 context, 'placeholder.email'),
                                //             hintStyle:
                                //                 TextStyle(color: Colors.grey),
                                //             border: InputBorder.none,
                                //           ),
                                //         ),
                                //       ),
                                //       Container(
                                //         padding: const EdgeInsets.all(10),
                                //         decoration: BoxDecoration(
                                //           border: Border(
                                //               bottom: BorderSide(
                                //                   color: Colors.grey.shade200)),
                                //         ),
                                //         child: TextFormField(
                                //           autovalidateMode: AutovalidateMode
                                //               .onUserInteraction,
                                //           obscureText: !showPlainPasswd,
                                //           onChanged: (value) {
                                //             if (value.isNotEmpty &&
                                //                 value != '') {
                                //               setState(() {
                                //                 password = value;
                                //               });
                                //             }
                                //           },
                                //           validator: (val) =>
                                //               validatePassword(val!, false),
                                //           decoration: InputDecoration(
                                //               suffixIcon: IconButton(
                                //                   onPressed: () {
                                //                     setState(() {
                                //                       showPlainPasswd =
                                //                           !showPlainPasswd;
                                //                     });
                                //                   },
                                //                   icon: Icon(
                                //                       Icons.remove_red_eye)),
                                //               hintText: translate(
                                //                   appLanguage,
                                //                   context,
                                //                   'placeholder.password'),
                                //               hintStyle:
                                //                   TextStyle(color: Colors.grey),
                                //               border: InputBorder.none),
                                //         ),
                                //       ),
                                //       Container(
                                //         padding: const EdgeInsets.all(10),
                                //         decoration: BoxDecoration(
                                //           border: Border(
                                //               bottom: BorderSide(
                                //                   color: Colors.grey.shade200)),
                                //         ),
                                //         child: TextFormField(
                                //           autovalidateMode: AutovalidateMode
                                //               .onUserInteraction,
                                //           obscureText: !showPlainConfirmPasswd,
                                //           onChanged: (value) {
                                //             if (value.isNotEmpty &&
                                //                 value != '') {
                                //               setState(() {
                                //                 confirmpassword = value;
                                //               });
                                //             }
                                //           },
                                //           validator: (val) =>
                                //               validatePassword(val!, true),
                                //           decoration: InputDecoration(
                                //               suffixIcon: IconButton(
                                //                   onPressed: () {
                                //                     setState(() {
                                //                       showPlainConfirmPasswd =
                                //                           !showPlainConfirmPasswd;
                                //                     });
                                //                   },
                                //                   icon: Icon(
                                //                       Icons.remove_red_eye)),
                                //               hintText: translate(
                                //                   appLanguage,
                                //                   context,
                                //                   'placeholder.confirmPassword'),
                                //               hintStyle: const TextStyle(
                                //                   color: Colors.grey),
                                //               border: InputBorder.none),
                                //         ),
                                //       ),
                                //       Container(
                                //           height: .1.sh,
                                //           padding: const EdgeInsets.all(10),
                                //           decoration: BoxDecoration(
                                //             border: Border(
                                //                 bottom: BorderSide(
                                //                     color:
                                //                         Colors.grey.shade200)),
                                //           ),
                                //           child: ExpansionTile(
                                //             title: Text('Preferences'),
                                //             children: fetchedCuisines
                                //                 .map((e) => ListTile(
                                //                       title: Text(
                                //                           e['cuisineName']),
                                //                       onTap: () {
                                //                         print(
                                //                             'selected preference -> $e');
                                //                       },
                                //                     ))
                                //                 .toList(),
                                //           )
                                //           // DropdownSearch<
                                //           //     dynamic>.multiSelection(
                                //           //   mode: Mode.MENU,
                                //           //   items: fetchedCuisines,
                                //           //   dropdownSearchDecoration:
                                //           //       InputDecoration(
                                //           //           border:
                                //           //               OutlineInputBorder(
                                //           //                   borderRadius:
                                //           //                       BorderRadius
                                //           //                           .circular(
                                //           //                               10)),
                                //           //           alignLabelWithHint: true,
                                //           //           hintText: translate(
                                //           //               appLanguage,
                                //           //               context,
                                //           //               'text.cuisinePreferences')),
                                //           //   searchFieldProps: TextFieldProps(
                                //           //       controller:
                                //           //           cuisineEditingController,
                                //           //       decoration: const InputDecoration(
                                //           //         suffixIcon: Icon(Icons.search),
                                //           //       ),
                                //           //       showCursor: true),
                                //           //   showSearchBox: true,
                                //           //   showClearButton: true,
                                //           //   showSelectedItems: true,
                                //           //   maxHeight: .1.sh,
                                //           //   compareFn: (item, selectedItem) =>
                                //           //       item['id'] == selectedItem['id'],
                                //           //   scrollbarProps: ScrollbarProps(
                                //           //     thickness: 7,
                                //           //   ),
                                //           //   clearButtonSplashRadius: 20,
                                //           //   selectedItems: selectedCuisines,
                                //           //   popupSelectionWidget:
                                //           //       (BuildContext ctx, item,
                                //           //               isSelected) =>
                                //           //           (isSelected)
                                //           //               ? Icon(Icons.check_circle,
                                //           //                   color:
                                //           //                       Colors.green[500])
                                //           //               : Container(),
                                //           //   onChanged: (List cuisines) {
                                //           //     print(
                                //           //         'selected cuisines $cuisines');
                                //           //     if (cuisines.isNotEmpty) {
                                //           //       setState(() {
                                //           //         selectedCuisines = cuisines;
                                //           //       });
                                //           //     }
                                //           //   },
                                //           // ),

                                //           ),
                                //     ],
                                //   ),
                                // ),

                                // SizedBox(height: 30),
                                // // #register
                                // Container(
                                //   // width: .4.sw,
                                //   height: .07.sh,
                                //   child: Row(
                                //     mainAxisAlignment: currentPage == 0
                                //         ? MainAxisAlignment.center
                                //         : MainAxisAlignment.spaceEvenly,
                                //     children: [
                                //       currentPage == 1
                                //           ? CustomButton(
                                //               title: 'Go back',
                                //               color: Colors.white,
                                //               bgColor: PRIMARY_COLOR,
                                //               onTapCallBack: () {
                                //                 _controller.previousPage(
                                //                     duration: Duration(
                                //                         milliseconds: 500),
                                //                     curve: Curves.easeIn);
                                //                 // Get.toNamed('/match');
                                //               })
                                //           : Visibility(
                                //               visible: false,
                                //               child: Container()),
                                //       CustomButton(
                                //           title: currentPage == 1
                                //               ? translate(appLanguage, context,
                                //                   'button.signup')
                                //               : 'Choose your preference',
                                //           color: Colors.white,
                                //           bgColor: PRIMARY_COLOR,
                                //           onTapCallBack: () {
                                //             currentPage == 0
                                //                 ? _controller.nextPage(
                                //                     duration: Duration(
                                //                         milliseconds: 500),
                                //                     curve: Curves.easeIn)
                                //                 : onRegister(appLanguage);
                                //             // Get.toNamed('/match');
                                //           }),
                                //     ],
                                //   ),
                                // ),

                                // SizedBox(height: 30),

                                // #login SNS
                                // Flexible(
                                //   child: Text(
                                //     translate(
                                //         appLanguage, context, 'text.orWith'),
                                //     style: TextStyle(
                                //         color: Colors.grey,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // SizedBox(height: .015.sh),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: MouseRegion(
                                //         cursor: SystemMouseCursors.click,
                                //         child: Container(
                                //           margin: EdgeInsets.only(top: .01.sh),
                                //           height: .05.sh,
                                //           child: ElevatedButton.icon(
                                //               style: ButtonStyle(
                                //                   backgroundColor:
                                //                       MaterialStateProperty.all<
                                //                           Color>(Colors.white)),
                                //               onPressed: () async {
                                //                 final provider = Provider.of<
                                //                         GoogleSignInProvider>(
                                //                     context,
                                //                     listen: false);
                                //                 bool isAuth =
                                //                     await provider.googleLogin();
                                //                 if (isAuth) Get.toNamed('/match');
                                //               },
                                //               icon: FaIcon(
                                //                   FontAwesomeIcons.google,
                                //                   color: PRIMARY_COLOR),
                                //               label: Text(
                                //                 translate(
                                //                   appLanguage, context, 'placeholder.lastname'),
                                //                 style: TextStyle(
                                //                     color: PRIMARY_COLOR,
                                //                     fontSize: 8),
                                //               )),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )));
  }
}
