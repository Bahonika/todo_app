import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/providers/providers.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';
import 'package:todo_app/presentation/components/wrap_card.dart';
import 'package:todo_app/presentation/localization/s.dart';
import 'package:todo_app/presentation/theme/custom_text_theme.dart';

class TodoCreateScreen extends ConsumerStatefulWidget {
  const TodoCreateScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends ConsumerState<TodoCreateScreen> {
  void createTask() {
    ref.watch(DataProviders.todosController.notifier).create();
  }

  void editTask() {
    ref.watch(DataProviders.todosController.notifier).update();
  }

  void _tapHandler() {
    if (ref.watch(DataProviders.createParametersProvider).isEdit) {
      editTask();
    } else {
      createTask();
    }
    setDefaultDataAndPop();
  }

  void setDefaultDataAndPop() {
    // autoDispose не срабатывает при уходе с экрана, не очень понимаю, почему
    // если вызывать refresh вручную, то диспоузится и todosController
    // это приводит к багу. Слишком связно получилось

    // ref.refresh(DataProviders.createParametersProvider);
    ref.read(DataProviders.navigationProvider).pop();
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
    final parameters = ref.watch(DataProviders.createParametersProvider);
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
    final parameters = ref.watch(DataProviders.createParametersProvider);
    final parametersNotifier =
        ref.watch(DataProviders.createParametersProvider.notifier);
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
      if (tempPickedDate != null) {
        ref.read(DataProviders.createParametersProvider.notifier).date =
            tempPickedDate!;
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parameters = ref.watch(DataProviders.createParametersProvider);
    final parametersNotifier =
        ref.watch(DataProviders.createParametersProvider.notifier);
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
    ref.watch(DataProviders.navigationProvider).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parameters = ref.watch(DataProviders.createParametersProvider);

    return TextButton(
      onPressed: () {
        if (parameters.isEdit) {
          ref
              .read(DataProviders.todosController.notifier)
              .delete(parameters.todoForEdit!);
        }
        _pop(ref);
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
