import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/models_services/auth_service.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';


class UserProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel _userx;
  UserModel get userx => _userx;

  double _accountBalanceBaseTotalAll = 0;
  get accountBalanceBaseTotalAll => _accountBalanceBaseTotalAll;

  double _accountBalanceAltTotalAll = 0;
  get accountBalanceAltTotalAll => _accountBalanceAltTotalAll;

/* --------- NOTE Store summary excluding isTracked = false --------- */
  double _accountBalanceBaseTotal = 0;
  get accountBalanceBaseTotal => _accountBalanceBaseTotal;

/* --------- NOTE Store summary excluding isTracked = false --------- */
  double _accountBalanceAltTotal = 0;
  num get accountBalanceAltTotal => _accountBalanceAltTotal;

  Future initState() async {
    var res = await AuthService.streamUserx();
    res.listen((r) {
      _userx = r;

      notifyListeners();
    });
  }
}
