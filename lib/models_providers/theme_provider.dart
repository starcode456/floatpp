import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;

  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? lightTheme : darkTheme;

  getCurrentStatusNavigationBarColor() {
    if (isLightTheme) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: lightTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: darkTheme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  toggleThemeData() {
    isLightTheme = !isLightTheme;
    getCurrentStatusNavigationBarColor();
    notifyListeners();
  }
}

/* ----------------------------- NOTE Light Theme --------------------------- */
final lightTheme = ThemeData(
  fontFamily: 'GoogleSans',
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: Color(0xFFFFFFFF),
  scaffoldBackgroundColor: Color(0xFFF9F9F9),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.black12,
  buttonColor: Color(0xFF70ACF4),
  appBarTheme: AppBarTheme(elevation: 0.0, color: Color(0xFFF9F9F9)),
  focusColor: Colors.blue[200],
  errorColor: Colors.red[200],
  textTheme: TextTheme(),
);

/* ----------------------------- NOTE Dark Theme ---------------------------- */
final darkTheme = ThemeData(
    fontFamily: 'GoogleSans',
    primarySwatch: Colors.grey,
    primaryColor: Color(0xFF1E1F28),
    brightness: Brightness.dark,
    backgroundColor: Color(0xFF2A2C36),
    scaffoldBackgroundColor: Color(0xFF1E1F28),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.white12,
    buttonColor: Color(0xFFEF3651),
    appBarTheme: AppBarTheme(elevation: 0.0, color: Color(0xFF1E1F28)),
    textTheme: TextTheme());
