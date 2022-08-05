import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

Future showRequestModal(
    {BuildContext context,
    String profilePic,
    String name,
    String requestId,
    String selectedRequestId,
    Function onAccept}) {
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
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Container(
                                  height: 52,
                                  width: 52,
                                  child: CircleAvatar(
                                    radius: 62,
                                    backgroundColor: Colors.transparent,
                                    // backgroundImage: AssetImage(
                                    //     essaytennisAssets + 'story.png'),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: profilePic != null
                                          ? NetworkImage(profilePic)
                                          : AssetImage(
                                              profileAssets + 'profile.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(64, 64, 64, 1),
                                      fontSize: 20),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 51, top: 38),
                        child: Text(
                          'You have an Essay\nTennis request',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                              color: Color.fromRGBO(64, 64, 64, 1),
                              fontSize: 32),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        Positioned(
                          right:0,
                          child: InkWell(
                            onTap: () {
                              onAccept();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width / 1.8,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(2, 187, 211, 1),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(42)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: Text(
                                    'Yes',
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: InkWell(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(selectedRequestId)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('floats')
                                  .doc(requestId)
                                  .set(
                                      {'state': null}, SetOptions(merge: true));
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width / 2.1,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(211, 40, 2, 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(42),
                                    topRight: Radius.circular(42)),
                              ),
                              child: Center(
                                child: Text(
                                  'No',
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        );
      });
}
