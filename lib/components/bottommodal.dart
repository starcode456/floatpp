import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

Future showBottomModal(
    {BuildContext context,
    String title,
    String subtitle,
    String buttonText,
    @required Function ontap}) {
  return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          child: new Container(
              // height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Wrap(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          floatAssets + 'modaltennis.png',
                          height: 80,
                          width: MediaQuery.of(context).size.width / 2.2,
                        ),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          title,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(64, 64, 64, 1),
                              fontSize: 30),
                        ),
                      )
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              color: Color.fromRGBO(64, 64, 64, 1),
                              fontSize: 16),
                        ),
                      )
                    ],
                  ),

                  InkWell(
                    onTap:(){
                      ontap();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(2, 187, 211, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42)),
                      ),
                      child: Center(
                        child: Text(
                          buttonText,
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
