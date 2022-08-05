import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/pages/unverified_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgot_password_page.dart';
import 'floats_page.dart';
import 'forgot_password_page.dart';
import 'sign_up_email_page.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool shouldContinue = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.grey),
          actions: <Widget>[],
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Log In',
                style: GoogleFonts.lato(
                    fontSize: 26,
                    color: Color(0xFF4A4A4A),
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: new TextFormField(
                onChanged: (val) {
                  if (passwordController.text.isEmpty ||
                      emailController.text.isEmpty) {
                    shouldContinue = false;
                  } else {
                    shouldContinue = true;
                  }
                  setState(() {});
                },
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email address",
                  focusColor: Colors.grey,
                ),
                style: GoogleFonts.lato(fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: new TextFormField(
                onChanged: (val) {
                  if (passwordController.text.isEmpty ||
                      emailController.text.isEmpty) {
                    shouldContinue = false;
                  } else {
                    shouldContinue = true;
                  }
                  setState(() {});
                },
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  focusColor: Colors.grey,
                ),
                style: GoogleFonts.lato(fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: GestureDetector(
                child: Text('Forgot Password',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.lato(fontSize: 17, color: Colors.grey)),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordPage()));
                },
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: new GestureDetector(
                onTap: () async {
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  try {
                    UserCredential authResult =
                        await _auth.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    User firebaseUser = await _auth.currentUser;

                    if (firebaseUser.emailVerified) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new FloatsPage(showGoogleAddOnModal: false)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new UnverifiedPage()));
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.message.toString());
                  }
                },
                child: new Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: shouldContinue
                        ? Color.fromRGBO(34, 160, 195, 1)
                        : Color(0xFFF0EAEA),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.lato(
                        fontSize: 20,
                        color: shouldContinue
                            ? Colors.white
                            : shouldContinue
                                ? Colors.white
                                : Color(0xFFC4C3C3),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
