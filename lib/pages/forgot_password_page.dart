import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  int _counter = 0;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Reset Password",
                style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            new Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: new TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    focusColor: Colors.grey,
                  ),
                  style: GoogleFonts.lato(fontSize: 18),
                )),
            new Padding(padding: EdgeInsets.only(top: 10)),
            new GestureDetector(
              onTap: () async {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                try {
                  _auth.sendPasswordResetEmail(email: emailController.text);
                  Fluttertoast.showToast(msg: "Password reset email sent!");
                  Navigator.pop(context);
                } catch (e) {
                  Fluttertoast.showToast(msg: e.message.toString());
                }
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
                  "Send Reset Email",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
