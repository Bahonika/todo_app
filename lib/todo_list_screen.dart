import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/components/wrapCard.dart';
import 'package:todo_app/data/entities/todo.dart';
import 'package:todo_app/s.dart';
import 'package:todo_app/theme.dart';
import 'package:todo_app/todo_create_screen.dart';
import 'package:todo_app/providers/todos_provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    S.ru;
    return Scaffold(
      body: const CustomScrollView(
        slivers: [
          MySliverAppBar(),
          SliverTodoList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TodoCreateScreen()));
        },
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).myTodos,
              style: CustomTextTheme.title(context),
            ),
            Text(
              "${S.of(context).done}5",
              style: CustomTextTheme.subtitle(context),
            ),
          ],
        ),
      ),
    );
  }
}

class SliverTodoList extends StatelessWidget {
  const SliverTodoList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          WrapCard(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              controller: ScrollController(),
              itemBuilder: (BuildContext context, index) {
                return TodoWidget(
                    todo: context.watch<TodosProvider>().todos[index]);
                // return Container(height: 120,);
              },
              itemCount: context.watch<TodosProvider>().todos.length,
            ),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.todo.uuid.toString()),
      direction: widget.todo.done // if already done - cant swipe to right
          ? DismissDirection.endToStart
          : DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart){
          context.read<TodosProvider>().deleteTodo(widget.todo.uuid);
        }
      },
      background: const DismissibleBackground(),
      secondaryBackground: const DismissibleSecondaryBackground(),
      child: ListTile(
        leading: Checkbox(
          value: widget.todo.done,
          activeColor: Theme.of(context).colorScheme.primaryContainer,
          onChanged: (bool? value) {},
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
            ? Text(DateFormat.yMMMMd().format(widget.todo.deadline!))
            : null,
        trailing: const Icon(Icons.info_outlined),
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
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Icon(Icons.done, color: Colors.white),
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
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.errorContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(Icons.delete, color: Colors.white),
        ],
      ),
    );
  }
}
