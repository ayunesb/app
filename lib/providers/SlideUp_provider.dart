import 'package:flutter/material.dart';

class SlideUpProvider with ChangeNotifier {
  bool isShow = false;

  void updateState(bool newState) {
    isShow = newState;
    notifyListeners();
  }
}
