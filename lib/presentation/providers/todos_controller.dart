import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/domain/models/todo.dart';

final remoteServiceProvider = Provider<RemoteService>((ref) {
  return RemoteService();
});

final localServiceProvider = Provider<LocalService>((ref) {
  return LocalService();
});

final serviceUtilProvider = Provider<ServiceUtil>((ref) {
  return ServiceUtil(
    ref.watch(remoteServiceProvider),
    ref.watch(localServiceProvider),
  );
});

final todosController = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  final serviceUtil = ref.watch(serviceUtilProvider);
  return TodosNotifier(serviceUtil);
});

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier(this.serviceUtil) : super([]) {
    _init();
  }

  final ServiceUtil serviceUtil;

  void _init() {
    state = const [];
    load();
  }

  void load() async {
    final data = await serviceUtil.getTodos();
    state = data;
  }

  void create(Todo todo) {
    serviceUtil.createTodo(todo);
  }

  void delete(Todo todo) {
    serviceUtil.deleteTodo(todo.uuid);
  }

  void update(Todo todo) {
    serviceUtil.updateTodo(todo);
  }
}
