import 'package:flutter/material.dart';
import 'package:todo_app/domain/enums/importance.dart';

@immutable
class CreateScreenParameters {
  final bool isEdit;
  final DateTime date;
  final Importance importance;
  final bool showDate;
  final TextEditingController textEditingController;

  const CreateScreenParameters({
    required this.isEdit,
    required this.date,
    required this.importance,
    required this.showDate,
    required this.textEditingController,
  });

  CreateScreenParameters copyWith({
    bool? isEdit,
    DateTime? date,
    Importance? importance,
    bool? showDate,
    TextEditingController? textEditingController,
  }) {
    return CreateScreenParameters(
      isEdit: isEdit ?? this.isEdit,
      date: date ?? this.date,
      importance: importance ?? this.importance,
      showDate: showDate ?? this.showDate,
      textEditingController:
          textEditingController ?? this.textEditingController,
    );
  }

  static final defaultParameters = CreateScreenParameters(
    isEdit: false,
    date: DateTime.now(),
    importance: Importance.basic,
    showDate: false,
    textEditingController: TextEditingController(),
  );
}
