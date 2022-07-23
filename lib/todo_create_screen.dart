import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/wrapCard.dart';
import 'package:todo_app/providers/create_task_data_provider.dart';
import 'package:todo_app/s.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/providers/todos_provider.dart';

import 'data/entities/todo.dart';

class TodoCreateScreen extends StatefulWidget {
  const TodoCreateScreen({Key? key}) : super(key: key);

  @override
  State<TodoCreateScreen> createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends State<TodoCreateScreen> {
  createTask() {
    context.read<TodosProvider>().createTodo(
          importance:
              Provider.of<CreateTaskDataProvider>(context, listen: false)
                  .selectedImportance,
          text: Provider.of<CreateTaskDataProvider>(context, listen: false)
              .controller
              .text,
          deadline: (Provider.of<CreateTaskDataProvider>(context, listen: false)
                  .showData)
              ? Provider.of<CreateTaskDataProvider>(context, listen: false)
                  .selectedDate
              : null,
        );
    context.read<CreateTaskDataProvider>().eraseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              createTask();
              Navigator.pop(context);
            },
            child: Text(
              S.of(context).save,
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            TextFieldTile(),
            ImportanceTile(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            DateTile(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            DeleteTile(),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldTile extends StatelessWidget {
  const TextFieldTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WrapCard(
      child: TextFormField(
        controller: context.watch<CreateTaskDataProvider>().controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).needToDo,
            hintStyle: CustomTextTheme.importanceSubtitle(context),
            contentPadding: const EdgeInsets.all(15)),
        minLines: 5,
        maxLines: 50,
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
  List<DropdownMenuItem<Importance>> items = [];

  void itemsFill() {
    items = [
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
    ];
  }

  @override
  void didChangeDependencies() {
    itemsFill();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).importance),
      subtitle: DropdownButtonHideUnderline(
        child: DropdownButton<Importance>(
          itemHeight: 49,
          items: items,
          isDense: true,
          isExpanded: false,
          value: context
              .watch<CreateTaskDataProvider>()
              .selectedImportance,
          style: CustomTextTheme.importanceSubtitle(context),
          icon: const SizedBox(),
          onChanged: (value) {
              context
                  .read<CreateTaskDataProvider>()
                  .setImportance(value!);
          },
        ),
      ),
    );
  }
}


class DateTile extends StatelessWidget {
  const DateTile({Key? key}) : super(key: key);

  selectDate(BuildContext context) async {
    String hintText =
    Provider.of<CreateTaskDataProvider>(context, listen: false)
        .selectedDate
        .year
        .toString();
    DateTime initialDate =
        Provider.of<CreateTaskDataProvider>(context, listen: false)
            .selectedDate;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      confirmText: S.of(context).datePickerDone,
      helpText: hintText,
    );
    if (picked != null) {
      context.read<CreateTaskDataProvider>().setDatetime(picked);
    }
  }

  // setPickedData(DateTime picked) {
  //   context.read<CreateTaskDataProvider>().setDatetime(picked);
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).doneBy),
      subtitle: context.watch<CreateTaskDataProvider>().showData
          ? InkWell(
              onTap: () => selectDate(context),
              child: Text(
                DateFormat.yMMMMd().format(
                    context.watch<CreateTaskDataProvider>().selectedDate),
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            )
          : const SizedBox(),
      trailing: Switch(
        value: context.watch<CreateTaskDataProvider>().showData,
        activeTrackColor:
            Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
        activeColor: Theme.of(context).colorScheme.tertiary,
        onChanged: (bool value) {
          context.read<CreateTaskDataProvider>().toggleShowDate(value);
        },
      ),
    );
  }
}

class DeleteTile extends StatelessWidget {
  const DeleteTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Row(
        children: [
          Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.errorContainer,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).delete,
              style: TextStyle(
                color: Theme.of(context).colorScheme.errorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
