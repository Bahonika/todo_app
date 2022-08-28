import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo_list_state.dart';
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/navigation/delegate.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';
import 'package:todo_app/presentation/components/wrap_card.dart';
import 'package:todo_app/presentation/localization/s.dart';
import 'package:todo_app/presentation/theme/custom_text_theme.dart';

class TodoCreateScreen extends ConsumerStatefulWidget {
  final String? todoUuid;

  const TodoCreateScreen({this.todoUuid, Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends ConsumerState<TodoCreateScreen> {
  @override
  void initState() {
    ref.read(DataProviders.todoProvider.notifier).setTodo(widget.todoUuid);
    super.initState();
  }

  void _tapHandler() {
    final paramsNotifier = ref.read(DataProviders.parametersProvider.notifier);
    final stateController =
        ref.read(DataProviders.todoListStateProvider.notifier);
    final params = ref.read(DataProviders.parametersProvider);

    if (paramsNotifier.isCorrect) {
      final todo = paramsNotifier.generateTodo();
      if (params.isEdit) {
        stateController.update(todo);
      } else {
        stateController.create(todo);
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TodoListState>(
      DataProviders.todoListStateProvider,
      (previous, next) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                next.error.toString(),
              ),
            ),
          );
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).extension<CustomColors>()!.labelPrimary,
          ),
          onPressed: _pop,
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
    final parameters = ref.watch(DataProviders.parametersProvider);
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

class ImportanceTile extends ConsumerWidget {
  const ImportanceTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parameters = ref.watch(DataProviders.parametersProvider);
    final parametersNotifier =
        ref.watch(DataProviders.parametersProvider.notifier);
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

  Future<void> selectDate(BuildContext context, WidgetRef ref) async {
    final String hintText = DateTime.now().year.toString();
    final DateTime initialDate =
        ref.watch(DataProviders.parametersProvider).date;

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
    selectDate(context, ref).then((value) {
      if (tempPickedDate != null) {
        ref.read(DataProviders.parametersProvider.notifier).date =
            tempPickedDate!;
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parameters = ref.watch(DataProviders.parametersProvider);
    final parametersNotifier =
        ref.watch(DataProviders.parametersProvider.notifier);
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
    ref.read(routerDelegateProvider).gotoList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoForEdit = ref.watch(DataProviders.todoProvider);
    final parameters = ref.watch(DataProviders.parametersProvider);
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
