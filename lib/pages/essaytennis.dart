import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/components/bottommodal.dart';
import 'package:float/components/endgame_modal.dart';
import 'package:float/constants.dart';
import 'package:float/models/float_model.dart';
import 'package:float/models/user.dart';
import 'package:float/pages/essaytennisinfo.dart';
import 'package:float/pages/floats_page.dart';
import 'package:float/pages/resources/search_screen.dart';
import 'package:float/pages/result_screen.dart';
import 'package:float/pages/searchScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class EssayTennisScreen extends StatefulWidget {
  static String routeName = 'EssayTennis';
  final FloatModel floatModel;
  final String floatId;
  EssayTennisScreen({this.floatModel, this.floatId});
  @override
  _EssayTennisScreenState createState() => _EssayTennisScreenState();
}

class _EssayTennisScreenState extends State<EssayTennisScreen> {
  UserModel selectedOpponent;
  UserModel opponent;
  sendRequest() async {
    print('abc');

    if (selectedOpponent.userId == null || selectedOpponent.userId == '') {
      Fluttertoast.showToast(
          msg: "Opponent needs to update the app first to play the game");
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('requests').doc().set(
        {
          'floatId': widget.floatId,
          'requestFrom': widget.floatModel.owner,
          'requestTo': selectedOpponent.userId,
        },
      );
      await FirebaseFirestore.instance
          .collection('floats')
          .doc(widget.floatId)
          .set({
        "state": 0,
      }, SetOptions(merge: true));

      showBottomModal(
          context: context,
          ontap: () {
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) => FloatsPage()));
          },
          title: 'Request Sent',
          buttonText: 'Great, thanks',
          subtitle:
              'Your opponent has been sent an\n invitation. Once your opponent\n accepts & updates their word\ncount, the game will start.');
    } catch (e) {
      Fluttertoast.showToast(msg: e.message);
    }
  }

  getopponentDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.floatModel.opponent)
        .get();
    setState(() {
      opponent = UserModel.fromFirestore(snapshot);
    });
  }

  endGame() async {
    print(widget.floatModel.state);
    if (widget.floatModel.state == 0) {
      await FirebaseFirestore.instance
          .collection('floats')
          .doc(widget.floatId)
          .set({
        'points': 0,
        'state': null,
        'opponent': null,
        'rivalfloat': null,
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.floatModel.opponent)
          .set(
        {
          'points': FieldValue.increment(5),
          'gameswon': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
    }
    if (widget.floatModel.state != null && widget.floatModel.state != 0) {
      print(widget.floatModel.state);
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('floats')
          .doc(widget.floatModel.rivalfloat)
          .get();
      print(snapshot.data());

      FloatModel rivalFloat = FloatModel.fromJson(snapshot.data());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.floatModel.opponent)
          .set(
        {
          'points': FieldValue.increment(rivalFloat.points + 5),
          'gameswon': FieldValue.increment(1),
        },
        SetOptions(merge: true),
      );
      await FirebaseFirestore.instance
          .collection('floats')
          .doc(snapshot.id)
          .set({
        'points': 0,
        'rivalpoints': 0,
        'rivalwords': 0,
        'state': null,
        'opponent': null,
        'rivalfloat': null,
      }, SetOptions(merge: true));
      await FirebaseFirestore.instance
          .collection('floats')
          .doc(widget.floatId)
          .set({
        'points': 0,
        'rivalpoints': 0,
        'rivalwords': 0,
        'state': null,
        'opponent': null,
        'rivalfloat': null,
      }, SetOptions(merge: true));
    }
    DocumentSnapshot usersnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    UserModel userModel = UserModel.fromFirestore(usersnapshot);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          result: 'You Lost',
          userModel: userModel,
        ),
      ),
    );
  }
  //showEndgameModal()=>  endgameModal(context: context, endgame: endGame());

  @override
  void initState() {
    print(widget.floatModel?.toJson());

    if (widget.floatModel?.state != null) {
      getopponentDetails();
    }

    super.initState();
  }

  String getUsername(String username) {
    if (username != null) {
      return 'to\n $username';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(selectedOpponent?.userId);
    print('userId   ${selectedOpponent?.userId}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Essay Tennis',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 6),
              child: Image.asset(
                floatAssets + 'tennis.png',
                height: 26,
                width: 22,
              ),
            )
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          onPressed: () =>
              Navigator.pushNamed(context, EssayTennisInfo.routeName),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop())
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                Color.fromRGBO(115, 237, 187, 1),
                Color.fromRGBO(0, 200, 94, 1)
              ])),
        ),
      ),
      body: widget.floatModel.state != null
          ? inGameWidget()
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                        child:
                            Image.asset(essaytennisAssets + 'tennislogo.png')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Rules',
                          style: GoogleFonts.lato(
                              color: Color.fromRGBO(53, 168, 200, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          child: Text(
                            'Essay Tennis is simple. Update your word count and the other player must respond by updating their words with the same or higher. If the other person updates less you get the points.  The game will start when your friend accepts. Most points at end of esssay wins.',
                            //textAlign: TextAlign.justify,

                            overflow: TextOverflow.ellipsis,
                            maxLines: 24,
                            style: GoogleFonts.lato(
                                height: 1.4,
                                color: Color.fromRGBO(74, 74, 74, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Select an Opponent',
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          // height: MediaQuery.of(context).size.height * 0.1,
                          // width: MediaQuery.of(context).size.width * 0.2,
                          height: 65,
                          width: 65,
                          child: InkWell(
                            onTap: () async {
                              selectedOpponent = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SearchScreen();
                              }));
                              setState(() {});
                            },
                            child: Image.asset(essaytennisAssets + 'add.png'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        selectedOpponent != null
                            ? Container(
                                height: 65,
                                width: 65,
                                child: InkWell(
                                  onTap: () async {},
                                  child: CircleAvatar(
                                    radius: 42,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: AssetImage(
                                        essaytennisAssets + 'story.png'),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: selectedOpponent
                                                  ?.profilepic !=
                                              null
                                          ? NetworkImage(
                                              selectedOpponent.profilepic)
                                          : AssetImage(
                                              profileAssets + 'profile.png'),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: InkWell(
        onTap: () {
          print(selectedOpponent?.userId);
          widget.floatModel.state != null
              ? endgameModal(context: context, endgame: endGame)
              : selectedOpponent != null
                  ? sendRequest()
                  : null;
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.13,
          decoration: BoxDecoration(
            color: selectedOpponent != null
                ? Color.fromRGBO(2, 187, 211, 1)
                : Color.fromRGBO(241, 234, 234, 1),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(40), topLeft: Radius.circular(40)),
          ),
          child: Center(
            child: Text(
              widget.floatModel.state != null
                  ? 'End Game'
                  : 'Send Request ' + getUsername(selectedOpponent?.fullname),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  color: selectedOpponent != null
                      ? Colors.white
                      : Color.fromRGBO(140, 140, 140, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }

  Widget inGameWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Score',
              style: GoogleFonts.lato(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(53, 168, 200, 1)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(225, 255, 232, 1),
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 47, right: 47, top: 8, bottom: 8),
                child: Text(
                  '${widget.floatModel.points ?? 0}-${widget.floatModel.rivalpoints ?? 0}',
                  style: GoogleFonts.lato(
                      fontSize: 40,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(26, 148, 5, 1)),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'Opponent',
                  style: GoogleFonts.lato(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(53, 168, 200, 1)),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Container(
                  height: 65,
                  width: 65,
                  child: InkWell(
                    onTap: () async {},
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage(essaytennisAssets + 'story.png'),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: opponent?.profilepic != null
                            ? NetworkImage(opponent.profilepic)
                            : AssetImage(profileAssets + 'profile.png'),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  opponent?.fullname ?? 'loading...',
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(74, 74, 74, 1)),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
