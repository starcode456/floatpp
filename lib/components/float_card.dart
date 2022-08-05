import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/constants.dart';
import 'package:float/models/float_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Widget FloatCard(DocumentSnapshot snapshot) {
  var ref = snapshot.data();
  var s = " words today";
  var isBook = false;
  if(ref.containsKey('book')){
    print('book exist');
     isBook = true;
     s = " pages today";
  }
  else{
    print('book not exist');
   
  }
  FloatModel float = FloatModel.fromJson(snapshot.data());
  print(float.wordsCompleted);
  DateTime deadline =
      DateTime.fromMicrosecondsSinceEpoch(float.due.microsecondsSinceEpoch);
  int floatingwords;
  String todayWords;

  print(deadline.add(Duration(days: 1)).difference(DateTime.now()).inDays);
  print(float.average);

  Color remainingColor = Color.fromRGBO(34, 160, 195, 1);
  if (deadline.add(Duration(days: 1)).difference(DateTime.now()).inDays > 0) {
    var dw = (float.words + float.wordstoday) /
        deadline.add(Duration(days: 1)).difference(DateTime.now()).inDays;
    floatingwords = dw.truncate();
    print(floatingwords.truncate());
  } else {
    floatingwords = float.words;
  }
  // print(floatingwords);
  // print('${float.words + float.wordstoday}');
  // print(float.wordstoday);
  if (float.wordstoday != 0) {
    if (DateTime.fromMicrosecondsSinceEpoch(
                    float.lastupdated.microsecondsSinceEpoch)
                .difference(DateTime.now())
                .inDays ==
            0 &&
        float.wordstoday >= float.average) {
      todayWords = 'Floating';
    } else {
      todayWords = '${float.average - float.wordstoday}' + s;
    }
  } else {
    todayWords = '${float.average}' + s;
  }

  if (deadline.add(Duration(days: 1)).difference(DateTime.now()).inDays == 0) {
    remainingColor = Color(0xffe02020);
  }

  String leftText = deadline
          .add(Duration(days: 1))
          .difference(DateTime.now())
          .inDays
          .toString() +
      " days left";

  if (leftText == "0 days left") {
    leftText = "Due:${DateFormat('dd MMM yyyy').format(deadline)}";
  }
  if (leftText == "1 days left") {
    leftText = "Due";
  }
  if (leftText == "2 days left") {
    leftText = "Due Tomorrow";
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  return Container(
    child: Material(
      elevation: 1,
      child: Container(
        height: 110,
        color: Colors.white,
        padding: EdgeInsets.only(left: 18, top: 14, bottom: 17, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    truncateWithEllipsis(
                        float.state != null ? 28 : 38, float.title),
                    style: GoogleFonts.lato(
                        color: Color(0xFF9B9B9B),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                 
                ),
                
                isBook ? Expanded(child: Container(alignment: Alignment.bottomRight, child: Image.asset(profileAssets + 'book.png',width: 20,height: 20,),)) : Container(),
                float.state != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 16,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Color.fromRGBO(225, 255, 232, 1),
                            ),
                            child: Center(
                              child: Text(
                                '${float.points}-${float.rivalpoints}',
                                style: TextStyle(
                                    fontFamily: latoblackitalic,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Color.fromRGBO(26, 148, 5, 1)),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 6)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                float.state == 0
                                    ? 'Waiting...'
                                    : float.canupdate == false
                                        ? 'Waiting...'
                                        : float.state == 1
                                            ? "Let's Go!"
                                            : float.state == 2 ||
                                                    float.canupdate
                                                ? '${float.rivalwords} words'
                                                : '',
                                style: TextStyle(
                                    fontFamily: latoblackitalic,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromRGBO(74, 74, 74, 1)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Image.asset(
                                floatAssets + 'tennis.png',
                                height: 28,
                                width: 22,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(
                        height: 40,
                      )
              ],
            ),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(todayWords,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lato(
                            fontSize: 22, fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(leftText,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            color: remainingColor, //Color(0xFF22A0C3),
                            fontWeight: FontWeight.w700)),
                  ),
                ]),
          ],
        ),
      ),
    ),
  );
}
