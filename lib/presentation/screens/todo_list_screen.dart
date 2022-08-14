
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/components/my_sliver_persistent_header.dart';
import 'package:todo_app/presentation/providers/todos_controller.dart';
import 'package:todo_app/presentation/theme/custom_colors.dart';
import 'package:todo_app/presentation/theme/custom_text_theme.dart';
import 'package:todo_app/presentation/components/wrap_card.dart';
import 'package:todo_app/presentation/localization/s.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: const CustomScrollView(
            slivers: [
              MySliverAppBar(),
              SliverTodoList(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ref.read(navigationProvider).openCreateTodo();
            },
            backgroundColor:
                Theme.of(context).extension<CustomColors>()!.colorBlue,
            child: Icon(
              Icons.add,
              color: Theme.of(context).extension<CustomColors>()!.colorWhite,
            ),
          ),
        ),
      ),
    );
  }
}

class MySliverAppBar extends StatefulWidget {
  const MySliverAppBar({Key? key}) : super(key: key);

  @override
  State<MySliverAppBar> createState() => _MySliverAppBarState();
}

class _MySliverAppBarState extends State<MySliverAppBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: MySliverPersistentHeader(thisVsync: this),
      pinned: true,
    );
  }
}

class SliverTodoList extends ConsumerWidget {
  const SliverTodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var todoToShow = ref.watch(showAllTodosProvider)
        ? ref.watch(todosController)
        : ref.watch(uncompletedTodosProvider);
    return SliverToBoxAdapter(
      child: WrapCard(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          controller: ScrollController(),
          itemBuilder: (BuildContext context, index) {
            if (index == todoToShow.length) {
              return TextFieldTile(); // last tile with text field
            } else {
              return TodoWidget(todo: todoToShow[index]);
            }
          },
          itemCount: todoToShow.length + 1,
        ),
      ),
    );
  }
}

class TextFieldTile extends ConsumerWidget {
  TextFieldTile({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  createTodo(WidgetRef ref) {
    ref.read(textControllerProvider).text = _controller.text;
    final todo = ref.read(todosController.notifier).generateTodo(ref);
    ref.read(todosController.notifier).create(todo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: const SizedBox(),
        title: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: S.of(context).newTodo,
            hintStyle: CustomTextTheme.importanceSubtitle(context),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.subdirectory_arrow_left_outlined),
              onPressed: () => createTodo(ref),
            ),
          ),
          style: CustomTextTheme.body(context),
          onFieldSubmitted: (value) => createTodo(ref),
          minLines: 1,
          maxLines: 1,
        ),
      ),
    );
  }
}

class TodoWidget extends ConsumerStatefulWidget {
  final Todo todo;

  const TodoWidget({required this.todo, Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends ConsumerState<TodoWidget> {
  void delete() {
    ref.read(todosController.notifier).delete(widget.todo);
  }

  Future<bool> setAsDone() async {
    ref.read(todosController.notifier).setAsDone(widget.todo);
    return false;
  }

  bool setAsUndone() {
    ref.read(todosController.notifier).setAsUndone(widget.todo);
    return false;
  }

  Future<bool> confirmDismiss(direction) async {
    if (direction == DismissDirection.startToEnd) {
      if (widget.todo.done) {
        return setAsUndone();
      } else {
        return setAsDone();
      }
    } else {
      return true;
    }
  }

  void fieldsFill() {
    ref.read(createScreenProvider.notifier).setEditingData(ref, widget.todo);
  }

  void toEditScreen() {
    fieldsFill();
    ref.read(navigationProvider).openCreateTodo();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        child: Dismissible(
          key: Key(widget.todo.uuid.toString()),
          direction: DismissDirection.horizontal,
          confirmDismiss: (direction) => confirmDismiss(direction),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              delete();
            }
          },
          background: const DismissibleBackground(),
          secondaryBackground: const DismissibleSecondaryBackground(),
          child: InkWell(
            onTap: () => toEditScreen(),
            child: ListTile(
              leading: Checkbox(
                value: widget.todo.done,
                activeColor:
                    Theme.of(context).extension<CustomColors>()!.colorGreen,
                onChanged: (bool? value) {
                  if (widget.todo.done) {
                    setAsUndone();
                  } else {
                    setAsDone();
                  }
                },
              ),
              title: RichText(
                text: TextSpan(
                    style: widget.todo.done
                        ? CustomTextTheme.bodyLineThrough(context)
                        : CustomTextTheme.body(context),
                    children: [
                      if (widget.todo.importance == Importance.important)
                        TextSpan(
                          text: "‼ ",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .extension<CustomColors>()!
                                  .colorRed),
                        ),
                      if (widget.todo.importance == Importance.low)
                        const WidgetSpan(
                          child: Icon(
                            Icons.arrow_downward_outlined,
                            size: 14,
                          ),
                        ),
                      TextSpan(
                        text: widget.todo.text,
                      )
                    ]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: (widget.todo.deadline != null)
                  ? Text(
                      MyDateFormat().localeFormat(widget.todo.deadline!),
                      style: CustomTextTheme.importanceSubtitle(context),
                    )
                  : null,
              trailing: Icon(
                Icons.info_outlined,
                color:
                    Theme.of(context).extension<CustomColors>()!.labelTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DismissibleBackground extends StatelessWidget {
  const DismissibleBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<CustomColors>()!.colorGreen,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.done,
            color: Theme.of(context).extension<CustomColors>()!.colorWhite,
          ),
        ],
      ),
    );
  }
}

class DismissibleSecondaryBackground extends StatelessWidget {
  const DismissibleSecondaryBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<CustomColors>()!.colorRed,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.delete,
            color: Theme.of(context).extension<CustomColors>()!.colorWhite,
          ),
        ],
      ),
    );
  }
}
