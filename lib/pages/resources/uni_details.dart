import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniDetails extends StatefulWidget {
  @override
  _UniDetailsState createState() => _UniDetailsState();
}

class _UniDetailsState extends State<UniDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff32a8ff),
        elevation: 0,
        centerTitle: true,
        title: Text("Your University/College",
            style: GoogleFonts.lato(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 24.0),
            textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      backgroundColor: Color(0xff32a8ff),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(
                "Your university is a place where you will be for some time. We want you to effortlessly connect with the right help wherever you are. We understand that university/college can be a lonely place due to the current circumstances and beyond.\n\n We have ‘I need some help’ which is linked to your university/college. Make sure that the university/college is spelt correctly. Tapping this will connect you to a number/email where you can get the help you need. ",
                style: GoogleFonts.lato(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0))),
      ),
    );
  }

  Widget TopBar() {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.12,
        ),
        Text(
          "Your University/College",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.07,
        ),
        IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: null)
      ],
    );
  }
}
