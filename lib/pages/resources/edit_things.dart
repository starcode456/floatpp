import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:float/models/user.dart';
import 'package:float/models_services/universityHelper.dart';
import 'package:float/models/universityModel.dart';
import 'package:float/models_services/userHelper.dart';
import 'package:float/pages/resources/uni_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class EditThings extends StatefulWidget {
  final UserModel userModel;

  const EditThings({Key key, this.userModel}) : super(key: key);

  @override
  _EditThingsState createState() => _EditThingsState();
}

class _EditThingsState extends State<EditThings> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController> controllers =
      List<TextEditingController>.generate(
          2, (generator) => TextEditingController());
  bool isLoading = true;

  List<UniversityModel> allUniversities = [];
  bool enableSubmit = false;
  bool validUniName = false;
  List<String> universityNames = ["oxford"];
  final picker = ImagePicker();
  Reference storageReference = FirebaseStorage.instance.ref();
  String profileUrl;
  File _image;
  @override
  void initState() {
    super.initState();
    controllers[0].text = widget.userModel.fullname;
    controllers[1].text = widget.userModel.uni;
    getAllUniversities();
  }

  getAllUniversities() async {
    allUniversities = await UniversityHelper().getAllUniversities();
    setState(() {
      isLoading = false;
    });
  }

  bool checkUni(String value) {
    return allUniversities
                .where((element) =>
                    element.name.trim().toLowerCase() ==
                    value.trim().toLowerCase())
                .toSet()
                .length >
            0
        ? true
        : false;
  }

  updateInfo() async {
    setState(() {
      isLoading = true;
    });

    bool result = await UserHelper()
        .updateInfo(uni: controllers[1].text, userName: controllers[0].text);
    if (result) {
      Get.back();
    } else {
      Get.snackbar(
          'An error occured', 'Check your internet connection and try again');
    }
    setState(() {
      isLoading = false;
    });
  }

  UniversityModel getCurrentUni(String value) {
    return allUniversities.firstWhere(
        (element) => element.name.toLowerCase() == value.toLowerCase(),
        orElse: () => null);
  }

  launchUrl(String help) async {
    if (help.contains('@')) {
      final Uri params = Uri(
        scheme: 'mailto',
        path: '$help',
      );

      var url = params.toString();

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Get.snackbar('An error occured', 'Could not lauch url');
        print('Could not launch $url');
      }
    } else {
      String url = 'tel:$help';
      if (await canLaunch(url)) {
        print('canlaunch');
        await launch(url);
      } else {
        Get.snackbar('An error occured', 'Could not lauch url');
        print('Could not launch $url');
      }
    }
  }

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

      // if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      //   final String url = await ref.getDownloadURL();
      //   print("The download URL is " + url);
      // } else if (storageUploadTask.isInProgress) {
      //   storageUploadTask.events.listen((event) {
      //     double percentage = 100 *
      //         (event.snapshot.bytesTransferred.toDouble() /
      //             event.snapshot.totalByteCount.toDouble());
      //     print("THe percentage " + percentage.toString());
      //   });

      TaskSnapshot storageTaskSnapshot =
          await storageUploadTask.whenComplete(() => null);

      profileUrl = await storageTaskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profilepic': profileUrl});
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
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
              onPressed: () => Get.to(UniDetails())),
          title: Text("Edit things",
              style: GoogleFonts.lato(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 24.0),
              textAlign: TextAlign.center),
          backgroundColor: Color(0xff32a8ff),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                onPressed: () => Get.back())
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Container(
                      child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 22.0, bottom: 8),
                              child: Text("Change Avatar",
                                  style: GoogleFonts.lato(
                                      color: const Color(0xff5e5e5e),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0)),
                            ),
                            InkWell(
                              onTap: () {
                                //getImage();
                                showCupertinoSheet(context);
                              },
                              child: CircleAvatar(
                                radius: 40,
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Text(''),
                                backgroundImage: widget.userModel.profilepic !=
                                        null
                                    ? NetworkImage(
                                        widget.userModel.profilepic,
                                      )
                                    : AssetImage(profileAssets + 'profile.png'),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text("Username",
                                style: GoogleFonts.lato(
                                    color: const Color(0xff5e5e5e),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0)),
                            textField(0),
                            SizedBox(
                              height: 8,
                            ),
                            Text("This will appear in search",
                                style: GoogleFonts.lato(
                                    color: const Color(0xffb0b2be),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0)),
                            SizedBox(
                              height: 20,
                            ),
                            Text("University/College name",
                                style: GoogleFonts.lato(
                                    color: const Color(0xff545454),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0)),
                            textField(1),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                                "Add your university and be linked to their help centre",
                                style: GoogleFonts.lato(
                                    color: const Color(0xffb9bac6),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0)),
                            SizedBox(
                              height: 20,
                            ),
                            Text("My university/college help centre",
                                style: GoogleFonts.lato(
                                    color: const Color(0xff545454),
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0)),
                            ListTile(
                                contentPadding: EdgeInsets.only(right: 10),
                                onTap: () {
                                  checkUni(controllers[1].text)
                                      ? launchUrl(
                                          getCurrentUni(controllers[1].text)
                                              ?.helpNumber)
                                      : () {}();
                                },
                                // leading: Image.asset(
                                //   'assets/resource/help.png',
                                //   height: 24,
                                //   width: 24,
                                //   color: Color(0xff32a8ff),
                                // ),
                                title: Row(
                                  children: [
                                    Image.asset(
                                      'assets/resource/help.png',
                                      height: 24,
                                      width: 24,
                                      color: Color(0xff32a8ff),
                                    ),
                                    SizedBox(width: 8),
                                    Text("I would like some help",
                                        style: GoogleFonts.lato(
                                            color: const Color(0xff4a4a4a),
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 18.0)),
                                  ],
                                ),
                                trailing: Image.asset(
                                  "assets/resource/check.png",
                                  scale: 2.8,
                                  color: !checkUni(controllers[1].text)
                                      ? Color(0xffd8d8d8)
                                      : Color(0xff44d7b6),
                                )),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                            InkWell(
                              onTap: () {
                                if (controllers[0].text.isNotEmpty) {
                                  updateInfo();
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(31.5)),
                                  color: controllers[0].text.isEmpty
                                      ? Color(0xfff0eaea)
                                      : Color(0xff32a8ff),
                                ),
                                child: Center(
                                  child: Text(
                                    "Save",
                                    style: GoogleFonts.lato(
                                        color: controllers[0].text.isNotEmpty
                                            ? Colors.white
                                            : Color(0xffc3c3c3),
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 22.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(int conNum) {
    return TextFormField(
        onChanged: (val) {
          if (conNum == 1) {
            checkUni(val);
          }
          if (controllers[0].text.isNotEmpty &&
              controllers[1].text.isNotEmpty) {}
          if (universityNames.contains(controllers[1].text.trim())) {
            print("is it");
            setState(() {
              validUniName = true;
            });
          }
          setState(() {});
        },
        controller: controllers[conNum],
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: new BorderSide(color: Color(0xff979797), width: 0.5),
            //   borderRadius: new BorderRadius.circular(25.7),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Color(0xff979797), width: 0.5),
            //   borderRadius: new BorderRadius.circular(25.7),
          ),
          suffixIcon: conNum == 1
              ? controllers[1].text.isNotEmpty
                  ? Image.asset(
                      'assets/resource/check.png',
                      scale: 3.0,
                      color: !checkUni(controllers[1].text)
                          ? Color(0xffd8d8d8)
                          : Color(0xff44d7b6),
                    )
                  : null
              : null,
          hintText: conNum == 0 ? 'Username' : "Add University / College",
          hintStyle: GoogleFonts.lato(
            color: const Color(0xff8c8c8c),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 20.0,
          ),
        ),
        style: GoogleFonts.lato(
            color: const Color(0xff4a4a4a),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 20.0),
        validator: (txt) {
          if (controllers[0].text.isEmpty || controllers[1].text.isEmpty) {
            return 'Fill all fields';
          }
          return "";
        });
  }
}
