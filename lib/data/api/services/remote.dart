import 'package:dio/dio.dart';
import 'package:todo_app/data/api/model/api_todo.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/revision_provider.dart';

class RemoteService {
  static const siteRoot = "https://beta.mrdekk.ru/todobackend";
  static int revision = 0;

  static RevisionProvider revisionProvider = RevisionProvider();


  final Dio dio = Dio(
    BaseOptions(
      baseUrl: siteRoot,
      headers: {
        "Authorization": "Bearer Ria",
        "X-Last-Known-Revision": revision,
      },
    ),
  );

  updateRevision(int revision){
    dio.options.headers.addAll(
      {"X-Last-Known-Revision": revision},
    );
    revisionProvider.revision = revision;

  }

  Future<List<ApiTodo>> getTodos({Map<String, String>? queryParams}) async {
    final response =
        await dio.get("$siteRoot/list", queryParameters: queryParams);
    List<ApiTodo> todos = [];
    for (int i = 0; i < response.data["list"].length; i++) {
      todos.add(ApiTodo.fromApi(response.data["list"][i]));
    }
    updateRevision(response.data["revision"]);

    return todos;
  }

  Future<Map<String, dynamic>> delete({required String uuid}) async {
    final response = await dio.delete("$siteRoot/list/$uuid");
    updateRevision(response.data["revision"]);
    return response.data;
  }

  Future<Map<String, dynamic>> create({required Todo todo}) async {
    final response = await dio.post(
      "$siteRoot/list",
      data: TodoMapper.toApi(todo),
    );
    updateRevision(response.data["revision"]);

    return response.data;
  }

  Future<Map<String, dynamic>> update(
      {required String uuid, required Todo todo}) async {
    final response = await dio.put(
      "$siteRoot/list/$uuid",
      data: TodoMapper.toApi(todo),
    );
    updateRevision(response.data["revision"]);

    return response.data;
  }


  Future<List<Todo>> patch({required List<Todo> todos}) async {
    final response = await dio.patch("$siteRoot/list", data: TodoMapper.listToApi(todos));
    updateRevision(response.data["revision"]);
    return response.data;
  }
}
