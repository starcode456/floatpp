

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:float/app_utils/static_info.dart';
import 'package:float/constants.dart';
import 'package:float/models/campus_model.dart';
import 'package:float/models/campus_request.dart';
import 'package:float/models/user.dart';
import 'package:float/models/user_model.dart';
import 'package:float/models/user_shelf.dart';
import 'package:float/models_services/campus_helper.dart';
import 'package:float/pages/onboarding_page.dart';
import 'package:float/pages/profile/campus_search.dart';
import 'package:float/pages/resources/edit_things.dart';
import 'package:float/pages/sign_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user.dart';
import '../forgot_password_page.dart';
import '../notifications_page.dart';


var iscomplete = true;

class AccountPage extends StatefulWidget {
  AccountPage({Key key, this.doc}) : super(key: key);

  final DocumentSnapshot doc;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Map<String, String> account = {"fullname": "", "uni": ""};
  String defaultUni = "Add University/College";
  String uni = '';
  final picker = ImagePicker();
  Reference storageReference = FirebaseStorage.instance.ref();
  String profileUrl;
  File _image;
  Profile profile;
  UserModel userModel;
  
 
  bool isLoading = true;
  Future getImage(ImageSource source) async {
    
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      addImageToFirebase();
    }
  }

  void addImageToFirebase() async {
    try {
      User user = FirebaseAuth.instance.currentUser;
      print(user.uid);
      Reference ref = storageReference.child("profilepictures/");

      UploadTask storageUploadTask =
          ref.child("${user.uid}.jpg").putFile(_image);
      await storageUploadTask.whenComplete(() async {
        final String url = await ref.getDownloadURL();
        print("The download URL is " + url);
      });

      // if (await storageUploadTask.whenComplete(() => null)) {
      // } else if (storageUploadTask.isInProgress) {
      //   storageUploadTask.events.listen((event) {
      //     double percentage = 100 *
      //         (event.snapshot.bytesTransferred.toDouble() /
      //             event.snapshot.totalByteCount.toDouble());
      //     print("THe percentage " + percentage.toString());

      TaskSnapshot storageTaskSnapshot =
          await storageUploadTask.whenComplete(() async {
        //       final String url = await ref.getDownloadURL();
        // print("The download URL is " + url);
      });

      userModel.profilepic = await storageTaskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilepic': userModel.profilepic});

      StaticInfo.userModel.profilepic = userModel.profilepic;
      Fluttertoast.showToast(msg: 'Profile picture updated succesfuly');

      setState(() {});
      //Here you can get the download URL when the task has been completed.
      print("Download URL " + profileUrl.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error updating profile picture');
    }
  }

  void showCupertinoSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Change profile photo',
            style: GoogleFonts.lato(
              fontSize: 16,
              color: Colors.black,
            )),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              'Take photo',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, 'One');
              getImage(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Choose from gallery',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, 'Two');
              getImage(ImageSource.gallery);
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            'Cancel',
            style: GoogleFonts.lato(),
          ),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
  }

  TextStyle listTextStyle = GoogleFonts.lato(
      color: Color.fromRGBO(176, 178, 190, 1),
      fontWeight: FontWeight.w700,
      fontSize: 18);

  @override
  void initState() {
    super.initState();
    _getAccount();
    getAllRequest();
  }

  void printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  void _getAccount() async {
    
    print('called');
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot ds) {
      printWrapped(ds.data().toString());
      
      setState(() {
        userModel = UserModel.fromFirestore(ds);
        
        profile = Profile.fromMap(ds.data());
        uni = profile.uni ?? '';
        isLoading = false;
        iscomplete = false;
      });

      //print(ds.data);
      print(ds.data()['uni']);
      print(profile.uni);

      if (ds.data()['uni'] != null && ds.data()['uni'] != '') {
        uni = ds.data()['uni'] ?? '';
        print(ds.data());
      }

      setState(() {
        account = {
          "fullname": ds.data()['fullname'],
          "uni": uni,
        };
      });
    });
  }

  String getUsername(String username) {
    print(username);
    
    if (username != null) {
      List<String> usernames = username.split(' ');
      return toBeginningOfSentenceCase(usernames.first);
    }
    return '';
  }

  int currentTabIndex = 0;
  getAllRequest() async {
    List<CampusRequestModel> myRequests =
        await CampusHelper().getCurrentUserRequests();
    if (myRequests.length > 0) {
      acceptCampusRequestModal(
          context: context, campusRequestModel: myRequests.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              children: <Widget>[
                //Divider(),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Edit
                      currentTabIndex == 0
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: InkWell(
                                onTap: () => Get.to(() => EditThings(
                                      userModel: userModel,
                                    )).then((value) => _getAccount()),
                                child: Text("Edit",
                                    style: GoogleFonts.lato(
                                        color: const Color(0xff32a8ff),
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 17.0)),
                              ),
                            )
                          : Container(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      child: isLoading ? CircularProgressIndicator() : Text(''),
                      backgroundImage: userModel?.profilepic != null
                          ? NetworkImage(
                              userModel?.profilepic,
                            )
                          : AssetImage(profileAssets + 'profile.png'),
                    ),
                  ],
                ),
                Container(
                  //height: 200,

                  child: Column(
                    children: <Widget>[
                      Text(
                        'Hello, ${getUsername(userModel?.fullname)}', //+ //,
                        style: GoogleFonts.lato(
                            color: Color(0xFF4A4A4A),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            fontSize: 28),
                        textAlign: TextAlign.center,
                      ),
                      //Padding(padding: EdgeInsets.only(top: 10)),
                      InkWell(
                        child: Text(
                          uni.isEmpty ? defaultUni : uni,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              color: Color(0xff32a8ff),
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          Get.to(EditThings(
                            userModel: userModel,
                          )).then((value) => _getAccount());
                        },
                      ),
                      SizedBox(
                        height: 42,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentTabIndex = 0;
                              });
                            },
                            child: Container(
                                width: 45,
                                height: 45,
                                child: Center(
                                  child: Image.asset(
                                    'assets/icon/friends.png',
                                    width: 26,
                                    height: 21,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: currentTabIndex == 0
                                        ? Color(0xff32c5ff)
                                        : Color(0xffb0b2be),
                                    shape: BoxShape.circle)),
                          ),
                          SizedBox(
                            width: 71,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentTabIndex = 1;
                              });
                            },
                            child: Container(
                                width: 45,
                                height: 45,
                                child: Center(
                                  child: Image.asset(
                                    'assets/icon/award.png',
                                    width: 21,
                                    height: 26,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: currentTabIndex == 1
                                        ? Color(0xffcc51ef)
                                        : Color(0xffb0b2be),
                                    shape: BoxShape.circle)),
                          ),
                          SizedBox(
                            width: 71,
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  currentTabIndex = 2;
                                });
                              },
                              child: Container(
                                  width: 45,
                                  height: 45,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/icon/settings.png',
                                      width: 26,
                                      height: 21,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: currentTabIndex == 2
                                          ? Color(0xff606060)
                                          : Color(0xffb0b2be),
                                      shape: BoxShape.circle)))
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.057,
                      ),
                      IndexedStack(
                        index: currentTabIndex,
                        children: [
                          CampusTab(),
                          ScoresTab(),
                          SettingsTab(),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future acceptCampusRequestModal(
      {BuildContext context, CampusRequestModel campusRequestModel}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: new Container(
            // height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ),
                        onPressed: () => Navigator.pop(context)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.transparent,
                          // backgroundImage: AssetImage(
                          //     essaytennisAssets + 'story.png'),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage:
                                campusRequestModel.requesterImage != '' &&
                                        campusRequestModel.requesterImage !=
                                            null
                                    ? NetworkImage(
                                        campusRequestModel.requesterImage)
                                    : AssetImage(profileAssets + 'profile.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: Text(
                            campusRequestModel.requesterName ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(64, 64, 64, 1),
                                fontSize: 20),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 16),
                      child: Text(
                        'Accept Campus?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            color: Color.fromRGBO(64, 64, 64, 1),
                            fontSize: 32),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 61,
                      ),
                      child: Text(
                        'Once you accept, you\nwill be added to their campus',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    CampusUser campusUser = CampusUser(
                      userId: FirebaseAuth.instance.currentUser.uid,
                      userImage: StaticInfo.userModel.profilepic,
                      userName: StaticInfo.userModel.fullname,
                    );
                    await CampusHelper()
                        .acceptCampusRequest(campusRequestModel, campusUser);
                  },
                  child: Container(
                    height: 97,
                    decoration: BoxDecoration(
                      color: Color(0xff3d97eb),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(42),
                          topRight: Radius.circular(42)),
                    ),
                    child: Center(
                      child: Text(
                        'Accept Request',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

TextStyle listTextStyle = GoogleFonts.lato(
    color: Color.fromRGBO(176, 178, 190, 1),
    fontWeight: FontWeight.w700,
    fontSize: 18);
TextStyle listTextStyle_del = GoogleFonts.lato(
    color: del_acc_color, fontWeight: FontWeight.w700, fontSize: 18);

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text("Settings",
                  style: GoogleFonts.lato(
                      color: const Color(0xff4a4a4a),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 28.0)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Container(
                  height: 22,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        profileAssets + 'notification.png',
                        height: 23,
                        width: 20,
                        //color: Color(0xFF22A0C3),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text("Notifications & Reminders", style: listTextStyle),
                    ],
                  ),
                ),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new NotificationsPage()));
                },
              ),
              Divider(),
              new ListTile(
                leading: Container(
                  height: 24,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        profileAssets + 'lock.png',
                        height: 22,
                        width: 17,
                        //color: Color(0xFF22A0C3),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text(" Change Password", style: listTextStyle),
                    ],
                  ),
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new ResetPasswordPage(),
                    ),
                  );
                },
              ),
              Divider(),
              new ListTile(
                leading: Container(
                  height: 24,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Image.asset(
                          profileAssets + 'exit.png',
                          width: 22,
                          height: 17,
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Text("Log Out", style: listTextStyle),
                    ],
                  ),
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new OnbaordingPage()));
                },
              ),
              new Container(
                padding: EdgeInsets.only(top: 20, bottom: 20, left: 16),
                alignment: Alignment.centerLeft,
                child: new Text("SOME MORE THINGS",
                    style: GoogleFonts.lato(
                        color: Colors.grey[400],
                        fontSize: 13.8,
                        fontWeight: FontWeight.w700)),
              ),
              new ListTile(
                leading: Container(
                  height: 24,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        profileAssets + 'heart.png',
                        width: 21,
                        height: 18,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Spread the sauce", style: listTextStyle),
                    ],
                  ),
                ),
                onTap: () {
                  Share.share(
                      "I'm managing my essays via Float. Join me: https://thefloatapp.com");
                },
              ),
              Divider(),
              new ListTile(
                leading: Container(
                  height: 22,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        profileAssets + 'privacypolicy.png',
                        width: 23,
                        height: 12,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Privacy Policy", style: listTextStyle),
                    ],
                  ),
                ),
                onTap: () {
                  launch("https://www.thefloatapp.com/privacy-policy");
                },
              ),
              Divider(),
              new ListTile(
                leading: Container(
                  height: 22,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        profileAssets + 'feather.png',
                        width: 22,
                        height: 22,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text("Terms & Conditions", style: listTextStyle),
                    ],
                  ),
                ),
                onTap: () {
                  launch("https://www.thefloatapp.com/terms");
                },
              ),
              Divider(),
              new ListTile(
                leading: Container(
                  height: 22,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 22,
                        height: 22,
                        child: Image.asset(
                          profileAssets + 'del_acc.png', //delete_account
                          width: 22,
                          height: 22,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Delete Account",
                        style:
                            listTextStyle_del, //TextStyle(color: del_acc_color, fontSize: 15)
                      ), //
                    ],
                  ),
                ),
                onTap: () {
                  showDelBottomSheet(context: context);
                },
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        )
      ],
    );
  }

  showDelBottomSheet({BuildContext context}) {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: new Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                                height: 18,
                                width: 18,
                                child: Icon(
                                  Icons.close,
                                  color: Color.fromARGB(255, 155, 155, 155),
                                )), //Image.asset('assets/profile/clear.png')
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Are you sure?',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(64, 64, 64, 1),
                              fontSize: 30),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: Container(
                        //         height: 18,
                        //         width: 18,
                        //         child: Image.asset('assets/profile/clear.png')),
                        //   ),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            ' If you delete your account you will\n lose floats, friends and resources you\n have added.',
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                color: Color.fromRGBO(64, 64, 64, 1),
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    InkWell(
                      onTap: () {
                        //Navigator.pop(context);
                        if (FirebaseAuth.instance.currentUser.uid != null) {
                          print('uid is here ...........');
                          print(FirebaseAuth.instance.currentUser.uid);
                          try {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser.uid)
                                .delete();
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OnbaordingPage()));

                            // Navigator.of(context).pop();
                            // Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(
                            //         builder: (context) => OnbaordingPage(),
                            //         maintainState: false));
                            //Navigator.pop(context);
                          } catch (e) {
                            print('exception $e ...........');
                          }
                        }
                      },
                      child: Container(
                        height: 86,
                        decoration: BoxDecoration(
                          color: del_acc_color,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(42),
                              topRight: Radius.circular(42)),
                        ),
                        child: Center(
                          child: Text(
                            'Delete account',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 24),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
  }
}

class CampusTab extends StatefulWidget {
  @override
  _CampusTabState createState() => _CampusTabState();
}

class _CampusTabState extends State<CampusTab> {
  final List<String> abc = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  CampusUser currentCampusUser = CampusUser(
    
      userId: FirebaseAuth.instance.currentUser.uid,
      userImage: iscomplete ? '' : StaticInfo.userModel.profilepic,
      userName: iscomplete ? '' : StaticInfo.userModel.fullname);

  ///
  ///
  ///
  CampusModel campusModel = CampusModel(
    campusUsers: [
      CampusUser(
          userId: FirebaseAuth.instance.currentUser.uid,
          userImage: iscomplete ? '' : StaticInfo.userModel.profilepic,
          userName: iscomplete ? '' : StaticInfo.userModel.fullname)
    ],
    userId: FirebaseAuth.instance.currentUser.uid,
  );

  ///
  ///
  ///
  ///
  bool isLoading = false;
  List<UserShelfModel> allShelfs = [];
  final TextEditingController emojiController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  @override
  void initState() {
    getMyCampus();
    super.initState();
  }

  List<UserShelfModel> selectedUserShelfs = [];
  List<UserShelfModel> currentUserShelfs = [];
  UserShelfModel selectedUserShelfModel;

  ///
  ///
  ///
  getMyCampus() async {
    setState(() {
      isLoading = true;
    });
    CampusModel res = await CampusHelper().getCurentUserCampus();
    allShelfs = await CampusHelper().getAllUserShelfs();
    currentUserShelfs = allShelfs
            .where((element) =>
                element.userId == FirebaseAuth.instance.currentUser.uid)
            .toList() ??
        [];
    if (res != null) {
      campusModel.campusUsers.addAll(res.campusUsers);
    }
    selectedCampusUser = CampusUser(
        userId: FirebaseAuth.instance.currentUser.uid,
        userImage: StaticInfo.userModel.profilepic,
        userName: StaticInfo.userModel.fullname);
    setCurrentUser();

    setState(() {
      isLoading = false;
      
    });
  }

  setCurrentUser() {
    selectedCampusUser = currentCampusUser;
    selectedUserShelfs = allShelfs
            .where((element) =>
                element.userId == FirebaseAuth.instance.currentUser.uid)
            .toList() ??
        [];
    selectedUserShelfModel =
        selectedUserShelfs.length > 0 ? selectedUserShelfs.last : null;
    setState(() {});
  }

  CampusUser selectedCampusUser;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var h = mediaQueryData.size.height;
    var v = mediaQueryData.size.width;
    print(FirebaseAuth.instance.currentUser.uid);
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Campus",
                        style: GoogleFonts.lato(
                            color: const Color(0xff4a4a4a),
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 24.0)),
                    InkWell(
                      onTap: () => Get.to(() => CampusSearchScreen()),
                      child: Image.asset(
                        'assets/profile/search.png',
                        height: 26,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 32,
                ),
                Container(
                  height: h * .25, //....194
                  width: v * 8,
                  alignment: Alignment.topLeft,
                  child: campusModel.campusUsers.length < 2
                      ? NoFriendCampus()
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.start,
                              direction: Axis.vertical,
                              spacing: 10,
                              runSpacing: 16,
                              children: campusModel.campusUsers
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {
                                        selectedCampusUser = e;
                                        selectedUserShelfs = allShelfs
                                                .where((element) =>
                                                    element.userId == e.userId)
                                                .toList() ??
                                            [];
                                        selectedUserShelfModel =
                                            selectedUserShelfs.length > 0
                                                ? selectedUserShelfs.last
                                                : null;
                                        setState(() {});
                                      },
                                      onLongPress: () {
                                        if (e.userId !=
                                            FirebaseAuth
                                                .instance.currentUser.uid) {
                                          removeUserModal(
                                              context: context, campusUser: e);
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 29,
                                        backgroundImage: e.userImage != '' &&
                                                e.userImage != null
                                            ? NetworkImage(e.userImage)
                                            : AssetImage(
                                                profileAssets + 'profile.png'),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                ),
                SizedBox(
                  height: 28,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${selectedCampusUser == null || selectedCampusUser.userId == FirebaseAuth.instance.currentUser.uid ? '' : "${selectedCampusUser.userName?.split(' ')?.first}\'s "}' +
                              "Shelf" +
                              "${selectedCampusUser?.userId == FirebaseAuth.instance.currentUser.uid ? "         " : ''}",
                          style: GoogleFonts.lato(
                              color: const Color(0xff4a4a4a),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 24.0),
                        ),
                        SizedBox(width: 14),
                      ],
                    ),
                    InkWell(
                      onTap: selectedCampusUser?.userId ==
                              FirebaseAuth.instance.currentUser.uid
                          ? showAddtoShelfDialogue
                          : () {
                              setCurrentUser();
                            },
                      child: selectedCampusUser?.userId ==
                              FirebaseAuth.instance.currentUser.uid
                          ? Image.asset(
                              'assets/profile/add.png',
                              height: 24,
                            )
                          : Image.asset(
                              'assets/profile/clear.png',
                              height: 24,
                            ),
                    )
                  ],
                ),
                SizedBox(
                  height: 28,
                ),
                selectedCampusUser?.userId ==
                            FirebaseAuth.instance.currentUser.uid &&
                        selectedUserShelfs.length == 0
                    ? EmptyShelfPlaceHolder()
                    : selectedUserShelfs.length == 0
                        ? Container(
                            // width: 367,
                            height: 87,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              color: const Color(0xfff1f9ff),
                            ),
                            child: // Add an emoji and not
                                Center(
                              child: Text(
                                "Nothing posted",
                                style: GoogleFonts.lato(
                                  color: const Color(0xff32a8ff),
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 55,
                                child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: allShelfs
                                        .where((element) =>
                                            element.userId ==
                                            selectedCampusUser?.userId)
                                        ?.toList()
                                        ?.reversed
                                        .toList()
                                        .map(
                                          (e) => InkWell(
                                            onTap: () {
                                              selectedUserShelfModel = e;
                                              setState(() {});
                                            },
                                            child: Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 24.0,
                                                ),
                                                child: FittedBox(
                                                  child: Text(
                                                    "${e.emoji}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: Color(0xff32a8ff)
                                                          .withOpacity(
                                                        selectedUserShelfModel ==
                                                                e
                                                            ? 1
                                                            : 0.6,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 42.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList()),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              ShelfTextWidget(
                                userShelfModel: selectedUserShelfModel,
                              )
                            ],
                          )
              ],
            ),
          );
  }

  Future removeUserModal({BuildContext context, CampusUser campusUser}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: new Container(
            // height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ),
                        onPressed: () => Navigator.pop(context)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.transparent,
                          // backgroundImage: AssetImage(
                          //     essaytennisAssets + 'story.png'),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: campusUser.userImage != '' &&
                                    campusUser.userImage != null
                                ? NetworkImage(campusUser.userImage)
                                : AssetImage(profileAssets + 'profile.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: Text(
                            campusUser.userName ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(64, 64, 64, 1),
                                fontSize: 20),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, top: 16),
                      child: Text(
                        'Remove?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            color: Color.fromRGBO(64, 64, 64, 1),
                            fontSize: 32),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 61,
                      ),
                      child: Text(
                        'You will need to add this user again\nand wait for them to accept.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    campusModel.campusUsers.remove(campusUser);
                    allShelfs.removeWhere(
                        (element) => element.userId == campusUser.userId);
                    setCurrentUser();
                    setState(() {});
                    await CampusHelper().removeFromCampus(campusUser);
                  },
                  child: Container(
                    height: 97,
                    decoration: BoxDecoration(
                      color: Color(0xff4f4f4f),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(42),
                          topRight: Radius.circular(42)),
                    ),
                    child: Center(
                      child: Text(
                        'Remove',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future addToShelfRequestModal(
      {BuildContext context, UserShelfModel userShelfModel}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: new Container(
            // height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40, top: 30),
                      child: Column(
                        children: [
                          Text(
                            'Add to shelf',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                color: Color.fromRGBO(64, 64, 64, 1),
                                fontSize: 32),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Text("Shelves empty every week",
                                style: GoogleFonts.lato(
                                    color: const Color(0xffd8d8d8),
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 30, left: 23, right: 19),
                      child: Text(
                        '${userShelfModel.emoji}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 36.0),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: Get.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 30, left: 23, right: 19),
                        child: Text(
                          '${userShelfModel.note}',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0),
                        ),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () async {
                    Get.back();
                    await CampusHelper().addToShelf(userShelfModel);
                    allShelfs.add(userShelfModel);
                    setCurrentUser();
                    setState(() {});
                    emojiController.text = '';
                    noteController.text = '';
                  },
                  child: Container(
                    height: 97,
                    decoration: BoxDecoration(
                      color: Color(0xff3d97eb),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(42),
                          topRight: Radius.circular(42)),
                    ),
                    child: Center(
                      child: Text(
                        'Add',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showAddtoShelfDialogue() {
    return Get.dialog(Dialog(
      child: Container(
        width: Get.width,
        height: Get.height * 0.5,
        child: Padding(
          padding: EdgeInsets.only(top: 31),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Add to shelf?",
                style: GoogleFonts.lato(
                  color: const Color(0xff404040),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 34.0,
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 23),
                child: Column(
                  children: [
                    TextField(
                      maxLength: 1,
                      controller: emojiController,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      textInputAction: TextInputAction.next,
                      style: GoogleFonts.lato(
                          color: const Color(0xff4a4a4a),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Emoji',
                          hintStyle: GoogleFonts.lato(
                              color: const Color(0xffb0b2be),
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      minLines: 4,
                      maxLines: 5,
                      maxLength: 133,
                      controller: noteController,
                      buildCounter: (BuildContext context,
                              {int currentLength,
                              int maxLength,
                              bool isFocused}) =>
                          null,
                      style: GoogleFonts.lato(
                          color: const Color(0xff4a4a4a),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (val) {
                        print('ON SUBMIT PRESS');
                        final RegExp regexEmoji = RegExp(
                            r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
                        if (!emojiController.text.contains(regexEmoji)) {
                          Get.snackbar(
                            'Only emojis are allowed in emoji field',
                            '',
                          );
                          return;
                        }
                        if (val.isEmpty) {
                          Get.snackbar(
                            'Note can not be empty',
                            '',
                          );
                          return;
                        }
                        Get.back();
                        UserShelfModel userShelfModel = UserShelfModel(
                          id: DateTime.now().microsecondsSinceEpoch.toString(),
                          userId: FirebaseAuth.instance.currentUser.uid,
                          emoji: emojiController.text,
                          note: noteController.text,
                          dateAdded: Timestamp.now(),
                        );
                        addToShelfRequestModal(
                            context: context, userShelfModel: userShelfModel);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Note',
                        hintStyle: GoogleFonts.lato(
                          color: const Color(0xffb0b2be),
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class ShelfTextWidget extends StatelessWidget {
  final UserShelfModel userShelfModel;
  const ShelfTextWidget({
    Key key,
    this.userShelfModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 367,
      height: 87,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: const Color(0xfff1f9ff),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 23,
      ),
      child: Center(
        child: Text(
          userShelfModel != null
              ? "${userShelfModel.note}"
              : "Add an emoji and notes will appear here",
          style: GoogleFonts.lato(
            color: const Color(0xff4a4a4a),
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class EmptyShelfPlaceHolder extends StatelessWidget {
  const EmptyShelfPlaceHolder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "💽",
              style: const TextStyle(
                color: const Color(0xff32a8ff),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 42.0,
              ),
            ),
            SizedBox(
              width: 24,
            ),
            // 📽
            Text("📽",
                style: TextStyle(
                    color: Color(0xff32a8ff).withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 42.0)),
            SizedBox(
              width: 24,
            ),
            // 🕹
            Text("🕹",
                style: TextStyle(
                    color: Color(0xff32a8ff).withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 42.0))
          ],
        ),
        SizedBox(
          height: 22,
        ),
        Container(
          // width: 367,
          height: 87,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: const Color(0xfff1f9ff),
          ),
          alignment: Alignment.center,
          child: // Add an emoji and not
              Text(
            "Add an emoji and notes will appear here",
            style: GoogleFonts.lato(
              color: const Color(0xff32a8ff),
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
          ),
        )
      ],
    );
  }
}

class NoFriendCampus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 254,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 29,
                backgroundColor: Colors.transparent,
                backgroundImage: StaticInfo.userModel.profilepic == '' ||
                        StaticInfo.userModel.profilepic == null
                    ? AssetImage(profileAssets + 'profile.png')
                    : NetworkImage(StaticInfo.userModel.profilepic),
              ),
              SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 29,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/profile/blackwoman.png'),
              ),
            ],
          ),
          SizedBox(
            width: 18,
          ),
          Column(
            children: [
              CircleAvatar(
                radius: 29,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/profile/male.png'),
              ),
              SizedBox(
                height: 10,
              ),
              CircleAvatar(
                radius: 29,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/profile/woman.png'),
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              SizedBox(
                height: 28, //28
              ),
              Container(
                //height: 48, //28
                //width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: const Color(0xfff1f9ff),
                ),
                padding:
                    EdgeInsets.only(bottom: 16, left: 16, right: 8, top: 11),
                child: Text(
                    "Search and add\n yourfriends \nto your campus.\nTap to see \nfriend’s shelf",
                    maxLines: 10,
                    style: GoogleFonts.lato(
                        color: const Color(0xff32a8ff),
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0)),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ScoresTab extends StatelessWidget {
  final UserModel userModel;

  const ScoresTab({Key key, this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text("Scores",
                  style: GoogleFonts.lato(
                      color: const Color(0xff4a4a4a),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 28.0)),
            ),
          ],
        ),
        SizedBox(
          height: 41,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GameWidget(
              assetPath: profileAssets + 'gameswon.png',
              number: '${userModel?.gameswon ?? '0'}',
              title: 'Games Won',
            ),
            SizedBox(
              width: 50,
            ),
            GameWidget(
              assetPath: profileAssets + 'points.png',
              number: '${userModel?.points ?? '0'}',
              title: 'Points',
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                    height: 65,
                    width: 105,
                    child: Center(
                      child: Image.asset(profileAssets + 'gamesplayed.png'),
                    )),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '     ${userModel?.gamesplayed ?? '0'}',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      color: Color.fromRGBO(74, 74, 74, 1)),
                ),
                Text(
                  '            Games Played',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Color.fromRGBO(74, 74, 74, 1)),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

class GameWidget extends StatelessWidget {
  final String assetPath;
  final String number;
  final String title;
  const GameWidget({
    Key key,
    @required this.assetPath,
    @required this.number,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 65, width: 65, child: Image.asset(assetPath)),
        SizedBox(
          height: 5,
        ),
        Text(
          number,
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w700,
              fontSize: 36,
              color: Color.fromRGBO(74, 74, 74, 1)),
        ),
        Text(
          title,
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Color.fromRGBO(74, 74, 74, 1)),
        )
      ],
    );
  }
}
