import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EssayTennisInfo extends StatelessWidget {
  static String routeName = 'essaytennisinfo';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(63, 214, 134, 1),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          'Essay Tennis Info',
          style: GoogleFonts.lato(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      backgroundColor: Color.fromRGBO(63, 214, 134, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: ListView(
          children: <Widget>[
            Text(
              "A player gets 1 point every time they successfully update the same or more as their opponent. \n\nA player gets 1 point when their opponent updates less then the words sent\n\nA player gets 1 point when their opponent does not update within 24 hours\n\nThe player with the most points upon completing their essay wins. The player that wins gets the victory along with an additional 5 points\n\nThe player with the least points when they finish their essay loses the game.\n\nPoints are given in singulars (1,2,3,4.... NOT in '15', '30'... like normal tennis.\n\nPlayers can choose to end the game and get no points. The other player wins by default and 5 points will go to the opponent.\n\nPlayers always have to wait for the player to send their updates.\n\nWhen a player sends less words, the opponent gets a point but still has to respond with the amount of words sent",
              style: GoogleFonts.lato(color: Colors.white, fontSize: 18,height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
