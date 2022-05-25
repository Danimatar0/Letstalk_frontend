import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:letstalk/core/controllers/LoginController.dart';
import 'package:letstalk/core/internationalization/AppLanguage.dart';
import 'package:letstalk/core/models/LoggedUser.dart';
import 'package:letstalk/core/models/Preference.dart';
import 'package:letstalk/core/models/StorageService.dart';
import 'package:letstalk/core/services/AuthService.dart';
import 'package:letstalk/core/services/UtilsService.dart';
import 'package:letstalk/ui/widgets/CustomButton/CustomButton.dart';
import 'package:letstalk/utils/common.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/AppConstants.dart';
import '../../../core/constants/ColorConstants.dart';
import '../../../core/constants/FirestoreConstants.dart';
import '../../../core/models/UserChat.dart';
import '../../../core/providers/SettingProvider.dart';
import '../../../utils/styles.dart';
import '../../widgets/AppBar/CustomAppBar.dart';
import '../../widgets/Drawer/drawer.dart';
import '../../widgets/LoadingView/LoadingView.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _advancedDrawerController = AdvancedDrawerController();

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _advancedDrawerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          withTrailingAction: true,
          withBackButton: false,
          title: 'Profile',
          trailingActionWidgets: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Get.toNamed('/settings');
                _advancedDrawerController.hideDrawer();
              },
            ),
          ],
        ),
        body: ProfilePageState(),
      ),
    );
  }
}

class ProfilePageState extends StatefulWidget {
  @override
  State createState() => ProfilePageStateState();
}

class ProfilePageStateState extends State<ProfilePageState> {
  TextEditingController? controllerFirstname;
  TextEditingController? controllerLastname;
  TextEditingController? controllerAboutMe;
  TextEditingController? controllerPhone;
  TextEditingController? controllerGender;
  TextEditingController? controllerDob;

  DateTime selectedDate = DateTime.now();
  DateTime firstDate = DateTime(1922, 1);
  DateTime lastDate = DateTime(DateTime(DateTime.now().year).year + 100);
  static const EdgeInsets _scrollPading = EdgeInsets.only(bottom: 0);

  int id = -1;
  String firstname = '';
  String lastname = '';
  String aboutMe = '';
  String photoUrl = '';
  String phone = '';
  String gender = '';
  String nickname = '';
  String firebaseId = "";
  String dob = "";
  String email = "";
  PhoneNumber phoneNumber =
      PhoneNumber(dialCode: '961', phoneNumber: '71274441', isoCode: '');
  List selectedPreferences = [];
  String dialCode = "";
  bool isLoading = false;
  File? avatarImageFile;
  late SettingProvider settingProvider;

  final FocusNode focusNodeFirstname = FocusNode();
  final FocusNode focusNodeLastname = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();
  final FocusNode focusNodePhone = FocusNode();

  final AuthController _authController = Get.put(AuthController());
  LoggedUser? currentUser;
  late SharedPreferences prefs;
  String authProvider = "";

  List fetchedCuisines = [];
  bool showPrefs = false;

  final ScrollController listScrollController = ScrollController();

  void scrollToBottom() {
    listScrollController.animateTo(
      listScrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void onUpdate(AppLanguage lang) async {
    if (firstname == '' ||
        lastname == '' ||
        aboutMe == '' ||
        phone == '' ||
        gender == '' ||
        dob == '' ||
        selectedPreferences == []) {
      debugPrint("firstname $firstname");
      debugPrint("lastname $lastname");
      debugPrint("email $email");
      debugPrint("phone $phone");
      debugPrint("dob $dob");
      debugPrint("selectedGender $gender");
      debugPrint("selectedCuisine $selectedPreferences");
      debugPrint("location ${currentUser?.longitude} ${currentUser?.latitude}");
      customAlert(
          context,
          translate(lang, context, 'alert.ErrorTitle'),
          translate(lang, context, 'alert.requiredError'),
          AlertType.error,
          AnimationType.fromTop,
          Colors.red);
      return;
    }
    print('info are valid');

    var user = photoUrl == ''
        ? {
            'Firstname': firstname,
            'Lastname': lastname,
            'Phone': dialCode + phone,
            'Email': email,
            'Gender': gender,
            'Dob': dob,
            'Preferences': selectedPreferences,
            'FirebaseId': firebaseId,
            'Location': {
              'Longitude': currentUser?.longitude,
              'Latitude': currentUser?.latitude
            }
          }
        : {
            'Firstname': firstname,
            'Lastname': lastname,
            'Image': photoUrl,
            'Phone': phone,
            'Email': email,
            'Gender': gender,
            'Dob': dob,
            'Preferences': selectedPreferences,
            'FirebaseId': firebaseId,
            'Location': {
              'Longitude': currentUser?.longitude,
              'Latitude': currentUser?.latitude
            }
          };
    print('user -> $user');
    var updatedUser = await updateUser(user, currentUser!.token!);
    print('updatedUser -> $updatedUser');
  }

  @override
  void initState() {
    super.initState();
    settingProvider = context.read<SettingProvider>();
    Future.delayed(Duration.zero, () async {
      List temp = await getCuisines();
      setState(() {
        fetchedCuisines = temp;
      });
      bool scrollDown = Get.arguments != null && Get.arguments[0] != null
          ? Get.arguments[0]
          : false;
      if (scrollDown) {
        scrollToBottom();
      }
    });
    // print("Phoneeee $phone");
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    print(_authController.user);

    setState(() {
      authProvider = prefs.getString("provider") ?? "";
      currentUser = LoggedUser.fromJson(_authController.user);
      id = currentUser!.id;
      firebaseId = authProvider == "google"
          ? settingProvider.getPref(FirestoreConstants.id) ?? ""
          : currentUser!.FirebaseId ?? "";
      nickname = settingProvider.getPref(FirestoreConstants.nickname) ?? "";
    });
    // print("nicknameee $nickname");
    setState(() {
      aboutMe = settingProvider.getPref(FirestoreConstants.aboutMe) ?? "";
      photoUrl = authProvider == "google"
          ? settingProvider.getPref(FirestoreConstants.photoUrl) ?? ""
          : currentUser!.imgUrl;
      firstname = authProvider == "google"
          ? nickname.split(" ").isNotEmpty
              ? nickname.split(" ")[0]
              : nickname
          : currentUser!.firstname;
      lastname = authProvider == "google"
          ? nickname.split(" ").isNotEmpty
              ? nickname.split(" ")[1]
              : ""
          : currentUser!.lastname;
      phone = currentUser!.phone ?? "";
      gender = currentUser!.gender ?? "";
      dob = currentUser!.dob ?? "";
      selectedPreferences = currentUser!.preferences;
    });
    // print(phone);
    controllerFirstname = TextEditingController(text: firstname);
    controllerLastname = TextEditingController(text: lastname);
    controllerAboutMe = TextEditingController(text: aboutMe);
    controllerPhone = TextEditingController(text: phone);
    controllerDob = TextEditingController(text: dob);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        photoUrl = pickedFile!.path;
        avatarImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future<void> takePicture(ImagePicker picker) async {
    List<int> uploadedContent = [];
    Uint8List? byteArray;
    try {
      final XFile? capture = await picker.pickImage(source: ImageSource.camera);
      if (capture == null) return;
      // final file = await saveImageLocally(capture);
      List<String> nameArray = capture.path.split("cache/");
      String ext = nameArray[1].split('.')[nameArray[1].split('.').length - 1];
      byteArray = await capture.readAsBytes();
      uploadedContent = List<int>.from(byteArray);
    } catch (e) {
      print(e);
    }
  }

  void handleUploadFile() async {
    ImagePicker picker = ImagePicker();
    String fileName = firebaseId;

    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    InkWell(
                      splashColor: PRIMARY_COLOR,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.camera,
                              color: Colors.purple,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: .05.sw),
                            child: Text('Camera',
                                style: TextStyle(color: Colors.purple)),
                          )
                        ],
                      ),
                      onTap: () {
                        takePicture(picker);
                      },
                    ),
                    InkWell(
                      splashColor: PRIMARY_COLOR,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.image,
                              color: Colors.purple,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: .05.sw),
                            child: Text('Gallery',
                                style: TextStyle(color: Colors.purple)),
                          )
                        ],
                      ),
                      onTap: () async {
                        XFile? pickedFile = await picker
                            .pickImage(source: ImageSource.gallery)
                            .catchError((err) {
                          Fluttertoast.showToast(msg: err.toString());
                        });
                        Storage storageService = Storage();
                        storageService.uploadFile(pickedFile!.path, fileName);
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  bool isItemSelected(id, List list, Type className) {
    bool selected = false;
    for (int i = 0; i < list.length; i++) {
      if ((list[i] as Preference).id == id) {
        selected = true;
        break;
      }
    }
    return selected;
  }

  Future uploadFile() async {
    String fileName = firebaseId;
    UploadTask uploadTask =
        settingProvider.uploadFile(avatarImageFile!, fileName);
    uploadTask.then((p0) => print(p0));
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      UserChat updateInfo = UserChat(
        id: firebaseId,
        photoUrl: photoUrl,
        nickname: nickname,
        aboutMe: aboutMe,
      );
      settingProvider
          .updateDataFirestore(FirestoreConstants.pathUserCollection,
              firebaseId, updateInfo.toJson())
          .then((data) async {
        await settingProvider.setPref(FirestoreConstants.photoUrl, photoUrl);
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: "Upload success");
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void handleUpdateData() {
    focusNodeFirstname.unfocus();
    focusNodeLastname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });
    UserChat updateInfo = UserChat(
      id: firebaseId,
      photoUrl: photoUrl,
      nickname: nickname,
      aboutMe: aboutMe,
    );
    settingProvider
        .updateDataFirestore(FirestoreConstants.pathUserCollection, firebaseId,
            updateInfo.toJson())
        .then((data) async {
      await settingProvider.setPref(FirestoreConstants.nickname, nickname);
      await settingProvider.setPref(FirestoreConstants.aboutMe, aboutMe);
      await settingProvider.setPref(FirestoreConstants.photoUrl, photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void _handleOnRadioChanged(var newVal) {
    setState(() {
      gender = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    bool scrollToBottom = Get.arguments != null && Get.arguments[0] != null
        ? Get.arguments[0]
        : false;
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          child: ListView(
            controller: listScrollController,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Avatar
              Container(
                  margin: EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      photoUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                                errorBuilder: (context, object, stackTrace) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: 90,
                                    color: ColorConstants.greyColor,
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: ColorConstants.themeColor,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 90,
                              color: ColorConstants.greyColor,
                            ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // getImage();
                              handleUploadFile();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green[400],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 4, color: Colors.white)),
                              height: 40,
                              width: 40,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ))
                    ],
                  )),

              // Input
              Column(
                children: <Widget>[
                  // Firstname
                  Container(
                    child: Text(
                      'Firstname',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: ColorConstants.primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'John',
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: ColorConstants.greyColor),
                        ),
                        controller: controllerFirstname,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: focusNodeFirstname,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30, right: 30),
                  ),
                  // Lastname
                  Container(
                    child: Text(
                      'Lastname',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: ColorConstants.primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Doe',
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: ColorConstants.greyColor),
                        ),
                        controller: controllerLastname,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: focusNodeLastname,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30, right: 30),
                  ),
                  // Phone number
                  Container(
                    child: Text(
                      'Phone number',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10, bottom: 5, top: 10),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: ColorConstants.primaryColor),
                      child: InternationalPhoneNumberInput(
                        keyboardAction: TextInputAction.done,
                        textFieldController: controllerPhone,
                        onInputChanged: (PhoneNumber number) {
                          setState(() {
                            dialCode = number.dialCode ?? "";
                            phone = number.phoneNumber ?? "";
                          });
                        },
                        // onInputValidated: (bool value) {
                        //   print(value);
                        // },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        // autoValidateMode: AutovalidateMode.onUserInteraction,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        inputDecoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          hintText: '+1 123 456 789',
                          hintStyle: TextStyle(color: ColorConstants.greyColor),
                        ),
                        initialValue: PhoneNumber(
                          dialCode: '+961',
                          phoneNumber: phone,
                          isoCode: 'LB',
                        ),
                        // textFieldController: controllerPhone,

                        validator: (val) =>
                            (phone == '' || !phone.isPhoneNumber)
                                ? "Enter a valid phone number"
                                : null,
                        formatInput: true,
                        keyboardType: TextInputType.phone,
                        hintText: phone,
                        // inputBorder: OutlineInputBorder(),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                          setState(() {
                            dialCode = number.dialCode ?? "";
                            phone = "${number.phoneNumber!}";
                          });
                          print('new phone $phone');
                        },
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30, right: 30),
                  ),
                  // About me
                  Container(
                    child: Text(
                      'About me',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: ColorConstants.primaryColor),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Fun, like travel and play PES...',
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: ColorConstants.greyColor),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 30, right: 30),
                  ),

                  //#DOB
                  Container(
                    child: Text(
                      'Date of birth',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: TextField(
                      controller: controllerDob,
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: firstDate,
                          lastDate: lastDate,
                        );
                        if (date != null) {
                          String dateString =
                              DateFormat('dd-MM-yyyy').format(date);
                          setState(() {
                            dob = dateString;
                          });
                          controllerDob!.text = dob;
                        }
                      },
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.date_range_outlined),
                          hintText: translate(
                              appLanguage, context, 'placeholder.dob'),
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                  //#Gender
                  Container(
                    child: Text(
                      'Gender',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Wrap(children: [
                      ListTile(
                        leading: Radio(
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (val) => _handleOnRadioChanged(val)),
                        title: Text('Male'),
                      ),
                      ListTile(
                        leading: Radio(
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (val) => _handleOnRadioChanged(val)),
                        title: Text('Female'),
                      ),
                      ListTile(
                        leading: Radio(
                            value: 'Other',
                            groupValue: gender,
                            onChanged: (val) => _handleOnRadioChanged(val)),
                        title: Text('Other'),
                      ),
                    ]),
                  ),
                  //#Password
                  Container(
                    child: Text(
                      'Password',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: TextFormField(
                      scrollPadding: _scrollPading,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: true,
                      enabled: false,
                      initialValue: 'dadsadadhsa312e',
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.remove_red_eye),
                          hintText: translate(
                              appLanguage, context, 'placeholder.password'),
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                  // Preferences
                  Container(
                    child: Text(
                      'Preferences',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.primaryColor),
                    ),
                    margin: EdgeInsets.only(left: 10, top: 30, bottom: 5),
                  ),
                  !showPrefs
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              showPrefs = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: TextFormField(
                              scrollPadding: _scrollPading,
                              enabled: false,
                              initialValue: currentUser != null
                                  ? currentUser!.preferences.isNotEmpty
                                      ? selectedPreferences.first.cuisineName
                                          .toString()
                                      : ''
                                  : '',
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.food_bank_outlined),
                                  hintText: 'Preferences',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                          ),
                        )
                      : Container(
                          height: .2.sh,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey.shade200)),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: fetchedCuisines
                                      .map((e) => ListTile(
                                            title: Text(e['cuisineName']),
                                            onTap: () {
                                              print(
                                                  'selected preference -> $e');
                                              if (selectedPreferences.isEmpty) {
                                                Preference pref =
                                                    Preference.fromMap(e);
                                                setState(() {
                                                  selectedPreferences.add(pref);
                                                });
                                              } else {
                                                bool isPresent = false;
                                                selectedPreferences
                                                    .forEach((element) {
                                                  var itemId =
                                                      (element as Preference)
                                                          .id;
                                                  var incomingId = e['id'];
                                                  if (itemId == incomingId) {
                                                    isPresent = true;
                                                  }
                                                });
                                                print(
                                                    'isPresent ?? $isPresent');
                                                if (isPresent) {
                                                  setState(() {
                                                    selectedPreferences
                                                        .removeWhere((element) {
                                                      var itemIdR = (element
                                                              as Preference)
                                                          .id;
                                                      var incomingIdR = e['id'];
                                                      return itemIdR ==
                                                          incomingIdR;
                                                    });
                                                  });
                                                } else {
                                                  Preference newPref =
                                                      Preference.fromMap(e);
                                                  setState(() {
                                                    selectedPreferences
                                                        .add(newPref);
                                                  });
                                                }
                                              }
                                              print(
                                                  'new prefsss $selectedPreferences');
                                            },
                                            trailing: isItemSelected(
                                                    e['id'],
                                                    selectedPreferences,
                                                    Preference)
                                                ? Icon(Icons.check_circle,
                                                    color: Colors.green[500])
                                                : null,
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          )),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),

              // Button
              Container(
                child: TextButton(
                  onPressed: () => onUpdate(appLanguage),
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        ColorConstants.primaryColor),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.fromLTRB(30, 10, 30, 10),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(top: 50, bottom: 50),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15, right: 15),
        ),

        // Loading
        Positioned(child: isLoading ? LoadingView() : SizedBox.shrink()),
      ],
    );
  }
}
