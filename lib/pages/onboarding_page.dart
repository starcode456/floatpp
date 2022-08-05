import 'package:carousel_slider/carousel_slider.dart';

import 'package:float/constants.dart';
import 'package:float/models_providers/auth_provider.dart';
import 'package:float/pages/floats_page.dart';
import 'package:float/pages/sign_in_page.dart';
import 'package:float/pages/sign_up_email_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:back_pressed/back_pressed.dart';
import 'package:url_launcher/url_launcher.dart';

class OnbaordingPage extends StatefulWidget {
  OnbaordingPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _OnbaordingPageState createState() => _OnbaordingPageState();
}

class _OnbaordingPageState extends State<OnbaordingPage> {
  int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: OnBackPressed(
        perform: () {
          // print('The back button on the device was pressed');
        },
        child: Scaffold(
          // backgroundColor: Colors.blue[300],
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(108, 176, 227, 1),
                  Color.fromRGBO(58, 120, 194, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new FlatButton(
                      child: new Container(
                        child: new Text(
                          "Log In",
                          style: GoogleFonts.lato(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new SignInPage()));
                      },
                    ),
                  ],
                ),
                new Container(
                    margin: EdgeInsets.symmetric(horizontal: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          signupAssets + 'float.png',
                          height: 23,
                          width: 111,
                        ),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.52
                          : MediaQuery.of(context).size.height * 0.9,
                      onPageChanged: (index, i) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),

                    // enableInfiniteScroll: false,
                    // aspectRatio: orientation == Orientation.portrait ? 1.1 : 1.7,

                    items: <Widget>[
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            signupAssets + 'essaytennis.png',
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? deviceHeight * 0.37
                                : MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width * 0.884,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: Text(
                              'Play essay tennis\n with friends',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: latoblack,
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Image.asset(
                            signupAssets + 'wordcount.png',
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? deviceHeight * 0.364
                                : MediaQuery.of(context).size.height * 0.6,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: Text(
                              'Manage your\n essay word count',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: latoblack,
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            signupAssets + 'deadline.png',
                            width: deviceWidth * 0.70,
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? deviceHeight * 0.38
                                : MediaQuery.of(context).size.height * 0.6,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text(
                              'Never miss a\ndeadline again',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: latoblack,
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 29.0,
                        height: 2.0,
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: _current == 0
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(255, 255, 255, 0.4),
                        ),
                      ),
                      Container(
                        width: 29.0,
                        height: 2.0,
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: _current == 1
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(255, 255, 255, 0.4),
                        ),
                      ),
                      Container(
                        width: 29.0,
                        height: 2.0,
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: _current == 2
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(255, 255, 255, 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue with:',
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 19.2),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          bool result = await authProvider.appleSignIn();
                          print(result);
                          if (result) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    new FloatsPage(showGoogleAddOnModal: true),
                              ),
                            );
                          }
                        },
                        child: Image.asset(
                          signupAssets + 'apple.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      InkWell(
                        onTap: () async {
                          bool result = await authProvider.googleSignIn();
                          print(result);
                          if (result) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    new FloatsPage(showGoogleAddOnModal: true),
                              ),
                            );
                          }
                        },
                        child: Image.asset(
                          signupAssets + 'google.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                      SizedBox(
                        width: 32,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpEmailPage()));
                        },
                        child: Image.asset(
                          signupAssets + 'email.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: () async {
                //     bool result = await authProvider.googleSignIn();
                //     print(result);
                //     if (result) {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) =>
                //               new FloatsPage(showGoogleAddOnModal: true),
                //         ),
                //       );
                //     }
                //   },
                //   child: new Container(
                //     margin: EdgeInsets.symmetric(horizontal: 15.0),
                //     height: orientation == Orientation.portrait
                //         ? MediaQuery.of(context).size.height * 0.097
                //         : deviceHeight * 0.18,
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         Container(
                //             child: Image.asset(
                //           signupAssets + 'google.png',
                //           height: 29,
                //           width: 28,
                //         )),
                //         SizedBox(
                //           width: 13,
                //         ),
                //         Text(
                //           "Continue with Google",
                //           style: GoogleFonts.lato(
                //             fontSize: 20,
                //             fontWeight: FontWeight.w700,
                //             color: Color.fromRGBO(74, 74, 74, 1),
                //           ),
                //           textAlign: TextAlign.center,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(padding: EdgeInsets.only(top: 10)),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (context) => SignUpEmailPage()));
                //   },
                //   child: new Container(
                //     margin: EdgeInsets.symmetric(horizontal: 15.0),
                //     height: orientation == Orientation.portrait
                //         ? MediaQuery.of(context).size.height * 0.097
                //         : deviceHeight * 0.18,
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //       color: Color.fromRGBO(9, 119, 192, 1),
                //       borderRadius: BorderRadius.circular(6),
                //     ),
                //     child: Text(
                //       "Continue with Email",
                //       style: GoogleFonts.lato(
                //           fontSize: 20,
                //           fontWeight: FontWeight.w700,
                //           color: Colors.white),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("By signing up you accept our ",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 14)),
                      new GestureDetector(
                          onTap: () {
                            launch("https://www.thefloatapp.com/terms");
                          },
                          child: Text("Terms",
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline))),
                      new Text(" & ",
                          style: GoogleFonts.lato(color: Colors.white)),
                      new GestureDetector(
                        onTap: () {
                          launch("https://www.thefloatapp.com/privacy-policy");
                        },
                        child: new Text("Privacy Policy",
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 14,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
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
