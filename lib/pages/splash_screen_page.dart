import 'package:float/pages/floats_page.dart';
import 'package:float/pages/onboarding_page.dart';
import 'package:float/pages/sign_in_page.dart';
import 'package:float/pages/unverified_page.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000)).then((value) async {
      User firebaseUser = await FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        if (firebaseUser.emailVerified) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FloatsPage(showGoogleAddOnModal: false)));
        } else {
          //Navigator.push(context, MaterialPageRoute(builder: (context) =>  UnverifiedPage()));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OnbaordingPage()));
        }
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OnbaordingPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Image.asset(
        'assets/images/splash/splash.png',
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
      ),
    ));
  }
}
