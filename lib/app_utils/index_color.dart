import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IndexColor {
  static Color getColor({@required index}) {
    var remainder = index % 10;
    int colorVal = 100;
    var color;
    switch (remainder) {
      case 0:
        color = Colors.blue[colorVal];
        break;
      case 1:
        color = Colors.red[colorVal];
        break;
      case 2:
        color = Colors.teal[colorVal];
        break;
      case 3:
        color = Colors.green[colorVal];
        break;
      case 4:
        color = Colors.blueGrey[colorVal];
        break;
      case 5:
        color = Colors.yellow[colorVal];
        break;
      case 6:
        color = Colors.indigo[colorVal];
        break;
      case 7:
        color = Colors.cyan[colorVal];
        break;
      case 8:
        color = Colors.green[colorVal];
        break;
      case 9:
        color = Colors.deepPurple[colorVal];
        break;
      default:
        return color = Colors.blue[colorVal];
    }
    return color;
  }
}
