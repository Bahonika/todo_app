import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/theme/theme.dart';
import 'package:todo_app/presentation/components/wrap_card.dart';
import 'package:todo_app/presentation/navigation/navigation_controller.dart';
import 'package:todo_app/presentation/providers/create_task_data_provider.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/presentation/localization/s.dart';

class TodoCreateScreen extends StatefulWidget {
  final bool isEdit;
  final Todo? todoForEdit;

  const TodoCreateScreen({Key? key, this.isEdit = false, this.todoForEdit})
      : super(key: key);

  @override
  State<TodoCreateScreen> createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends State<TodoCreateScreen> {
  void createTask() {
    Todo todo = context.read<CreateTaskDataProvider>().modelingTodo();
    context.read<TodosProvider>().createTodo(todo: todo);
    context.read<CreateTaskDataProvider>().eraseData();
  }

  void editTask() {
    Todo todo = context
        .read<CreateTaskDataProvider>()
        .modelingTodo(todo: widget.todoForEdit);
    context.read<TodosProvider>().updateTodo(todo);
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
            if (widget.isEdit) {
              context.read<CreateTaskDataProvider>().eraseData();
            }
            context.read<NavigationController>().pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (widget.isEdit) {
                editTask();
              } else {
                createTask();
              }
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
          children: [
            const TextFieldTile(),
            const ImportanceTile(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            const DateTile(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            DeleteTile(isDisabled: !widget.isEdit, todo: widget.todoForEdit),
            const SizedBox(
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

  @override
  void didChangeDependencies() {
    itemsFill(); // will fix in future
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
            context.read<CreateTaskDataProvider>().selectedImportance = value!;
          },
        ),
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  const DateTile({Key? key}) : super(key: key);

  static DateTime? tempPickedDate;

  Future<void> selectDate(BuildContext context) async {
    var createTaskProvider =
        Provider.of<CreateTaskDataProvider>(context, listen: false);

    String hintText = createTaskProvider.selectedDate.year.toString();
    DateTime initialDate = createTaskProvider.selectedDate;

    tempPickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      confirmText: S.of(context).datePickerDone,
      helpText: hintText,
    );
  }

  setSelectedDate(BuildContext context) {
    selectDate(context).then((value) {
      if (tempPickedDate != null) {
        context.read<CreateTaskDataProvider>().selectedDate = tempPickedDate!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(S.of(context).doneBy),
      subtitle: context.watch<CreateTaskDataProvider>().showDate
          ? InkWell(
              onTap: () => setSelectedDate(context),
              child: Text(
                MyDateFormat().localeFormat(
                    context.watch<CreateTaskDataProvider>().selectedDate),
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            )
          : const SizedBox(),
      trailing: Switch(
        value: context.watch<CreateTaskDataProvider>().showDate,
        activeTrackColor:
            Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
        activeColor: Theme.of(context).colorScheme.tertiary,
        onChanged: (bool value) {
          context.read<CreateTaskDataProvider>().showDate = value;
        },
      ),
    );
  }
}

class DeleteTile extends StatelessWidget {
  final bool isDisabled;
  final Todo? todo;

  const DeleteTile({Key? key, required this.isDisabled, this.todo})
      : super(key: key);

  Function()? delete(BuildContext context) {
    if (isDisabled) {
      return null;
    } else {
      Provider.of<TodosProvider>(context, listen: false).deleteTodo(todo!.uuid);
      context.read<NavigationController>().pop();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => delete(context),
      child: Row(
        children: [
          Icon(
            Icons.delete,
            color: isDisabled
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.errorContainer,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).delete,
              style: TextStyle(
                color: isDisabled
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.errorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
