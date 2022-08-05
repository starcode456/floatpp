import 'package:float/constants.dart';
import 'package:float/pages/floats_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinishedPage extends StatefulWidget {
  FinishedPage({Key key}) : super(key: key);
  @override
  _FinishedPageState createState() => _FinishedPageState();
}

class _FinishedPageState extends State<FinishedPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //mainAxisSize: MainAxisSize.max,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 90)),
                new Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Center(
                      child: Image.asset(essaytennisAssets + 'finished.png',
                          width: MediaQuery.of(context).size.width * 0.55),
                    ),
                    Padding(padding: EdgeInsets.only(top: 36)),
                    Text("You have finished!",
                        style: GoogleFonts.lato(
                            color: Color.fromRGBO(74, 74, 74, 1),
                            fontWeight: FontWeight.w700,
                            fontSize: 40)),
                    // Padding(padding: EdgeInsets.only(top: 42,)),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: new Text("This float will now be deleted.",
                          style: GoogleFonts.lato(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(
                  top: 102,
                )),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) {
                          return FloatsPage();
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(34, 160, 195, 1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      "Take me home",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
