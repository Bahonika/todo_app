import 'package:flutter/foundation.dart';

class NavigationState with ChangeNotifier {
  bool _isTodos;
  String? _todoUuid;
  NavigationState(this._isTodos, this._todoUuid);

  bool get isTodos => _isTodos;
  String? get todoUuid => _todoUuid;
  set isTodos(bool val) {
    _isTodos = val;
    notifyListeners();
  }

  set todoUuid(String? val) {
    _todoUuid = val;
    notifyListeners();
  }

  @override
  String toString() => "Welcome: $_isTodos, book: $_todoUuid";
}
