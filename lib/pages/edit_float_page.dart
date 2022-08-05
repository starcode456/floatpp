import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/models_providers/notifications_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class EditFloatPage extends StatefulWidget {
  EditFloatPage({Key key, this.doc}) : super(key: key);

  final DocumentSnapshot doc;

  @override
  _EditFloatPageState createState() => _EditFloatPageState();
}

class _EditFloatPageState extends State<EditFloatPage> {
  DateFormat format = DateFormat("dd/MM/yyyy");
  var titleController;
  var wordCount;
  DateTime date;
  DateTime deadline;
  bool isSubmitAllowed = false;

  // final formats = {
  //   InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
  //   InputType.date: DateFormat('yyyy-MM-dd'),
  //   InputType.time: DateFormat("HH:mm"),
  // };

  // // Changeable in demo
  // InputType inputType = InputType.date;
  @override
  void initState() {
    print(widget.doc.data());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.doc.data()['due']);
    if (titleController == null) {
      titleController = TextEditingController(text: widget.doc.data()['title']);
      wordCount =
          TextEditingController(text: widget.doc.data()['words'].toString());
      //print()
      date = DateTime.fromMicrosecondsSinceEpoch(
          widget.doc.data()['due'].microsecondsSinceEpoch);
      print(date);

      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(255, 221, 114, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Edit Float',
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
                height: 22,
                width: 22,
                child: Image.asset(floatAssets + 'edit.png'))
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop())
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: new TextFormField(
                  controller: titleController,
                  onChanged: (val) {
                    if (titleController.text.isEmpty ||
                        wordCount.text.isEmpty) {
                      isSubmitAllowed = false;
                    } else {
                      isSubmitAllowed = true;
                    }
                    print(isSubmitAllowed);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Title of Essay/Assignment",
                    focusColor: Colors.grey,
                  ),
                  style: GoogleFonts.lato(fontSize: 18),
                )),
            new Padding(padding: EdgeInsets.only(top: 30)),
            new Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: new TextFormField(
                  keyboardType: TextInputType.number,
                  controller: wordCount,
                  onChanged: (val) {
                    if (titleController.text.isEmpty ||
                        wordCount.text.isEmpty) {
                      isSubmitAllowed = false;
                    } else {
                      isSubmitAllowed = true;
                    }
                    print(isSubmitAllowed);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Word count",
                    focusColor: Colors.grey,
                  ),
                  style: GoogleFonts.lato(fontSize: 18),
                )),
            new Padding(padding: EdgeInsets.only(top: 30)),
            new Stack(
              children: <Widget>[
                new Center(
                  child: new Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: new TextFormField(
                        keyboardType: TextInputType.number,
                        enabled: true,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Deadline",
                          focusColor: Colors.grey,
                        ),
                        style: GoogleFonts.lato(fontSize: 18),
                      )),
                ),
                FlatButton(
                  child: new Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      child: Text(
                        format.format(date),
                        style:
                            GoogleFonts.lato(fontSize: 18, color: Colors.cyan),
                        textAlign: TextAlign.right,
                      )),
                  onPressed: () {
                    // DatePicker.showDatePicker(
                    //   context,
                    //   initialDateTime: date,
                    //   onConfirm: (newVal, v) {
                    //     setState(() {
                    //       date = newVal;
                    //     });
                    //   },
                    // );
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: CupertinoDatePicker(
                              initialDateTime: date,
                              mode: CupertinoDatePickerMode.date,
                              minimumDate:
                                  DateTime.now().subtract(Duration(days: 1)),
                              onDateTimeChanged: (newVal) {
                                setState(() {
                                  date = newVal;
                                });
                              },
                            ),
                          );
                        });
                    FocusScope.of(context).unfocus();
                    print('hello');
                  },
                )
              ],
            ),
            new Padding(padding: EdgeInsets.only(top: 10)),
            new Text("Float's deadline is always a day before your deadline.",
                style: GoogleFonts.lato(color: Colors.grey)),
            new Padding(padding: EdgeInsets.only(top: 20)),
            new GestureDetector(
              onTap: () async {
                Random random = new Random();
                int randomNumber = random.nextInt(10000000);
                try {
                  await FirebaseFirestore.instance
                      .collection('floats')
                      .doc(widget.doc.id)
                      .set({
                    "title": titleController.text,
                    "words": int.parse(wordCount.text),
                    "due": Timestamp.fromDate(date),
                    'average': (int.parse(wordCount.text) /
                            date
                                .add(Duration(days: 1))
                                .difference(DateTime.now())
                                .inDays)
                        .truncate(),
                    "owner": FirebaseAuth.instance.currentUser.uid,
                    "notificationId": randomNumber,
                  }, SetOptions(merge: true));

                  Provider.of<NotificationsProvider>(context, listen: false)
                      .scheduleFloatNotification(
                          title: titleController.text,
                          words: wordCount.text,
                          id: randomNumber,
                          dueDate: date);

                  Provider.of<NotificationsProvider>(context, listen: false)
                      .cancelFLoatNotificationById(
                          id: widget.doc.data()['notificationId'] ?? 0);
                  Navigator.pop(context);
                } catch (e) {
                  Fluttertoast.showToast(msg: e.message.toString());
                }
              },
              child: isSubmitAllowed
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        "Done",
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
                        "Done",
                        style: GoogleFonts.lato(
                            color: Color(0xFFc2c2c2),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
