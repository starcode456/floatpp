import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'floats_page.dart';

class VerifiedPage extends StatefulWidget {
  VerifiedPage({Key key}) : super(key: key);

  @override
  _VerifiedPageState createState() => _VerifiedPageState();
}

class _VerifiedPageState extends State<VerifiedPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.grey),
            actions: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 30, top: 20),
                child: Text("3/3",
                  style: GoogleFonts.lato(
                    color: Color.fromRGBO(34, 160, 195, 1), 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      'You are now verified',
                      style: GoogleFonts.lato(
                          fontSize: 26,
                          color: Color(0xFF4A4A4A),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    new Image.asset(
                      'assets/onboard4.png',
                      
                      height: 250
                    ),
                  ],
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => new FloatsPage(showGoogleAddOnModal: true)));
                  },
                  child: new Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(34, 160, 195, 1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      "Let's Create a Float",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
