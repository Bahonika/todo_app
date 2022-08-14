import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/providers/todos_controller.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';
import 'package:todo_app/presentation/components/wrap_card.dart';
import 'package:todo_app/presentation/localization/s.dart';
import 'package:todo_app/presentation/theme/custom_text_theme.dart';

class TodoCreateScreen extends ConsumerStatefulWidget {
  final Todo? todoForEdit;

  const TodoCreateScreen({Key? key, this.todoForEdit}) : super(key: key);

  @override
  ConsumerState createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends ConsumerState<TodoCreateScreen> {
  void createTask() {
    final todo = ref.read(todosController.notifier).generateTodo(ref);
    ref.read(todosController.notifier).create(todo);
  }

  void editTask() {
    final todoForEdit = ref.read(todoForEditProvider);
    final todo =
        ref.read(todosController.notifier).alterTodo(ref, todoForEdit!);
    ref.read(todosController.notifier).update(todo);
  }

  void _tapHandler() {
    if (ref.watch(isEditProvider)) {
      editTask();
    } else {
      createTask();
    }
    setDefaultDataAndPop();
  }

  void setDefaultDataAndPop() {
    ref.read(createScreenProvider.notifier).setDefaults(ref);
    ref.read(navigationProvider).pop();
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
            color: Theme.of(context).extension<CustomColors>()!.labelPrimary,
          ),
          onPressed: () => setDefaultDataAndPop(),
        ),
        actions: [
          TextButton(
            onPressed: () => _tapHandler(),
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
          children: const [
            TextFieldTile(),
            ImportanceTile(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            DateTile(),
            Divider(),
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

class TextFieldTile extends ConsumerWidget {
  const TextFieldTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WrapCard(
      child: TextFormField(
        controller: ref.watch(textControllerProvider),
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

class ImportanceTile extends ConsumerStatefulWidget {
  const ImportanceTile({Key? key}) : super(key: key);

  @override
  ConsumerState<ImportanceTile> createState() => _ImportanceTileState();
}

class _ImportanceTileState extends ConsumerState<ImportanceTile> {
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
          value: ref.watch(selectedImportanceProvider),
          style: CustomTextTheme.importanceSubtitle(context),
          icon: const SizedBox(),
          onChanged: (value) {
            ref.read(selectedImportanceProvider.notifier).setImportance(value!);
          },
        ),
      ),
    );
  }
}

class DateTile extends ConsumerWidget {
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

  void setSelectedDate(BuildContext context, WidgetRef ref) {
    selectDate(context).then((value) {
      if (tempPickedDate != null) {
        ref.read(selectedDateProvider.notifier).setDate(tempPickedDate!);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        S.of(context).doneBy,
        style: CustomTextTheme.body(context),
      ),
      subtitle: ref.watch(showDateProvider)
          ? InkWell(
              onTap: () => setSelectedDate(context, ref),
              child: Text(
                MyDateFormat().localeFormat(ref.watch(selectedDateProvider)!),
                style: TextStyle(
                    color:
                        Theme.of(context).extension<CustomColors>()!.colorBlue),
              ),
            )
          : const SizedBox(),
      trailing: Switch(
        value: ref.watch(showDateProvider),
        activeTrackColor: Theme.of(context)
            .extension<CustomColors>()!
            .colorBlue
            .withOpacity(0.3),
        activeColor: Theme.of(context).extension<CustomColors>()!.colorBlue,
        onChanged: (bool value) {
          ref.read(showDateProvider.notifier).toggle();
        },
      ),
    );
  }
}

class DeleteTile extends ConsumerWidget {
  const DeleteTile({Key? key}) : super(key: key);

  void delete(WidgetRef ref) {
    if (!ref.watch(isEditProvider)) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () => delete(ref),
      style: TextButton.styleFrom(
          primary: Theme.of(context).scaffoldBackgroundColor),
      child: Row(
        children: [
          Icon(
            Icons.delete,
            color: ref.watch(isEditProvider)
                ? Theme.of(context).extension<CustomColors>()!.labelDisable
                : Theme.of(context).extension<CustomColors>()!.colorRed,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).delete,
              style: TextStyle(
                color: ref.watch(isEditProvider)
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
