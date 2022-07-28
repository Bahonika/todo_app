import 'package:todo_app/data/api/services/remote.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/models/todo.dart';

class ApiUtil{
  final RemoteService remoteService;
  ApiUtil(this.remoteService);

  Future<List<Todo>> getTodos() async {
    final result = await remoteService.getTodos();
    List<Todo> todos = [];
    for (int i = 0; i <result.length; i++){
      todos.add(TodoMapper.fromApi(result[i]));
    }
    return todos;
  }

  deleteTodo(String uuid) async {
    final result = await remoteService.delete(uuid: uuid);
    print(result);
  }

  createTodo(Todo todo) async{
     final result = await remoteService.create(todo: todo);
     print(result);
  }

}