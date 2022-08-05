import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/float_model.dart';
import 'package:float/models/user.dart';
import 'package:float/pages/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'finished_page.dart';

class UpdateFloatPage extends StatefulWidget {
  UpdateFloatPage({Key key, this.float, this.floatId}) : super(key: key);

  final FloatModel float;
  final String floatId;

  @override
  _UpdateFloatPageState createState() => _UpdateFloatPageState();
}

class _UpdateFloatPageState extends State<UpdateFloatPage> {
  var wordCount = TextEditingController();
  bool isSubmitAllowed = false;
  FloatModel opponentFloat;
  bool showSpinner = false;
  getOpponentFloat() async {
    if (widget.float.state == 2) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('floats')
            .doc(widget.float.rivalfloat)
            .get();
        if (snapshot.data() != null) {
          opponentFloat = FloatModel.fromJson(snapshot.data());
          print('opponentFloat');
          print(opponentFloat.toJson());
        }
      } catch (e) {
        print(e);
      }
    }
  }

  updateFloat() async {
    FocusScope.of(context).unfocus();
    setState(() {
      showSpinner = true;
    });
    print(widget.float.toJson());
    try {
      await FirebaseFirestore.instance
          .collection('floats')
          .doc(widget.floatId)
          .set({
        "wordsCompleted": FieldValue.increment(
            int.parse(wordCount.text) - widget.float.wordstoday),
        "wordstoday": int.parse(wordCount.text),
        'lastwords': int.parse(wordCount.text),
        'lastupdated': Timestamp.now(),
        // 'words': FieldValue.increment(-int.parse(wordCount.text))
      }, SetOptions(merge: true));

      if (widget.float?.state == 1) {
        await FirebaseFirestore.instance
            .collection('floats')
            .doc(widget.floatId)
            .set({
          'state': 2,
          'canupdate': false,
        }, SetOptions(merge: true));
        print('rivalfloat    ${widget?.float?.rivalfloat}');
        await FirebaseFirestore.instance
            .collection('floats')
            .doc(widget.float.rivalfloat)
            .set({
          'state': 2,
          'rivalwords': int.parse(wordCount.text),
          'canupdate': true,
        }, SetOptions(merge: true));
      }

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('floats')
          .doc(widget.float.rivalfloat)
          .get();
      print(snapshot.data());
      if (opponentFloat?.state == 2) {
        if ((int.parse((wordCount.text)) - widget.float.wordstoday) >=
            widget.float.rivalwords) {
          widget.float.points++;
          await FirebaseFirestore.instance
              .collection('floats')
              .doc(widget.floatId)
              .set({
            'points': FieldValue.increment(1),
            'canupdate': false,
          }, SetOptions(merge: true));
          await FirebaseFirestore.instance
              .collection('floats')
              .doc(widget.float.rivalfloat)
              .set({
            'canupdate': true,
            'rivalpoints': FieldValue.increment(1),
            'rivalwords': int.parse(wordCount.text) - widget.float.wordstoday,
          }, SetOptions(merge: true));
        } else {
          widget.float.rivalpoints++;
          await FirebaseFirestore.instance
              .collection('floats')
              .doc(widget.floatId)
              .set({
            'rivalpoints': FieldValue.increment(1),
            'canupdate': false,
          }, SetOptions(merge: true));
          await FirebaseFirestore.instance
              .collection('floats')
              .doc(widget.float.rivalfloat)
              .set({
            'canupdate': true,
            'points': FieldValue.increment(1),
            'rivalwords': int.parse(wordCount.text) - widget.float.wordstoday,
          }, SetOptions(merge: true));
        }
      }
      if (int.parse(wordCount.text) >= widget.float?.words) {
        if (widget.float?.state == 2) {
          print('my points ${widget.float.points}');
          print('my points ${widget.float.rivalpoints}');
          if (widget.float.points >= widget.float.rivalpoints) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .set({
              'points': FieldValue.increment(widget.float.points + 5),
              'gameswon': FieldValue.increment(1)
            }, SetOptions(merge: true));
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.float.opponent)
                .set({
              'points': FieldValue.increment(widget.float.rivalpoints),
            }, SetOptions(merge: true));
            await FirebaseFirestore.instance
                .collection('floats')
                .doc(widget.float.rivalfloat)
                .set(
              {
                'state': null,
                'points': 0,
                'rivalpoints': 0,
              },
              SetOptions(merge: true),
            );
            FirebaseFirestore.instance
                .collection('floats')
                .doc(widget.floatId)
                .delete();
            DocumentSnapshot snapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .get();
            UserModel userModel = UserModel.fromFirestore(snapshot);
            setState(
              () {
                showSpinner = false;
              },
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(
                  result: 'You Won',
                  userModel: userModel,
                ),
              ),
            );
          } else {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.float.opponent)
                .set({
              'points': FieldValue.increment(widget.float.rivalpoints + 5),
              'gameswon': FieldValue.increment(1)
            }, SetOptions(merge: true));
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .set({
              'points': FieldValue.increment(widget.float.points),
            }, SetOptions(merge: true));
            await FirebaseFirestore.instance
                .collection('floats')
                .doc(widget.float.rivalfloat)
                .set({
              'state': null,
              'points': 0,
              'rivalpoints': 0,
            }, SetOptions(merge: true));
            FirebaseFirestore.instance
                .collection('floats')
                .doc(widget.floatId)
                .delete();

            DocumentSnapshot snapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser.uid)
                .get();
            UserModel userModel = UserModel.fromFirestore(snapshot);
            setState(
              () {
                showSpinner = false;
              },
            );
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
        } else {
          FirebaseFirestore.instance
              .collection('floats')
              .doc(widget.floatId)
              .delete();
          setState(() {
            showSpinner = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new FinishedPage()));
        }
      } else {
        setState(() {
          showSpinner = false;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    getOpponentFloat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.float.rivalwords);
    // if (wordCount == null) {
    //   wordCount = TextEditingController(text: widget.document.data["wordsCompleted"].toString());
    // }

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.float.title,
              style: GoogleFonts.lato(
                  color: Color(0xFF4A4A4A),
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30,
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text("Words completed",
                            style: GoogleFonts.lato(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        new Text(
                          wordCount.text.toString() +
                              " of " +
                              widget.float.words.toString(),
                          style: GoogleFonts.lato(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                new Card(
                    child: new Container(
                        //padding: EdgeInsets.only(left:25),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 120,
                        child: Stack(
                          children: [
                            Positioned(
                              right: 14,
                              top: 19,
                              // bottom: 87,
                              child: widget.float.state == 2
                                  ? Row(
                                      children: [
                                        Text(
                                          'Do ${widget.float.rivalwords + widget.float.wordstoday}+',
                                          style: TextStyle(
                                            fontFamily: latoblack,
                                            fontStyle: FontStyle.italic,
                                            color:
                                                Color.fromRGBO(74, 74, 74, 1),
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(width: 7),
                                        Image.asset(
                                          floatAssets + 'tennis.png',
                                          width: 22,
                                          height: 28,
                                        )
                                      ],
                                    )
                                  : Container(),
                            ),
                            Padding(
                              padding: EdgeInsets.all(25),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                autofocus: true,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: wordCount,
                                onChanged: (val) {
                                  if (val.isEmpty)
                                    isSubmitAllowed = false;
                                  else {
                                    isSubmitAllowed = true;
                                  }

                                  print(isSubmitAllowed);

                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: widget.float.lastwords.toString(),
                                  hintStyle:
                                      GoogleFonts.lato(color: Colors.grey),
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusColor: Colors.grey,
                                ),
                                style: GoogleFonts.lato(
                                  fontSize: 64,
                                  color: widget.float.state != 2
                                      ? Color.fromRGBO(14, 14, 14, 1)
                                      : int.parse(wordCount.text == ''
                                                  ? '0'
                                                  : wordCount.text) >=
                                              (widget.float.rivalwords +
                                                  widget.float.wordstoday)
                                          ? Color.fromRGBO(68, 215, 182, 1)
                                          : Color.fromRGBO(255, 134, 134, 1),
                                ),
                              ),
                            )
                          ],
                        ))),
                new Padding(padding: EdgeInsets.only(top: 10)),
                new GestureDetector(
                  onTap: () => updateFloat(),
                  child: isSubmitAllowed
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFF02BBD3),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            "Update",
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1EAEA),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            "Update",
                            style: GoogleFonts.lato(
                                color: Color(0xFFc2c2c2),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
                new Padding(padding: EdgeInsets.all(20)),
                new FlatButton(
                  child: Text("Cancel",
                      style: GoogleFonts.lato(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
