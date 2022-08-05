import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:float/models_services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:float/app_utils/bot_toast_custom.dart';


import '../app_utils/get_it.dart';
import '../app_utils/navigator.dart';
import '../models/update.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAppStarting = true;
  bool get sAppStarting => _isAppStarting;

  UserModel _userx;
  UserModel get userx => _userx;

  Update _updatex = Update();

  bool _shouldContinue = true;

  Future initStateLogin() async {
    _userx = await AuthService.getUserx();

    if (_userx == null && _isAppStarting) {
      locator<NavigationService>().navigateTo('/onboarding_page');
      _isAppStarting = false;
      print(_isAppStarting);
    }

    if (_userx != null) {
      Stream<UserModel> streamUser = await AuthService.streamUserx();
      streamUser.listen((res) {
        _userx = res;
        if (res == null) {
          locator<NavigationService>().navigateTo('/login_page');
        }
      });

      Stream<Update> update = await AuthService.streamUpdate();
      update.listen((res) async {
        _updatex = res;
        if (_userx != null) {
          if (_updatex.appVersionLocal < _updatex.appVersionServer && _updatex.isUpdateMandatory) {
            locator<NavigationService>().navigateTo('/update_app_page');
          } else {
            locator<NavigationService>().navigateTo('/bottom_navbar_page');
          }
        }
      });

      auth.FirebaseAuth.instance.idTokenChanges().listen((res) async {
        if (res == null) {
          locator<NavigationService>().navigateTo('/login_page');
        }
      });

      AuthService.updateAppVersionLastLogin();
    }
   // BotToastCustom.loadingClose();

    return _shouldContinue;
  }

  Future updateNotificationStatus(bool status) async {
    await AuthService.updateNotificationStatus(status);
  }

  Future<bool> googleSignIn() async {

    auth.User user = await AuthService.googleSignIn();
    

    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
   Future<bool> appleSignIn() async {

    auth.User user = await AuthService.appleSignIn();
    

    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future registerUserEmailAndPassword(UserRegister userRegister) async {
   // BotToastCustom.loadingShow();

    var _user = await AuthService.registerUserEmailAndPassword(userRegister: userRegister);

    if (_user == null) {
      //BotToastCustom.textShow(text: 'Oops something went wrong!');
    }

    if (_user != null) {
      initStateLogin();
    }
  }

  Future signInUserEmailAndPassword(String email, String password) async {
   // BotToastCustom.loadingShow();
    auth.User _user = await AuthService.signInUserEmailAndPassword(email: email, password: password);

    if (_user == null) {
      //BotToastCustom.textShow(text: 'Oops something went wrong!');
    }

    if (_user != null) {
      initStateLogin();
    }
  }

  Future resetPassword(String email) async {
   // BotToastCustom.loadingShow();
    String res = await AuthService.resetPassword(email: email);

    if (res != null) {
     // BotToastCustom.textShow(text: res);

      await Future.delayed(Duration(seconds: 2));

      locator<NavigationService>().navigateTo('/login_page');
    }

    if (res == null) {
     // BotToastCustom.textShow(text: 'Oops something went wrong!');
    }
  }

  Future signOut() async {
    AuthService.signOut();
  }
}
