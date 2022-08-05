import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:float/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/components/sorry_modal.dart';
import 'package:float/models_providers/notifications_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class CreateFloatPage extends StatefulWidget {
  CreateFloatPage({Key key}) : super(key: key);

  @override
  _CreateFloatPageState createState() => _CreateFloatPageState();
}

class _CreateFloatPageState extends State<CreateFloatPage> {
  final titleController = TextEditingController();
  final wordCount = TextEditingController();
  bool isSubmitAllowed = false;
  bool showSpinner = false;
var _isbook = false;
  DateTime date = DateTime.now();
  DateTime deadline;
  DateFormat format = DateFormat("dd/MM/yyyy");

  // final formats = {
  //   InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
  //   InputType.date: DateFormat('yyyy-MM-dd'),
  //   InputType.time: DateFormat("HH:mm"),
  // };

  // // Changeable in demo
  // InputType inputType = InputType.both;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double pad = width / 4;
    return DefaultTabController(
      length: 2,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80, bottom: 20),
                child: Text("Create float",
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      //width: 130,
                      height: 50,
                      margin: EdgeInsets.only(bottom: 15, top: 20),

                      padding: EdgeInsets.symmetric(
                          horizontal: pad - 25, vertical: 5),

                      child: TabBar(
                        onTap: (value) {
                          if(value == 1){
                            print('book selected');
                            _isbook = true;
                          }
                        },
                        indicator: BoxDecoration(
                            color: Color(0xff38AAFF),
                            borderRadius: BorderRadius.circular(5)),

                        // padding: EdgeInsets.symmetric(vertical: 10),
                        labelColor: Colors.white,

                        unselectedLabelStyle: TextStyle(fontSize: 20),
                        unselectedLabelColor: Color(0xff9A9A9A),

                        tabs: [
                          Tab(
                            child: Text(
                              'Writing',
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'DMSans'),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Reading',
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'DMSans'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Center(
                            child: Column(
                              children: <Widget>[
                                new Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: new TextFormField(
                                      controller: titleController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: "Title of Essay/Assignment",
                                        isDense: true,
                                        focusColor: Color(0xff9B9B9B),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.19,
                                              color: Color(0xff9B9B9B)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.1,
                                              color: Color(0xff38AAFF)),
                                        ),
                                      ),
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
                                      style: GoogleFonts.dmSans(fontSize: 18),
                                    )),
                                    SizedBox(height: 30,),
                                //new Padding(padding: EdgeInsets.only(top: 30)),
                                new Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: new TextFormField(
                                     keyboardType: TextInputType.number,
                                      controller: wordCount,
                                      
                                      decoration: InputDecoration(
                                        isDense: true,
                                        
                                        hintText: "Word count",
                                        focusColor: Color(0xff9B9B9B),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.9,
                                              color: Color(0xff9B9B9B)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.9,
                                              color: Color(0xff38AAFF)),
                                        ),
                                      ),
                                      onChanged: (val) {
                                        if (titleController.text.isEmpty ||
                                            wordCount.text.isEmpty) {
                                          isSubmitAllowed = false;
                                        } else {
                                          isSubmitAllowed = true;
                                        }
                                        setState(() {});
                                        print(isSubmitAllowed);
                                      },
                                      style: GoogleFonts.lato(fontSize: 18),
                                    )),
                                    SizedBox(height: 30,),
                                // Padding(padding: EdgeInsets.only(top: 30)),
                                 Stack(
                                 // alignment: Alignment.bottomRight,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: new TextFormField(
                                            keyboardType: TextInputType.none,
                                            enabled: true,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              
                                              hintText: "Deadline",
                                              focusColor: Color(0xff9B9B9B),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.2,
                                                    color: Color(0xff9B9B9B)),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.2,
                                                    color: Color(0xff38AAFF)),
                                              ),
                                            ),
                                            style: GoogleFonts.lato(fontSize: 18),
                                          ),
                                      ),
                                    ),
                                    TextButton(
                                      
                                    // style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                                      onPressed: (){
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext builder) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                                child: CupertinoDatePicker(
                                                  initialDateTime: date,
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  minimumDate: DateTime.now()
                                                      .subtract(
                                                          Duration(days: 1)),
                                                  onDateTimeChanged: (newVal) {
                                                    setState(() {
                                                      date = newVal;
                                                    });
                                                  },
                                                ),
                                              );
                                            });
                                            FocusScope.of(context).unfocus();
                                      },
                                      child:Center(
                                        child: new Container(
                                          
                                          width: MediaQuery.of(context).size.width * 0.88,
                                           margin: EdgeInsets.only(bottom: 4),
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            format.format(date),
                                            style: GoogleFonts.dmSans(
                                                fontSize: 18,
                                                color: Color(0xff38AAFF)),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // Stack(
                                //   children: <Widget>[
                                //     Center(
                                //       child: new Container(
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width *
                                //               0.9,
                                //           child: new TextFormField(
                                //             keyboardType: TextInputType.number,
                                //             enabled: true,
                                //             decoration: InputDecoration(
                                //               isDense: true,
                                //               hintText: "Deadline",
                                //               focusColor: Color(0xff9B9B9B),
                                //               enabledBorder:
                                //                   UnderlineInputBorder(
                                //                 borderSide: BorderSide(
                                //                     width: 0.9,
                                //                     color: Color(0xff9B9B9B)),
                                //               ),
                                //               focusedBorder:
                                //                   UnderlineInputBorder(
                                //                 borderSide: BorderSide(
                                //                     width: 0.9,
                                //                     color: Color(0xff38AAFF)),
                                //               ),
                                //             ),
                                //             style:
                                //                 GoogleFonts.lato(fontSize: 18),
                                //           )),
                                //     ),
                                //     FlatButton(
                                //       child: new Container(
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width *
                                //               0.88,
                                //           alignment: Alignment.topRight,
                                //           child: Text(
                                //             format.format(date),
                                //             style: GoogleFonts.dmSans(
                                //                 fontSize: 18,
                                //                 color: Color(0xff38AAFF),
                                //                 fontWeight: FontWeight.w500),

                                //             // textAlign: TextAlign.right,
                                //           )),
                                //       onPressed: () {
                                //         showModalBottomSheet(
                                //             context: context,
                                //             builder: (BuildContext builder) {
                                //               return Container(
                                //                 height: MediaQuery.of(context)
                                //                         .size
                                //                         .height *
                                //                     0.4,
                                //                 child: CupertinoDatePicker(
                                //                   initialDateTime: date,
                                //                   mode: CupertinoDatePickerMode
                                //                       .date,
                                //                   minimumDate: DateTime.now()
                                //                       .subtract(
                                //                           Duration(days: 1)),
                                //                   onDateTimeChanged: (newVal) {
                                //                     setState(() {
                                //                       date = newVal;
                                //                     });
                                //                   },
                                //                 ),
                                //               );
                                //             });
                                //         FocusScope.of(context).unfocus();
                                //         print('hello');
                                //         // DatePicker.showDatePicker(
                                //         //   context,
                                //         //   initialDateTime: date,
                                //         //   pickerMode: DateTimePickerMode.date,
                                //         //   onConfirm: (newVal, v) {
                                //         //     setState(() {
                                //         //       date = newVal;
                                //         //     });
                                //         //   },
                                //         // );
                                //       },
                                //     )
                                //   ],
                                // ),
                                new Padding(padding: EdgeInsets.only(top: 10)),
                                new Text(
                                    "Float's deadline is always a day before your deadline.",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey, fontSize: 14)),
                                new Padding(padding: EdgeInsets.only(top: 30)),
                                new GestureDetector(
                                  onTap: () async {
                                    if (date
                                            .add(Duration(days: 1))
                                            .difference(DateTime.now())
                                            .inDays <=
                                        0) {
                                      sorryModal(context: context);
                                      return;
                                    }
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    try {
                                      Random random = new Random();
                                      int randomNumber =
                                          random.nextInt(10000000);
                                      DocumentReference documentReference =
                                          await FirebaseFirestore.instance
                                              .collection('floats')
                                              .add({
                                        "title": titleController.text,
                                        "words": int.parse(wordCount.text),
                                        "wordsCompleted": 0,
                                        'average': (int.parse(wordCount.text) /
                                                date
                                                    .add(Duration(days: 1))
                                                    .difference(DateTime.now())
                                                    .inDays)
                                            .truncate(),
                                        "due": Timestamp.fromDate(date),
                                        "owner": FirebaseAuth
                                            .instance.currentUser.uid,
                                        'notificationId': randomNumber,
                                        'lastupdated': Timestamp.now(),
                                      });
                                      Provider.of<NotificationsProvider>(
                                              context,
                                              listen: false)
                                          .scheduleFloatNotification(
                                              title: titleController.text,
                                              words: '0',
                                              id: randomNumber,
                                              dueDate: date);
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      Navigator.pop(context);
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                          msg: e.message.toString());
                                    }
                                  },
                                  child: isSubmitAllowed
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 56,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.cyan,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Text(
                                            "Done",
                                            style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 72,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF1EAEA),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            "Done",
                                            style: GoogleFonts.dmSans(
                                                color: Color(0xFF9A9A9A),
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      new TextFormField(
                                        controller: titleController,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          suffix: Icon(
                                            Icons.menu_book_rounded,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 5),
                                          hintText: "Title of Book",
                                          isDense: true,
                                          focusColor: Color(0xff9B9B9B),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.7,
                                                color: Color(0xff9B9B9B)),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 0.7,
                                                color: Color(0xff38AAFF)),
                                          ),
                                        ),
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
                                        style: GoogleFonts.lato(fontSize: 18),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 4),
                                        child: Image.asset(
                                          profileAssets + 'book.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // new Container(
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.9,
                                //     child: new TextFormField(
                                //       controller: titleController,
                                //       autofocus: true,
                                //       decoration: InputDecoration(
                                //         suffix: Icon(
                                //           Icons.menu_book_rounded,
                                //         ),
                                //         contentPadding: EdgeInsets.symmetric(
                                //             horizontal: 0, vertical: 5),
                                //         hintText: "Title of Book",
                                //         isDense: true,
                                //         focusColor: Color(0xff9B9B9B),
                                //         enabledBorder: UnderlineInputBorder(
                                //           borderSide: BorderSide(
                                //               width: 0.9,
                                //               color: Color(0xff9B9B9B)),
                                //         ),
                                //         focusedBorder: UnderlineInputBorder(
                                //           borderSide: BorderSide(
                                //               width: 0.9,
                                //               color: Color(0xff38AAFF)),
                                //         ),
                                //       ),
                                //       onChanged: (val) {
                                //         if (titleController.text.isEmpty ||
                                //             wordCount.text.isEmpty) {
                                //           isSubmitAllowed = false;
                                //         } else {
                                //           isSubmitAllowed = true;
                                //         }
                                //         print(isSubmitAllowed);
                                //         setState(() {});
                                //       },
                                //       style: GoogleFonts.lato(fontSize: 18),
                                //     )),
                                new Padding(padding: EdgeInsets.only(top: 30)),
                                new Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: new TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: wordCount,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: "Page count",
                                      
                                        focusColor: Color(0xff9B9B9B),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.3,
                                              color: Color(0xff9B9B9B)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 0.4,
                                              color: Color(0xff38AAFF)),
                                        ),
                                        
                                      ),
                                      onChanged: (val) {
                                        if (titleController.text.isEmpty ||
                                            wordCount.text.isEmpty) {
                                          isSubmitAllowed = false;
                                        } else {
                                          isSubmitAllowed = true;
                                        }
                                        setState(() {});
                                        print(isSubmitAllowed);
                                      },
                                      style: GoogleFonts.lato(fontSize: 18),
                                    )),
                                Padding(padding: EdgeInsets.only(top: 30)),
                                // new Container(
                                //     width:
                                //         MediaQuery.of(context).size.width * 0.9,
                                //     child: new TextFormField(
                                //       controller: titleController,
                                //       autofocus: true,
                                //       decoration: InputDecoration(
                                //         suffix: GestureDetector(
                                //           child: Text(
                                //             format.format(date),
                                //             style: GoogleFonts.dmSans(
                                //                 fontSize: 18,
                                //                 color: Color(0xff38AAFF)),
                                //             textAlign: TextAlign.right,
                                //           ),
                                //         ),
                                //         contentPadding: EdgeInsets.symmetric(
                                //             horizontal: 0, vertical: 5),
                                //         hintText: "Title of Book",
                                //         isDense: true,
                                //         focusColor: Color(0xff9B9B9B),
                                //         enabledBorder: UnderlineInputBorder(
                                //           borderSide: BorderSide(
                                //               width: 0.9,
                                //               color: Color(0xff9B9B9B)),
                                //         ),
                                //         focusedBorder: UnderlineInputBorder(
                                //           borderSide: BorderSide(
                                //               width: 0.9,
                                //               color: Color(0xff38AAFF)),
                                //         ),
                                //       ),
                                //       onChanged: (val) {
                                //         if (titleController.text.isEmpty ||
                                //             wordCount.text.isEmpty) {
                                //           isSubmitAllowed = false;
                                //         } else {
                                //           isSubmitAllowed = true;
                                //         }
                                //         print(isSubmitAllowed);
                                //         setState(() {});
                                //       },
                                //       style: GoogleFonts.lato(fontSize: 18),
                                //     )),
                                // Padding(padding: EdgeInsets.only(top: 30)),
                                Stack(
                                 // alignment: Alignment.bottomRight,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: new TextFormField(
                                           
                                            enabled: true,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              
                                              hintText: "Deadline",
                                              focusColor: Color(0xff9B9B9B),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.4,
                                                    color: Color(0xff9B9B9B)),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 0.4,
                                                    color: Color(0xff38AAFF)),
                                              ),
                                            ),
                                            style: GoogleFonts.lato(fontSize: 18),
                                          ),
                                      ),
                                    ),
                                    TextButton(
                                      
                                    // style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                                      onPressed: (){
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext builder) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                                child: CupertinoDatePicker(
                                                  initialDateTime: date,
                                                  mode: CupertinoDatePickerMode
                                                      .date,
                                                  minimumDate: DateTime.now()
                                                      .subtract(
                                                          Duration(days: 1)),
                                                  onDateTimeChanged: (newVal) {
                                                    setState(() {
                                                      date = newVal;
                                                    });
                                                  },
                                                ),
                                              );
                                            });
                                            FocusScope.of(context).unfocus();
                                      },
                                      child:Center(
                                        child: new Container(
                                          
                                          width: MediaQuery.of(context).size.width * 0.88,
                                           margin: EdgeInsets.only(bottom: 4),
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            format.format(date),
                                            style: GoogleFonts.dmSans(
                                                fontSize: 18,
                                                color: Color(0xff38AAFF)),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // Stack(
                                //   children: <Widget>[
                                //     Center(
                                //       child: new Container(
                                //         width:
                                //             MediaQuery.of(context).size.width *
                                //                 0.9,
                                //         child: new TextFormField(
                                //           keyboardType: TextInputType.number,
                                //           enabled: true,
                                //           decoration: InputDecoration(
                                //             isDense: true,
                                //             hintText: "Deadline",
                                //             focusColor: Color(0xff9B9B9B),
                                //             enabledBorder: UnderlineInputBorder(
                                //               borderSide: BorderSide(
                                //                   width: 0.9,
                                //                   color: Color(0xff9B9B9B)),
                                //             ),
                                //             focusedBorder: UnderlineInputBorder(
                                //               borderSide: BorderSide(
                                //                   width: 0.9,
                                //                   color: Color(0xff38AAFF)),
                                //             ),
                                //           ),
                                //           style: GoogleFonts.lato(fontSize: 18),
                                //         ),
                                //       ),
                                //     ),
                                //     FlatButton(
                                //       child: new Container(
                                //           width: MediaQuery.of(context)
                                //                   .size
                                //                   .width *
                                //               0.88,
                                //           child: Text(
                                //             format.format(date),
                                //             style: GoogleFonts.lato(
                                //                 fontSize: 18,
                                //                 color: Color(0xff38AAFF)),
                                //             textAlign: TextAlign.right,
                                //           )),
                                //       onPressed: () {
                                //         showModalBottomSheet(
                                //             context: context,
                                //             builder: (BuildContext builder) {
                                //               return Container(
                                //                 height: MediaQuery.of(context)
                                //                         .size
                                //                         .height *
                                //                     0.4,
                                //                 child: CupertinoDatePicker(
                                //                   initialDateTime: date,
                                //                   mode: CupertinoDatePickerMode
                                //                       .date,
                                //                   minimumDate: DateTime.now()
                                //                       .subtract(
                                //                           Duration(days: 1)),
                                //                   onDateTimeChanged: (newVal) {
                                //                     setState(() {
                                //                       date = newVal;
                                //                     });
                                //                   },
                                //                 ),
                                //               );
                                //             });
                                //         FocusScope.of(context).unfocus();
                                //         print('hello');
                                //         // DatePicker.showDatePicker(
                                //         //   context,
                                //         //   initialDateTime: date,
                                //         //   pickerMode: DateTimePickerMode.date,
                                //         //   onConfirm: (newVal, v) {
                                //         //     setState(() {
                                //         //       date = newVal;
                                //         //     s});
                                //         //   },
                                //         // );
                                //       },
                                //     )
                                //   ],
                                // ),
                                new Padding(padding: EdgeInsets.only(top: 10)),
                                new Text(
                                    "Float's deadline is always a day before your deadline.",
                                    style: GoogleFonts.lato(
                                        color: Colors.grey, fontSize: 14)),
                                new Padding(padding: EdgeInsets.only(top: 30)),
                                new GestureDetector(
                                  onTap: () async {
                                    if (date
                                            .add(Duration(days: 1))
                                            .difference(DateTime.now())
                                            .inDays <=
                                        0) {
                                      sorryModal(context: context);
                                      return;
                                    }
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    try {
                                      Random random = new Random();
                                      int randomNumber =
                                          random.nextInt(10000000);
                                      DocumentReference documentReference =
                                          await FirebaseFirestore.instance
                                              .collection('floats')
                                              .add({
                                        "title": titleController.text,
                                        "book": _isbook,
                                        "words": int.parse(wordCount.text),
                                        "wordsCompleted": 0,
                                        'average': (int.parse(wordCount.text) /
                                                date
                                                    .add(Duration(days: 1))
                                                    .difference(DateTime.now())
                                                    .inDays)
                                            .truncate(),
                                        "due": Timestamp.fromDate(date),
                                        "owner": FirebaseAuth
                                            .instance.currentUser.uid,
                                        'notificationId': randomNumber,
                                        'lastupdated': Timestamp.now(),
                                      });
                                      Provider.of<NotificationsProvider>(
                                              context,
                                              listen: false)
                                          .scheduleFloatNotification(
                                              title: titleController.text,
                                              words: '0',
                                              id: randomNumber,
                                              dueDate: date);
                                      setState(() {
                                        showSpinner = false;
                                      });
                                      Navigator.pop(context);
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                          msg: e.message.toString());
                                    }
                                  },
                                  child: isSubmitAllowed
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 56,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.cyan,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Text(
                                            "Done",
                                            style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: 72,
                                          padding: EdgeInsets.symmetric(vertical: 20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFF1EAEA),
                                              borderRadius:
                                                  BorderRadius.circular(5)),

                                          child: Text("Done",
                                              style: GoogleFonts.dmSans(
                                                  color: Color(0xFF9A9A9A),
                                                  fontSize: 24,
                                                
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}

class PaddedRaisedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const PaddedRaisedButton(
      {@required this.buttonText, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
      child: RaisedButton(child: Text(buttonText), onPressed: onPressed),
    );
  }
}
