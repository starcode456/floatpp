import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/pages/onboarding_page.dart';
import 'package:float/pages/verified_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:float/models_providers/auth_provider.dart';

class UnverifiedPage extends StatefulWidget {
  final String password;
  UnverifiedPage({Key key, this.password}) : super(key: key);

  @override
  _UnverifiedPageState createState() => _UnverifiedPageState();
}

class _UnverifiedPageState extends State<UnverifiedPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.grey),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 30, top: 20),
            child: Text("2/3",
                style: GoogleFonts.lato(
                    color: Color.fromRGBO(34, 160, 195, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 40),
          Text(
            'Verify your Email',
            style: GoogleFonts.lato(
                fontSize: 26,
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'We sent you an email',
            style: GoogleFonts.lato(
                fontSize: 20,
                color: Color(0xFFB0B2BE),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 100),
          new Container(
              width: MediaQuery.of(context).size.width * 0.87,
              child: new Image.asset(
                'assets/unverified.png',
                height: 150,
              )),
          SizedBox(height: 60),
          new GestureDetector(
            onTap: () async {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              var res = await _auth.currentUser;
              try {
                // sign in user
                UserCredential result = await _auth.signInWithEmailAndPassword(
                    email: res.email, password: widget.password);
                User user = result.user;
                // if user's email is verified, move to verified page
                if (user.emailVerified) {
                  Fluttertoast.showToast(msg: "Email address verified");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new VerifiedPage()));
                } else {
                  Fluttertoast.showToast(msg: "Email address isn't verified.");
                }
              } catch (e) {
                print(e);
                Fluttertoast.showToast(msg: e.message.toString());
              }
            },
            child: new Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(34, 160, 195, 1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "Check Verification",
                style: GoogleFonts.lato(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 10),
          new FlatButton(
            child: Text("Resend email",
                style: GoogleFonts.lato(color: Colors.grey)),
            onPressed: () async {
              final FirebaseAuth _auth = FirebaseAuth.instance;

              var res = await _auth.currentUser;

              res.sendEmailVerification();

              Fluttertoast.showToast(msg: "Sent verification email...");
            },
          ),
          new FlatButton(
            child: Text("Create new account",
                style: GoogleFonts.lato(color: Colors.grey)),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new OnbaordingPage()));
            },
          ),
        ],
      ),
    );
  }
}
