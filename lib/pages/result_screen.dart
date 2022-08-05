import 'package:float/models/user.dart';
import 'package:float/pages/profile/account_page.dart';
import 'package:float/pages/floats_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class ResultScreen extends StatelessWidget {
  static String routeName = 'Youwon page';
  final String result;
  final UserModel userModel;
  ResultScreen({@required this.result, @required this.userModel});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //  mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      result,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize: 70,
                          color: Color.fromRGBO(74, 74, 74, 1)),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.all(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GameWidget(
                      assetPath: profileAssets + 'gameswon.png',
                      number: '${userModel.gameswon}',
                      title: 'Games Won',
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    GameWidget(
                      assetPath: profileAssets + 'points.png',
                      number: '${userModel.points}',
                      title: 'Points',
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                            height: 65,
                            width: 105,
                            child: Center(
                              child: Image.asset(
                                  profileAssets + 'gamesplayed.png'),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '     ${userModel.gamesplayed}',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: Color.fromRGBO(74, 74, 74, 1)),
                        ),
                        Text(
                          '            Games Played',
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color.fromRGBO(74, 74, 74, 1)),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => FloatsPage())),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.09,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(34, 160, 195, 1),
                    borderRadius: BorderRadius.circular(32)),
                child: Center(
                  child: Text(
                    'Take me home',
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(30)),
          ],
        ),
      ),
    );
  }
}
