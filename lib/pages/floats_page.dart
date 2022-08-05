import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:float/app_utils/static_info.dart';
import 'package:float/components/bottommodal.dart';
import 'package:float/components/waiting_modal.dart';
import 'package:float/constants.dart';
import 'package:float/models/float_model.dart';
import 'package:float/models/user.dart';
import 'package:float/models_services/campus_helper.dart';
import 'package:float/pages/essaytennis.dart';
import 'package:float/pages/resources/no_resource_yet.dart';
import 'package:float/pages/resources/search_screen.dart';
import 'package:float/pages/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/float_card.dart';
import 'profile/account_page.dart';
import 'create_float_page.dart';
import 'edit_float_page.dart';
import 'update_float_page.dart';
import '../components/request_modal.dart';
import '../models/request_model.dart';
import '../components/start_modal.dart';

class FloatsPage extends StatefulWidget {
  final bool showGoogleAddOnModal;
  FloatsPage({Key key, this.showGoogleAddOnModal}) : super(key: key);

  @override
  _FloatsPageState createState() => _FloatsPageState();
}

class _FloatsPageState extends State<FloatsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool selectFloat = false;
  RequestModel requestModel;
  String selectedRequestId;
  String selectedFloatId;
  String requestId;
  List<Widget> floats = [
    new Padding(padding: EdgeInsets.only(top: 10)),
    new Center(child: new CircularProgressIndicator())
  ];

  ///
  // bool showNewButton = false;
  // SharedPreferences preferences;

  showBottomSheet(
      {BuildContext context, String path, Map<String, dynamic> float}) {
    FloatModel thisfloatModel = FloatModel.fromJson(float);
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: new Container(
                // height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                child: Wrap(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                            onPressed: () => Navigator.pop(context))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            floatAssets + 'trash.png',
                            height: 40,
                            width: 30,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Are You Sure?',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(64, 64, 64, 1),
                              fontSize: 32),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'If you delete your Float, you will\n not be able to get it back. You will\n have to create a new one.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                color: Color.fromRGBO(64, 64, 64, 1),
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        setState(() {
                          floats = [Center(child: CircularProgressIndicator())];
                        });
                        if (thisfloatModel.state == 2) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(thisfloatModel.opponent)
                              .set({
                            'points': FieldValue.increment(5),
                            'gameswon': FieldValue.increment(1)
                          }, SetOptions(merge: true));
                          await FirebaseFirestore.instance
                              .collection('floats')
                              .doc(thisfloatModel.rivalfloat)
                              .set({
                            'state': null,
                          }, SetOptions(merge: true));
                        }
                        await FirebaseFirestore.instance
                            .collection('floats')
                            .doc(path)
                            .delete()
                            .then((T) {
                          getFloats();
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.14,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(220, 25, 54, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(42),
                              topRight: Radius.circular(42)),
                        ),
                        child: Center(
                          child: Text(
                            'Yes Please',
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


  checkRequests() async {
    try {
      // preferences = await SharedPreferences.getInstance();
      // showNewButton = preferences.getBool('new') ?? true;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where("requestTo", isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .get();
      if (querySnapshot.docs.length > 0) {
        requestModel = RequestModel.fromJson(querySnapshot.docs.first.data());
        print('request moel first element ${requestModel.toJson()}');
        selectedRequestId = querySnapshot.docs.first.id;

        requestId = requestModel.floatId;
        // for (int i = 0; i < querySnapshot.docs.length; i++) {

        //requestId = querySnapshot.docs.first.id;
        print(requestModel.toJson());
        QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: requestModel.requestFrom)
            .get();
        if (querySnapshot1.docs.length > 0) {
          UserModel opponentModel =
              UserModel.fromFirestore(querySnapshot1.docs.first);
          print(opponentModel.fullname);
          showRequestModal(
              context: context,
              name: opponentModel.fullname,
              profilePic: opponentModel?.profilepic,
              requestId: requestId,
              selectedRequestId: selectedRequestId,
              onAccept: acceptRequest);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  acceptRequest() async {
    setState(() {
      selectFloat = true;
    });

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    checkRequests();
    getFloats();
    _getProfile();
    CampusHelper().deleteExpired();

    Timer.run(() => widget.showGoogleAddOnModal
        ? showBottomModal(
            context: context,
            ontap: () {
              Navigator.pop(context);
            },
            title: 'Play Essay Tennis',
            subtitle:
                ' Update your word count and the other\n player must respond by updating their\n words with the same or higher. Swipe \nleft on your Float to get started.',
            buttonText: 'Great, Thanks')
        : null);
    Timer.periodic(Duration(hours: 1), (timer) {
      setState(() {});
    });
  }

  void _getProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((DocumentSnapshot ds) {
      StaticInfo.userModel = UserModel.fromFirestore(ds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Color(0xffFAFAFA),
          key: scaffoldKey,
          appBar: AppBar(
              title: Image.asset(
                'assets/floatlogo.png',
                width: 91,
                height: 36,
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              
              backgroundColor: Colors.transparent,
              elevation: 0,
              bottom: PreferredSize(
                  child: Container(
                    color: Colors.grey[200],
                    height: 1.0,
                  ),
                  preferredSize: Size.fromHeight(4.0))),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                getFloats();
                checkRequests();
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: new Expanded(
                        child: RefreshIndicator(
                      onRefresh: () async {
                        // getFloats();
                        // checkRequests();
                      },
                      child: Container(
                          padding:
                              EdgeInsets.only(left: 14, right: 14, top: 10),
                          child: ListView(
                            shrinkWrap: true,
                            //work here
                            children: floats,
                          )),
                    )),
                  ),
                  if (floats.length >= 2)
                    Container(
                      margin: EdgeInsets.only(top: 5, bottom: 12),
                      child: Column(children: <Widget>[
                        selectFloat
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    'Select Float for Essay Tennis',
                                    style: GoogleFonts.lato(
                                        color: Color.fromRGBO(64, 64, 64, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 20.0),
                        selectFloat
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    selectFloat = false;
                                  });
                                },
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.lato(
                                      color: Color.fromRGBO(140, 140, 140, 1),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : Text(
                                'Update by tapping the float',
                                style: GoogleFonts.lato(
                                    fontSize: 20.4,
                                    color: Color(0xFFc2c2c2),
                                    fontWeight: FontWeight.bold),
                              ),
                      ]),
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(bottom: 15, top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              
              boxShadow: [
                new BoxShadow(
                  color: Color(0xff333333),
                  offset: new Offset(0, 0),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Expanded(
                //   child: SizedBox(),
                // ),

Image.asset(profileAssets + 'home.png',height: 45,width: 45,),

                Container(
                  margin: EdgeInsets.only(left: 16),
                  child: FlatButton(
                    child: Container(

                        // padding: EdgeInsets.all(5),
                        child: Image.asset(
                      profileAssets + 'add_float.png',
                      width: 45,
                      height: 45,
                    )),
                    onPressed: () {
                      final res = Navigator.of(context)
                          .push(new MaterialPageRoute<Null>(
                              builder: (BuildContext context) {
                                return CreateFloatPage();
                              },
                              fullscreenDialog: true))
                          .then((T) {
                        getFloats();
                      });
                    },
                  ),
                ),
                TextButton(
                  child: CircleAvatar(
                    
                    child: StaticInfo.userModel?.profilepic ==
                                null ||
                            StaticInfo.userModel?.profilepic.isEmpty
                        ? Image.asset(profileAssets + 'profile.png',width: 32,height: 32,)
                        : NetworkImage(StaticInfo.userModel.profilepic),
                    radius: 25,
                    backgroundColor: Colors.transparent,

                  ),
                  onPressed: () {
                    // preferences.setBool('new', false);
                    // showNewButton = false;
                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new AccountPage()));
                  },
                ),
              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  void getFloats() async {
    FirebaseFirestore.instance
        .collection('floats')
        .where('owner', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((QuerySnapshot doc) async {
      floats = [];

      if (doc.docs.length == 0) {
        floats = floats +
            [
              new Container(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
                child: new Card(
                  color: Color(0xffFAFAFA),
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 12, right: 12, top: 20, bottom: 20),
                    width: MediaQuery.of(context).size.width - 24,
                    height: MediaQuery.of(context).size.height - 220,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/essaytennis/finished.png',
                              width: 320, height: 298, fit: BoxFit.cover),
                          SizedBox(
                            height: 64,
                          ),
                          Text(
                            "Welcome to Float. This is your\nhomescreen. You can create floats\nand navigate to your profile area\nfrom here.Tap the add button to \nget started",
                            style: GoogleFonts.lato(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                  ),
                ),
              ),
            ];
      } else {
        
        for (int i = 0; i < doc.docs.length; i++) {
          print(doc.docs.length);
          FloatModel float = FloatModel.fromJson(doc.docs[i].data());
          DateTime eventTime = DateTime.fromMillisecondsSinceEpoch(
              doc.docs[i].data()['due'].seconds * 1000);

          Duration difference =
              eventTime.add(Duration(days: 1)).difference(DateTime.now());
          if (difference.inDays <= 0) {
            await FirebaseFirestore.instance
                .collection('floats')
                .doc(doc.docs[i].id)
                .delete();
          }
          if (float?.lastupdated != null) {
            if (DateTime.now()
                    .difference(DateTime.fromMicrosecondsSinceEpoch(
                        float.lastupdated?.microsecondsSinceEpoch))
                    .inDays >
                0) {
              if ((DateTime.fromMicrosecondsSinceEpoch(
                          float.due.microsecondsSinceEpoch)
                      .add(Duration(days: 1))
                      .difference(DateTime.now())
                      .inDays) ==
                  0) {
                await FirebaseFirestore.instance
                    .collection('floats')
                    .doc(doc.docs[i].id)
                    .set({
                  'wordstoday': 0,
                  'average': float.words,
                }, SetOptions(merge: true));
              } else {
                await FirebaseFirestore.instance
                    .collection('floats')
                    .doc(doc.docs[i].id)
                    .set({
                  'wordstoday': 0,
                  'average': ((float.words - float.wordsCompleted) /
                          DateTime.fromMicrosecondsSinceEpoch(
                                  float.due.microsecondsSinceEpoch)
                              .add(Duration(days: 1))
                              .difference(DateTime.now())
                              .inDays)
                      .truncate()
                }, SetOptions(merge: true));
              }
            }
          }

          if (float.state == 2) {
            DateTime lastupdated = DateTime.fromMicrosecondsSinceEpoch(
                float?.lastupdated?.microsecondsSinceEpoch ??
                    Timestamp.now().microsecondsSinceEpoch);
            int diffinHours = DateTime.now().difference(lastupdated).inHours;
            if (float.canupdate == false && diffinHours >= 24) {
              await FirebaseFirestore.instance
                  .collection('floats')
                  .doc(doc.docs[i].id)
                  .set({
                'points': FieldValue.increment(1),
                'canupdate': true,
              }, SetOptions(merge: true));
            }
          }

          floats = floats +
              [
                SizedBox(height: 16),
                Container(
                  //height: 110,
                  child: Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.22,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        iconWidget: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.5, 0),
                              end: Alignment(0.5, 1),
                              colors: [
                                Color(0xffebc7ff),
                                const Color(0xffc174f5)
                              ],
                            ),
                          ),
                          child: Image.asset(
                            'assets/resource/bookIcon.png',
                            width: 21,
                            height: 31,
                            scale: 4,
                          ),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoResourceYet(
                                    floatModel:
                                        FloatModel.fromJson(doc.docs[i].data()),
                                    floatId: doc.docs[i].id))).then(
                            (value) => getFloats()),
                      ),
                      IconSlideAction(
                        color: Colors.green[400],
                        //foregroundColor:Color.fromRGBO(61 ,213 ,132, 1) ,
                        iconWidget: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Color.fromRGBO(110, 236, 184, 1),
                                Color.fromRGBO(61, 213, 132, 1),
                              ])),
                          // color: Colors.red,
                          //  height: double.infinity,
                          //width: double.infinity,
                          child: Image.asset(
                            floatAssets + 'tennis.png',
                            width: 22,
                            height: 28,
                            scale: 3,
                          ),
                        ),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EssayTennisScreen(
                                        floatModel: FloatModel.fromJson(
                                          doc.docs[i].data(),
                                        ),
                                        floatId: doc.docs[i].id,
                                      ))).then(
                            (value) => getFloats(),
                          );
                        },
                      ),
                      IconSlideAction(
                          //color: Colors.yellow[200],

                          iconWidget: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                  Color.fromRGBO(255, 240, 168, 1),
                                  Color.fromRGBO(255, 221, 113, 1),
                                ])),
                            // color: Colors.red,
                            //  height: double.infinity,
                            //width: double.infinity,
                            child: new Image.asset(
                              floatAssets + 'edit.png',
                              width: 20,
                              height: 26,
                              scale: 3,
                            ),
                          ),
                          onTap: () async {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditFloatPage(doc: doc.docs[i])))
                                .then((value) => getFloats())
                                .then((T) {
                              getFloats();
                            });
                          }),
                      IconSlideAction(
                        iconWidget: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment(0.5, 0),
                                  end: Alignment(0.5, 1),
                                  colors: [
                                const Color(0xffefcfd6),
                                const Color(0xffe4e4e4)
                              ])),
                          child: Image.asset(
                            floatAssets + 'trash.png',
                            width: 21,
                            height: 26,
                            scale: 3,
                          ),
                        ),
                        onTap: () => showBottomSheet(
                            context: context,
                            path: doc.docs[i].id,
                            float: doc.docs[i].data()),
                      ),
                    ],
                    child: GestureDetector(
                      onTap: () {
                        if (selectFloat) {
                          selectedFloatId = doc.docs[i].id;
                          startModalSheet(
                              context: context,
                              startGame: startGame,
                              floatModel:
                                  FloatModel.fromJson(doc.docs[i].data()));
                        } else {
                          if (float.state != null) {
                            if (float.state == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new UpdateFloatPage(
                                    float:
                                        FloatModel.fromJson(doc.docs[i].data()),
                                    floatId: doc.docs[i].id,
                                  ),
                                ),
                              ).then((T) {
                                getFloats();
                              });
                            } else {
                              if (float.canupdate == true) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => new UpdateFloatPage(
                                      float: FloatModel.fromJson(
                                          doc.docs[i].data()),
                                      floatId: doc.docs[i].id,
                                    ),
                                  ),
                                ).then((T) {
                                  getFloats();
                                });
                              } else {
                                waitingModal(context: context);
                              }
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new UpdateFloatPage(
                                  float:
                                      FloatModel.fromJson(doc.docs[i].data()),
                                  floatId: doc.docs[i].id,
                                ),
                              ),
                            ).then((T) {
                              getFloats();
                            });
                          }
                        }
                      },
                      child: FloatCard(
                        doc.docs[i],
                      ),
                    ),
                  ),
                ),
              ];
        }
      }

      setState(() {});
    });
  }

  startGame() async {
    setState(() {
      selectFloat = false;
    });
    try {
      print(requestId);
      print(selectedFloatId);
      await FirebaseFirestore.instance.collection('floats').doc(requestId).set(
          {
            'opponent': FirebaseAuth.instance.currentUser.uid,
            'rivalfloat': selectedFloatId,
            'state': 0
          },
          SetOptions(
            merge: true,
          ));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(requestModel.requestTo)
          .set(
        {
          'gamesplayed': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );

      await FirebaseFirestore.instance
          .collection('floats')
          .doc(selectedFloatId)
          .set(
              {
            'state': 1,
            'canupdate': true,
            'opponent': requestModel.requestFrom,
            'rivalfloat': requestId
          },
              SetOptions(
                merge: true,
              ));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(requestModel.requestFrom)
          .set(
        {
          'gamesplayed': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
      Navigator.pop(context);
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(selectedRequestId)
          .delete();
      getFloats();
    } catch (e) {
      print(e);
    }
  }

  showModal() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: new Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          floatAssets + 'modaltennis.png',
                          height: 80,
                          width: MediaQuery.of(context).size.width / 2.2,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Play Essay Tennis',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(64, 64, 64, 1),
                              fontSize: 30),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          ' Update your word count and the other\n player must respond by updating their\n words with the same or higher. Swipe \nleft on your Float to get started.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              color: Color.fromRGBO(64, 64, 64, 1),
                              fontSize: 15),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 86,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(2, 187, 211, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(42),
                              topRight: Radius.circular(42)),
                        ),
                        child: Center(
                          child: Text(
                            'Great, Thanks',
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
