import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/main.dart';
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
    final todo =
        ref.read(DataProviders.todosController.notifier).generateTodo(ref);
    ref.read(DataProviders.todosController.notifier).create(todo);
  }

  void editTask() {
    final todoForEdit = ref.read(DataProviders.todoForEditProvider);
    final todo = ref
        .read(DataProviders.todosController.notifier)
        .alterTodo(ref, todoForEdit!);
    ref.read(DataProviders.todosController.notifier).update(todo);
  }

  void _tapHandler() {
    if (ref.watch(DataProviders.isEditProvider)) {
      editTask();
    } else {
      createTask();
    }
    setDefaultDataAndPop();
  }

  void setDefaultDataAndPop() {
    // не придумал как лучше это сделать пока что
    ref.refresh(DataProviders.textControllerProvider.notifier);
    ref.refresh(DataProviders.selectedImportanceProvider.notifier);
    ref.refresh(DataProviders.selectedDateProvider.notifier);
    ref.refresh(DataProviders.showDateProvider.notifier);
    ref.refresh(DataProviders.isEditProvider.notifier);
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
        controller: ref.watch(DataProviders.textControllerProvider),
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
          value: ref.watch(DataProviders.selectedImportanceProvider),
          style: CustomTextTheme.importanceSubtitle(context),
          icon: const SizedBox(),
          onChanged: (value) {
            ref
                .read(DataProviders.selectedImportanceProvider.notifier)
                .setImportance(value!);
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
        ref
            .read(DataProviders.selectedDateProvider.notifier)
            .setDate(tempPickedDate!);
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
      subtitle: ref.watch(DataProviders.showDateProvider)
          ? InkWell(
              onTap: () => setSelectedDate(context, ref),
              child: Text(
                MyDateFormat().localeFormat(
                    ref.watch(DataProviders.selectedDateProvider)!),
                style: TextStyle(
                    color:
                        Theme.of(context).extension<CustomColors>()!.colorBlue),
              ),
            )
          : const SizedBox(),
      trailing: Switch(
        value: ref.watch(DataProviders.showDateProvider),
        activeTrackColor: Theme.of(context)
            .extension<CustomColors>()!
            .colorBlue
            .withOpacity(0.3),
        activeColor: Theme.of(context).extension<CustomColors>()!.colorBlue,
        onChanged: (bool value) {
          ref.read(DataProviders.showDateProvider.notifier).toggle();
        },
      ),
    );
  }
}

class DeleteTile extends ConsumerWidget {
  const DeleteTile({Key? key}) : super(key: key);

  void delete(WidgetRef ref) {
    if (ref.watch(DataProviders.isEditProvider)) {
      final todo = ref.read(DataProviders.todoForEditProvider);
      ref.read(DataProviders.todosController.notifier).delete(todo!);
      setDefaultDataAndPop(ref);
    }
  }

  void setDefaultDataAndPop(WidgetRef ref) {
    // не придумал как лучше это сделать пока что
    ref.refresh(DataProviders.textControllerProvider.notifier);
    ref.refresh(DataProviders.selectedImportanceProvider.notifier);
    ref.refresh(DataProviders.selectedDateProvider.notifier);
    ref.refresh(DataProviders.showDateProvider.notifier);
    ref.refresh(DataProviders.isEditProvider.notifier);
    ref.read(navigationProvider).pop();
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
            color: ref.watch(DataProviders.isEditProvider)
                ? Theme.of(context).extension<CustomColors>()!.colorRed
                : Theme.of(context).extension<CustomColors>()!.labelDisable,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).delete,
              style: TextStyle(
                color: ref.watch(DataProviders.isEditProvider)
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
