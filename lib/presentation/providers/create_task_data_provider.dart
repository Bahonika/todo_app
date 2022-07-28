import 'package:flutter/material.dart';
import 'package:todo_app/domain/enums/importance.dart';

class CreateTaskDataProvider with ChangeNotifier{
  //Variables
  bool _showDate = false;
  Importance _selectedImportance = Importance.basic;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _controller = TextEditingController();

  //Getters
  bool get showData => _showDate;
  Importance get selectedImportance => _selectedImportance;
  DateTime get selectedDate => _selectedDate;
  TextEditingController get controller => _controller;

  //Setters
  toggleShowDate(bool value) {
    _showDate = value;
    notifyListeners();
  }

  setImportance(Importance newImportance){
    _selectedImportance = newImportance;
    notifyListeners();
  }

  setDatetime(DateTime newDatetime){
    _selectedDate = newDatetime;
    notifyListeners();
  }

  setControllerText(String text)
  {
    _controller.text = text;
    notifyListeners();
  }

  eraseData(){
    setImportance(Importance.basic);
    setDatetime(DateTime.now());
    setControllerText("");
    notifyListeners();
  }
}
