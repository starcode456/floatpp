import 'package:float/pages/unverified_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:float/models_providers/auth_provider.dart';
import 'package:float/models/user.dart';

class SignUpEmailPage extends StatefulWidget {
  SignUpEmailPage({
    Key key,
  }) : super(key: key);

  @override
  _SignUpEmailPageState createState() => _SignUpEmailPageState();
}

class _SignUpEmailPageState extends State<SignUpEmailPage> {
  bool shouldContinue = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
              child: Text("1/3",
                  style: GoogleFonts.lato(
                    color: Color.fromRGBO(34, 160, 195, 1), 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold
                  )),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Sign Up',
                style: GoogleFonts.lato(
                  fontSize: 26, 
                  color: Color(0xFF4A4A4A), 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: new TextFormField(
                onChanged: (val) {
                  if (nameController.text.isEmpty || passwordController.text.isEmpty || emailController.text.isEmpty) {
                    shouldContinue = false;
                  } else {
                    shouldContinue = true;
                  }
                  setState(() {});
                },
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Full name",
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
                  if (nameController.text.isEmpty || passwordController.text.isEmpty || emailController.text.isEmpty) {
                    shouldContinue = false;
                  } else {
                    shouldContinue = true;
                  }
                  setState(() {});
                },
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email Address",
                  focusColor: Colors.grey,
                ),
                style: GoogleFonts.lato(fontSize: 18),
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: TextFormField(
                onChanged: (val) {
                  if (nameController.text.isEmpty || passwordController.text.isEmpty || emailController.text.isEmpty) {
                    shouldContinue = false;
                  } else {
                    shouldContinue = true;
                  }
                  setState(() {});
                },
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  focusColor: Colors.grey,
                ),
                obscureText: true,
                style: GoogleFonts.lato(fontSize: 18),
              ),
            ),
            SizedBox(height: 70),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: new GestureDetector(
                onTap: () async {
                  if (shouldContinue) {
                    try {
                      /*
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      FirebaseUser firebaseUser = await _auth.currentUser();
                      print(firebaseUser.email);
                      firebaseUser.sendEmailVerification();
                      */
                      
                      await authProvider.registerUserEmailAndPassword(UserRegister(fullname: nameController.text, email: emailController.text, password: passwordController.text));
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new UnverifiedPage(password: passwordController.text)));
                    } catch (e) {
                      Fluttertoast.showToast(msg: e.message.toString());
                    }
                  }
                },
                child: new Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: shouldContinue ? Color.fromRGBO(34, 160, 195, 1) : Color(0xFFF0EAEA),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.lato(
                      fontSize: 20, color: shouldContinue ? Colors.white : Color(0xFFC4C3C3),
                      fontWeight: FontWeight.bold
                      ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
