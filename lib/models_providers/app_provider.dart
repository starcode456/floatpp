import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  int _selectedPageIndex = 0;
  int get selectedPageIndex => _selectedPageIndex;

/* ---- NOTE If we are using the init state we should set isInit to true ---- */
  void setSelectedPageIndex({int index, bool isInit = false}) {
    _selectedPageIndex = index;
    if (!isInit) notifyListeners();
  }
}
