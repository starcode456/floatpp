import 'package:float/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

endgameModal({BuildContext context, Function endgame}) {
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
                    //mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey,
                          ),
                          onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14.0, top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          floatAssets + 'wow.png',
                          height: 60,
                          width: 50,
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Are You Sure?',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(64, 64, 64, 1),
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
                          'By ending the game, your opponent\n will win by default. No points given.  ',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                              color: Color.fromRGBO(64, 64, 64, 1),
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print('endgame');
                      endgame();
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
                          'I am sure',
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
