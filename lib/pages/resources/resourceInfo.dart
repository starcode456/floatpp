import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourceInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffd08afe),
        elevation: 0,
        centerTitle: true,
        title: Text("Book Chats",
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
      backgroundColor: Color(0xffd08afe),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            child: Text(
                "Join a textbook with others that have the same resource. Comment and share your thoughts on the book you are studying from.\n\nWe provide the book title and connect you with students that are using the same book. You can ask questions and give insight to specific chapters within the book you are studying from. To pick up a copy of the book you just have to tap on the bag icon which will then send you to purchase the book.",
                style: GoogleFonts.lato(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.0))),
      ),
    );
  }
}
