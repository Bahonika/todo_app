import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/domain/enums/importance.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:uuid/uuid.dart';

final remoteServiceProvider = Provider<RemoteService>(
  (ref) {
    return RemoteService();
  },
);

final localServiceProvider = Provider<LocalService>(
  (ref) {
    return LocalService();
  },
);

final serviceUtilProvider = Provider<ServiceUtil>(
  (ref) {
    return ServiceUtil(
      ref.watch(remoteServiceProvider),
      ref.watch(localServiceProvider),
    );
  },
);

final todosController = StateNotifierProvider<TodosNotifier, List<Todo>>(
  (ref) {
    final serviceUtil = ref.watch(serviceUtilProvider);
    return TodosNotifier(serviceUtil);
  },
);

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier(this.serviceUtil) : super([]) {
    _init();
  }

  final ServiceUtil serviceUtil;

  void _init() async {
    await serviceUtil.localService.init();
    load();
  }

  void load() async {
    final data = await serviceUtil.getTodos();
    state = data;
  }

  void create(Todo todo) {
    serviceUtil.createTodo(todo);
    load();
  }

  Todo generateTodo(WidgetRef ref) {
    Uuid uuid = const Uuid();
    final todo = Todo(
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: "123",
      deadline:
          ref.read(showDateProvider) ? ref.read(selectedDateProvider) : null,
      uuid: uuid.v1(),
      done: false,
      text: ref.read(textControllerProvider).text,
      importance: ref.read(selectedImportanceProvider),
    );
    return todo;
  }

  void delete(Todo todo) {
    serviceUtil.deleteTodo(todo.uuid);
    state.removeWhere((element) => element == todo);
    load();
  }

  void update(Todo todo) {
    serviceUtil.updateTodo(todo).then((value) => load());
  }

  void setAsDone(Todo todo) {
    serviceUtil.setDone(todo).then((value) => load());
  }

  void setAsUndone(Todo todo) {
    serviceUtil.setUndone(todo);
    load();
  }
}

final completedTodosProvider = Provider<List<Todo>>((ref) {
  final todos =
      ref.watch(todosController).where((element) => element.done).toList();
  return todos;
});

final uncompletedTodosProvider = Provider<List<Todo>>((ref) {
  final todos =
      ref.watch(todosController).where((element) => !element.done).toList();
  return todos;
});

final showDateProvider = StateNotifierProvider<ShowDateNotifier, bool>((ref) {
  return ShowDateNotifier();
});

class ShowDateNotifier extends StateNotifier<bool> {
  ShowDateNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final selectedImportanceProvider =
    StateNotifierProvider<SelectedImportanceNotifier, Importance>((ref) {
  return SelectedImportanceNotifier();
});

class SelectedImportanceNotifier extends StateNotifier<Importance> {
  SelectedImportanceNotifier() : super(Importance.basic);

  void setImportance(Importance importance) {
    state = importance;
  }

  void setDefault() {
    setImportance(Importance.basic);
  }
}

final selectedDateProvider =
    StateNotifierProvider<SelectedDateNotifier, DateTime>((ref) {
  return SelectedDateNotifier();
});

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(DateTime.now());

  void setDate(DateTime dateTime) {
    state = dateTime;
  }

  void setDefault() {
    state = DateTime.now();
  }
}

final textControllerProvider =
    StateNotifierProvider<TextControllerNotifier, TextEditingController>((ref) {
  return TextControllerNotifier();
});

class TextControllerNotifier extends StateNotifier<TextEditingController> {
  TextControllerNotifier() : super(TextEditingController());

  void setDefault() {
    state.text = "";
  }
}

final showAllTodosProvider =
    StateNotifierProvider<ShowAllTodosNotifier, bool>((ref) {
  return ShowAllTodosNotifier();
});

class ShowAllTodosNotifier extends StateNotifier<bool> {
  ShowAllTodosNotifier() : super(true);

  void toggle() {
    state = !state;
  }
}

final isEditProvider = StateNotifierProvider<IsEditNotifier, bool>((ref) {
  return IsEditNotifier();
});

class IsEditNotifier extends StateNotifier<bool> {
  IsEditNotifier() : super(false);

  void set(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}

final todoForEditProvider =
    StateNotifierProvider<TodoForEditNotifier, Todo?>((ref) {
  return TodoForEditNotifier();
});

class TodoForEditNotifier extends StateNotifier<Todo?> {
  TodoForEditNotifier() : super(null);

  setTodo(Todo todo) {
    state = todo;
  }

  void setDefault() {
    state = null;
  }
}
