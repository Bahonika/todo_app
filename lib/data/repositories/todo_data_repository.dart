import 'package:todo_app/data/api/api_util.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';

class TodoDataRepository extends TodoRepository {
  final ApiUtil apiUtil;
  TodoDataRepository(this.apiUtil);

  @override
  Future<List<Todo>> getTodos() {
    return apiUtil.getTodos();
  }
}
