import 'package:float/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

waitingModal({BuildContext context}) {
  showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: new Container(
              // height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 17.0, top: 55),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          floatAssets + 'tennis.png',
                          height: 58,
                          width: 49,
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Ball in the air',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            color: Color(0xff535353),
                            fontSize: 34),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Your opponent needs to hit over\nsome words before you can update',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                              color: Color(0xff535353),
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.13,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(2, 187, 211, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42)),
                      ),
                      child: Center(
                        child: Text(
                          'Got it',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        );
      });
}
