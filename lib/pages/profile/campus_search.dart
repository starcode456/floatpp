import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/app_utils/static_info.dart';
import 'package:float/constants.dart';
import 'package:float/models/campus_request.dart';
import 'package:float/models/user.dart';
import 'package:float/models_services/campus_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CampusSearchScreen extends StatefulWidget {
  static String routeName = 'SearchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<CampusSearchScreen> {
  List<UserModel> userList;
  List<UserModel> recentList = [];
  String query = "";
  TextEditingController searchController = TextEditingController();
  UserModel currentUser;
  Future<List<UserModel>> fetchAllUsers() async {
    userList = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != FirebaseAuth.instance.currentUser.uid) {
        setState(() {
          userList.add(UserModel.fromFirestore(querySnapshot.docs[i]));
        });
      }
      if (querySnapshot.docs[i].id == FirebaseAuth.instance.currentUser.uid) {
        setState(() {
          currentUser = UserModel.fromFirestore(querySnapshot.docs[i]);

          print(currentUser.recentusers);
        });
      }

      print(userList.length);
    }
    // userList.forEach((user) {
    //   currentUser.recentusers.forEach((element) {
    //     if (user.userId == element) {
    //       recentList.add(user);
    //       print(recentList.length);
    //     }
    //   });
    // });

    return userList;
  }

  // void addtorecent(String userId) {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser.uid)
  //       .set(
  //     {
  //       'recentusers': FieldValue.arrayUnion([userId]),
  //     },
  //     SetOptions(merge: true),
  //   );
  // }

  buildSuggestions(String query, BuildContext context) {
    print(userList.length);
    final List<UserModel> suggestionList = query.trim().isEmpty
        ? []
        : userList != null
            ? userList.where((UserModel user) {
                String _getUsername = user?.fullname?.trim()?.toLowerCase();
                String _query = query.trim()?.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                return (matchesUsername);
              }).toList()
            : [];
    print(suggestionList.length);
    return query.isNotEmpty
        ? Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    child: Container(),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestionList.length,
                  itemBuilder: ((context, index) {
                    UserModel searchedUser = suggestionList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Container(
                            height: 44,
                            width: 44,
                            child: CircleAvatar(
                              backgroundImage: searchedUser?.profilepic != null
                                  ? NetworkImage(searchedUser?.profilepic)
                                  : AssetImage(profileAssets + 'profile.png'),
                            ),
                          ),
                          //mini: false,
                          onTap: () {
                            //Navigator.pop(context, searchedUser);
                            showRequestModal(
                                userModel: searchedUser, context: context);
                            //addtorecent(searchedUser.userId);
                          },

                          title: Text(
                            searchedUser.fullname ?? '',
                            style: GoogleFonts.lato(
                              color: Color.fromRGBO(74, 74, 74, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  }),
                ),
              )
            ],
          )
        : Container(
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Container(),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recentList.length,
                    itemBuilder: ((context, index) {
                      UserModel searchedUser = recentList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Container(
                              height: 44,
                              width: 44,
                              child: CircleAvatar(
                                backgroundImage: searchedUser?.profilepic !=
                                        null
                                    ? NetworkImage(searchedUser?.profilepic)
                                    : AssetImage(profileAssets + 'profile.png'),
                              ),
                            ),
                            //mini: false,
                            onTap: () {
                              Navigator.pop(context, searchedUser);
                              //addtorecent(searchedUser.userId);
                            },

                            title: Text(
                              searchedUser.fullname ?? '',
                              style: GoogleFonts.lato(
                                color: Color.fromRGBO(74, 74, 74, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    }),
                  ),
                )
              ],
            ),
          );
  }

  @override
  void initState() {
    fetchAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: searchAppBar(context),
        // resizeToAvoidBottomPadding: true,
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 42,
                    width: MediaQuery.of(context).size.width * 0.835,
                    child: TextField(
                      style: GoogleFonts.lato(
                          color: Color.fromRGBO(140, 140, 140, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 26),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(151, 151, 151, 1),
                                width: 0.8),
                            borderRadius: BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(151, 151, 151, 1),
                                width: 0.8),
                            borderRadius: BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(151, 151, 151, 1),
                                width: 0.8),
                            borderRadius: BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          //filled: true,
                          hintStyle: GoogleFonts.lato(
                              color: Color.fromRGBO(140, 140, 140, 1),
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                          hintText: "Search Friends",
                          fillColor: Colors.white70),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Color.fromRGBO(140, 140, 140, 1),
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus.unfocus();
                        Navigator.of(context).pop();
                      })
                ],
              ),
            ),
            Divider(),
            buildSuggestions(query, context)
          ],
        ),
      ),
    ));
  }

  Future showRequestModal({BuildContext context, UserModel userModel}) {
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
                                backgroundImage: userModel.profilepic != '' &&
                                        userModel.profilepic != null
                                    ? NetworkImage(userModel.profilepic)
                                    : AssetImage(profileAssets + 'profile.png'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Text(
                                userModel.fullname,
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
                            'Add Friend?',
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
                            'Once your friend accepts, they will\nbe added to your campus.',
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
                        CampusRequestModel campusRequestModel =
                            CampusRequestModel(
                                requestId:
                                    DateTime.now()
                                        .microsecondsSinceEpoch
                                        .toString(),
                                requesterId:
                                    FirebaseAuth.instance.currentUser.uid,
                                recieverId: userModel.userId,
                                requesterImage: StaticInfo.userModel.profilepic,
                                date: Timestamp.now(),
                                requesterName: StaticInfo.userModel.fullname);
                        await CampusHelper()
                            .sendCampusRequest(campusRequestModel);
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
                            'Send Request',
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
