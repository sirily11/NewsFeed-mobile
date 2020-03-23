import 'package:flutter/material.dart';

class HomeControlProvider with ChangeNotifier {
  int _currentIndex = 1;

  int get currentIndex => this._currentIndex;

  set currentIndex(int index) {
    this._currentIndex = index;
    notifyListeners();
  }
}
