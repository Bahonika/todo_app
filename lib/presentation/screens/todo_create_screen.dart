import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';
import 'package:todo_app/presentation/components/wrap_card.dart';
import 'package:todo_app/presentation/localization/s.dart';
import 'package:todo_app/presentation/theme/custom_text_theme.dart';

class TodoCreateScreen extends StatefulWidget {
  final bool isEdit;
  final Todo? todoForEdit;

  const TodoCreateScreen({Key? key, this.isEdit = false, this.todoForEdit})
      : super(key: key);

  @override
  State<TodoCreateScreen> createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends State<TodoCreateScreen> {
  void createTask() {}

  void editTask() {}

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).extension<CustomColors>()!.labelPrimary,
            ),
            onPressed: () {
              ref.read(navigationProvider).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(navigationProvider).pop();
              },
              child: Text(
                S.of(context).save,
                style: TextStyle(
                    color:
                        Theme.of(context).extension<CustomColors>()!.colorBlue),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextFieldTile(),
              const ImportanceTile(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
              const DateTile(),
              const Divider(),
              DeleteTile(isDisabled: !widget.isEdit, todo: widget.todoForEdit),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class TextFieldTile extends StatelessWidget {
  const TextFieldTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WrapCard(
      child: TextFormField(
        controller: TextEditingController(),
        style: CustomTextTheme.body(context),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: S.of(context).needToDo,
          hintStyle: CustomTextTheme.importanceSubtitle(context),
          contentPadding: const EdgeInsets.all(15),
        ),
        minLines: 5,
        maxLines: null,
      ),
    );
  }
}

class ImportanceTile extends StatefulWidget {
  const ImportanceTile({Key? key}) : super(key: key);

  @override
  State<ImportanceTile> createState() => _ImportanceTileState();
}

class _ImportanceTileState extends State<ImportanceTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        S.of(context).importance,
        style: CustomTextTheme.body(context),
      ),
      subtitle: DropdownButtonHideUnderline(
        child: DropdownButton<Importance>(
          itemHeight: 49,
          items: [
            DropdownMenuItem(
              value: Importance.basic,
              child: Text(S.of(context).basic),
            ),
            DropdownMenuItem(
              value: Importance.low,
              child: Text(S.of(context).low),
            ),
            DropdownMenuItem(
              value: Importance.important,
              child: Text(S.of(context).important),
            ),
          ],
          isDense: true,
          isExpanded: false,
          value: Importance.basic,
          style: CustomTextTheme.importanceSubtitle(context),
          icon: const SizedBox(),
          onChanged: (value) {},
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  const DateTile({Key? key}) : super(key: key);

  static DateTime? tempPickedDate;

  Future<void> selectDate(BuildContext context) async {
    final String hintText = DateTime.now().year.toString();
    final DateTime initialDate = DateTime.now();

    tempPickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      confirmText: S.of(context).datePickerDone,
      helpText: hintText,
    );
  }

  void setSelectedDate(BuildContext context) {
    selectDate(context).then((value) {
      if (tempPickedDate != null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        S.of(context).doneBy,
        style: CustomTextTheme.body(context),
      ),
      subtitle: true
          ? InkWell(
              onTap: () => setSelectedDate(context),
              child: Text(
                MyDateFormat().localeFormat(DateTime.now()),
                style: TextStyle(
                    color:
                        Theme.of(context).extension<CustomColors>()!.colorBlue),
              ),
            )
          : const SizedBox(),
      trailing: Switch(
        value: true,
        activeTrackColor: Theme.of(context)
            .extension<CustomColors>()!
            .colorBlue
            .withOpacity(0.3),
        activeColor: Theme.of(context).extension<CustomColors>()!.colorBlue,
        onChanged: (bool value) {},
      ),
    );
  }
}

class DeleteTile extends ConsumerWidget {
  final bool isDisabled;
  final Todo? todo;

  const DeleteTile({Key? key, required this.isDisabled, this.todo})
      : super(key: key);

  void delete(BuildContext context) {
    if (!isDisabled) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => delete(context),
      style: TextButton.styleFrom(
          primary: Theme.of(context).scaffoldBackgroundColor),
      child: Row(
        children: [
          Icon(
            Icons.delete,
            color: isDisabled
                ? Theme.of(context).extension<CustomColors>()!.labelDisable
                : Theme.of(context).extension<CustomColors>()!.colorRed,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).delete,
              style: TextStyle(
                color: isDisabled
                    ? Theme.of(context).extension<CustomColors>()!.labelDisable
                    : Theme.of(context).extension<CustomColors>()!.colorRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
