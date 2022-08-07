import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/components/date_format.dart';
import 'package:todo_app/presentation/components/my_sliver_persistent_header.dart';
import 'package:todo_app/presentation/theme/theme.dart';
import 'package:todo_app/presentation/components/wrap_card.dart';
import 'package:todo_app/presentation/navigation/navigation_controller.dart';
import 'package:todo_app/presentation/providers/create_task_data_provider.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/presentation/localization/s.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<TodosProvider>().getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const CustomScrollView(
          slivers: [
            MySliverAppBar(),
            SliverTodoList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<NavigationController>().openCreateTodo();
          },
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          //todo capsule all icons
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.surface,
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
      // floating: true,
    );
  }
}

class SliverTodoList extends StatelessWidget {
  const SliverTodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<List<Todo>>(builder: (context, todos, _) {
        // list, that user must see at this moment
        List<Todo> todoToShow = context.watch<TodosProvider>().showCompleted
            ? todos
            : todos.where((element) => !element.done).toList();

        return WrapCard(
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
        );
      }),
    );
  }
}

class TextFieldTile extends StatelessWidget {
  TextFieldTile({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  createTodo(BuildContext context) {
    context.read<CreateTaskDataProvider>().setControllerText(_controller.text);
    Todo todo = context.read<CreateTaskDataProvider>().modelingTodo();
    context.read<TodosProvider>().createTodo(todo: todo);
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => createTodo(context),
              )),
          onSaved: (value) => createTodo(context),
          minLines: 1,
          maxLines: null,
        ),
      ),
    );
  }
}

class TodoWidget extends StatefulWidget {
  final Todo todo;

  const TodoWidget({Key? key, required this.todo}) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  void delete() {
    context.read<TodosProvider>().deleteTodo(widget.todo.uuid);
  }

  Future<bool> setAsDone() async {
    context.read<TodosProvider>().setAsDone(widget.todo);
    return false;
  }

  bool setAsUndone() {
    context.read<TodosProvider>().setAsUndone(widget.todo);
    return true;
  }

  Future<bool> confirmDismiss(direction) async {
    if (direction == DismissDirection.startToEnd) {
      return setAsDone();
    } else {
      return true;
    }
  }

  void fieldsFill() {
    var provider = context.read<CreateTaskDataProvider>();
    provider.setControllerText(widget.todo.text);
    if (widget.todo.deadline != null) {
      provider.selectedDate = widget.todo.deadline!;
      provider.showDate = true;
    }
    provider.selectedImportance = widget.todo.importance;
  }

  void toEditScreen() {
    fieldsFill();
    context.read<NavigationController>().openCreateTodo(
          isEdit: true,
          todoForEdit: widget.todo,
        );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Dismissible(
        key: Key(widget.todo.uuid.toString()),
        direction: widget.todo.done // if already done - cant swipe to right
            ? DismissDirection.endToStart
            : DismissDirection.horizontal,
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
              activeColor: Theme.of(context).colorScheme.primaryContainer,
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
                      ? CustomTextTheme.todoTextDone(context)
                      : CustomTextTheme.todoText(context),
                  children: [
                    if (widget.todo.importance == Importance.important)
                      TextSpan(
                        text: "‼ ",
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.errorContainer),
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
            trailing: const Icon(Icons.info_outlined),
          ),
        ),
      ),
    );
  }
}

class DismissibleChild extends StatelessWidget {
  const DismissibleChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DismissibleBackground extends StatelessWidget {
  const DismissibleBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.done,
            color: Theme.of(context).colorScheme.secondary,
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
        color: Theme.of(context).colorScheme.errorContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
