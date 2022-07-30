import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/presentation/components/wrapCard.dart';
import 'package:todo_app/presentation/navigation/navigation_controller.dart';
import 'package:todo_app/presentation/providers/create_task_data_provider.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/s.dart';
import 'package:todo_app/theme.dart';

class TodoCreateScreen extends StatefulWidget {
  const TodoCreateScreen({Key? key}) : super(key: key);

  @override
  State<TodoCreateScreen> createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends State<TodoCreateScreen> {
  createTask() {
    var todoCreate =
        Provider.of<CreateTaskDataProvider>(context, listen: false);
    context.read<TodosProvider>().createTodo(
          importance: todoCreate.selectedImportance,
          text: todoCreate.controller.text,
          deadline: todoCreate.showData ? todoCreate.selectedDate : null,
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
            context.read<NavigationController>().pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              createTask();
              context.read<NavigationController>().pop();
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

  //need fill function because of using context inside
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

  //todo: not the best way I think
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
          value: context.watch<CreateTaskDataProvider>().selectedImportance,
          style: CustomTextTheme.importanceSubtitle(context),
          icon: const SizedBox(),
          onChanged: (value) {
            context.read<CreateTaskDataProvider>().setImportance(value!);
          },
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  const DateTile({Key? key}) : super(key: key);

  Future<void> selectDate(BuildContext context) async {
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
      //todo: fix maybe
      context.read<CreateTaskDataProvider>().setDatetime(picked);
    }
  }

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
