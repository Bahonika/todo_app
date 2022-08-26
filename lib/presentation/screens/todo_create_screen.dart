import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/navigation/riverpod_navigation/segments.dart';
import 'package:todo_app/presentation/navigation/riverpod_navigation/navigation_providers.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';
import 'package:todo_app/presentation/components/wrap_card.dart';
import 'package:todo_app/presentation/localization/s.dart';
import 'package:todo_app/presentation/theme/custom_text_theme.dart';


class TodoCreateScreen extends ConsumerStatefulWidget {
  final Todo? todo;
  const TodoCreateScreen({this.todo, Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends ConsumerState<TodoCreateScreen> {
  void _createTask() {
    final paramsNotifier =
        ref.read(DataProviders.createParametersProvider(null).notifier);
    final generatedTodo = paramsNotifier.generateTodo();
    ref
        .read(DataProviders.todoListStateProvider.notifier)
        .create(generatedTodo);
  }

  void _editTask() {
    final todoForAlter = ref.read(DataProviders.todoProvider);
    final paramsNotifier =
        ref.read(DataProviders.createParametersProvider(todoForAlter).notifier);
    final alteredTodo = paramsNotifier.alterTodo();
    ref.read(DataProviders.todoListStateProvider.notifier).update(alteredTodo);
  }

  bool validating() {
    final todo = ref.read(DataProviders.todoProvider);
    final value = ref.read(DataProviders.createParametersProvider(todo).notifier).isCorrect;
    return value;
  }

  void _tapHandler() {
    if (validating()) {
      final todoForEdit = ref.read(DataProviders.todoProvider);
      final params =
          ref.read(DataProviders.createParametersProvider(todoForEdit));
      if (params.isEdit) {
        _editTask();
      } else {
        _createTask();
      }
      _pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).emptyField),
        ),
      );
    }
  }

  void _pop() {
    ref.read(NavigationProviders.routerDelegateProvider).navigate([
      TodosSegment(),
    ]);
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
          onPressed: () => _pop(),
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
    final todoForEdit = ref.watch(DataProviders.todoProvider);
    final parameters =
        ref.watch(DataProviders.createParametersProvider(todoForEdit));
    return WrapCard(
      child: TextFormField(
        controller: parameters.textEditingController,
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
    final todoForEdit = ref.watch(DataProviders.todoProvider);
    final parameters =
        ref.watch(DataProviders.createParametersProvider(todoForEdit));
    final parametersNotifier =
        ref.watch(DataProviders.createParametersProvider(todoForEdit).notifier);
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
              child: RichText(
                  text: TextSpan(
                style: CustomTextTheme.redText(context),
                children: [
                  TextSpan(text: S.of(context).importanceEmoji),
                  TextSpan(text: S.of(context).important),
                ],
              )),
            ),
          ],
          isDense: true,
          isExpanded: false,
          value: parameters.importance,
          style: CustomTextTheme.importanceSubtitle(context),
          icon: const SizedBox(),
          onChanged: (value) => parametersNotifier.importance = value!,
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
      final todoForEdit = ref.read(DataProviders.todoProvider);
      if (tempPickedDate != null) {
        ref
            .read(DataProviders.createParametersProvider(todoForEdit).notifier)
            .date = tempPickedDate!;
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoForEdit = ref.watch(DataProviders.todoProvider);
    final parameters =
        ref.watch(DataProviders.createParametersProvider(todoForEdit));
    final parametersNotifier =
        ref.watch(DataProviders.createParametersProvider(todoForEdit).notifier);
    return ListTile(
      title: Text(
        S.of(context).doneBy,
        style: CustomTextTheme.body(context),
      ),
      subtitle: parameters.showDate
          ? InkWell(
              onTap: () => setSelectedDate(context, ref),
              child: Text(
                MyDateFormat().localeFormat(parameters.date),
                style: TextStyle(
                    color:
                        Theme.of(context).extension<CustomColors>()!.colorBlue),
              ),
            )
          : const SizedBox(),
      trailing: Switch(
        value: parameters.showDate,
        activeTrackColor: Theme.of(context)
            .extension<CustomColors>()!
            .colorBlue
            .withOpacity(0.3),
        activeColor: Theme.of(context).extension<CustomColors>()!.colorBlue,
        onChanged: (bool value) => parametersNotifier.toggleShowDate(),
      ),
    );
  }
}

class DeleteTile extends ConsumerWidget {
  const DeleteTile({Key? key}) : super(key: key);

  void _pop(WidgetRef ref) {
    ref.read(NavigationProviders.routerDelegateProvider).navigate([
      TodosSegment(),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoForEdit = ref.watch(DataProviders.todoProvider);
    final parameters =
        ref.watch(DataProviders.createParametersProvider(todoForEdit));
    final stateController =
        ref.watch(DataProviders.todoListStateProvider.notifier);
    return TextButton(
      onPressed: () {
        if (parameters.isEdit) {
          stateController.delete(todoForEdit!);
          _pop(ref);
        }
      },
      style: TextButton.styleFrom(
          primary: Theme.of(context).scaffoldBackgroundColor),
      child: Row(
        children: [
          Icon(
            Icons.delete,
            color: parameters.isEdit
                ? Theme.of(context).extension<CustomColors>()!.colorRed
                : Theme.of(context).extension<CustomColors>()!.labelDisable,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).delete,
              style: TextStyle(
                color: parameters.isEdit
                    ? Theme.of(context).extension<CustomColors>()!.colorRed
                    : Theme.of(context).extension<CustomColors>()!.labelDisable,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
