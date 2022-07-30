import 'package:flutter/material.dart';

class RevisionProvider with ChangeNotifier {
  int _revision = 0;

  int get revision => _revision;

  set revision(int value) {
    _revision = value;
    notifyListeners();
  }

}
