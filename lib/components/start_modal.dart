import 'package:float/models/float_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

startModalSheet(
    {BuildContext context, FloatModel floatModel, Function startGame}) {
      String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey,
                          ),
                          onPressed: () => Navigator.pop(context))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          truncateWithEllipsis( 23,  floatModel.title),
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(140, 140, 140, 1),
                              fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          floatAssets + 'locked.png',
                          height: 23,
                          width: 17,
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'You will serve first.\nUpdate to get the\ngame going. ',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(64, 64, 64, 1),
                            fontSize: 30),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Player with the most points wins',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(2, 187, 211, 1),
                              fontSize: 14),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      startGame();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(2, 187, 211, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42)),
                      ),
                      child: Center(
                        child: Text(
                          'Start Game',
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
