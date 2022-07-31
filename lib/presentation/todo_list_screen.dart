import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/components/my_sliver_persistent_header.dart';
import 'package:todo_app/presentation/components/theme.dart';
import 'package:todo_app/presentation/components/wrapCard.dart';
import 'package:todo_app/presentation/navigation/navigation_controller.dart';
import 'package:todo_app/presentation/providers/todos_provider.dart';
import 'package:todo_app/presentation/components/s.dart';

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
          child: const Icon(
            Icons.add,
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
    List<Todo> todos = context.watch<TodosProvider>().todos;
    return SliverToBoxAdapter(
      child: WrapCard(
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          controller: ScrollController(),
          itemBuilder: (BuildContext context, index) {
            if (index == todos.length) {
              return const TextFieldTile(); // last tile with text field
            } else {
              return TodoWidget(todo: todos[index]);
            }
          },
          itemCount: todos.length + 1,
        ),
      ),
    );
  }
}

class TextFieldTile extends StatelessWidget {
  const TextFieldTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: const SizedBox(),
        title: TextFormField(
          decoration: InputDecoration(
            hintText: S.of(context).newTodo,
            hintStyle: CustomTextTheme.importanceSubtitle(context),
            border: InputBorder.none,
          ),
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
  String textPrefix = "";

  @override
  void initState() {
    if (widget.todo.importance == Importance.important) {
      textPrefix = "!! ";
    } else if (widget.todo.importance == Importance.low) {
      textPrefix = "- ";
    }
    super.initState();
  }

  delete() async {
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
        child: ListTile(
          leading: Checkbox(
            value: widget.todo.done,
            activeColor: Theme.of(context).colorScheme.primaryContainer,
            onChanged: (bool? value) {
              widget.todo.done ? setAsUndone() : setAsDone();
            },
          ),
          title: Text(
            textPrefix + widget.todo.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: widget.todo.done
                ? CustomTextTheme.todoTextDone(context)
                : CustomTextTheme.todoText(context),
          ),
          subtitle: (widget.todo.deadline != null)
              ? Text(
                  DateFormat.yMMMMd(S.ru.toString())
                      .format(widget.todo.deadline!),
                  style: CustomTextTheme.importanceSubtitle(context),
                )
              : null,
          //todo capsule all icons
          trailing: const Icon(Icons.info_outlined),
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
        children: const [
          Icon(
            Icons.done,
            color: Colors.white,
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
        children: const [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
