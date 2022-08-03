import 'package:dio/dio.dart';
import 'package:todo_app/data/api/model/api_todo.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/models/todo.dart';
import 'package:todo_app/presentation/providers/revision_provider.dart';

class RemoteService {
  static const siteRoot = "https://beta.mrdekk.ru/todobackend";
  static int revision = 0;

  static RevisionProvider revisionProvider = RevisionProvider();

  getRevision() {
    revision = revisionProvider.revision;
  }

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: siteRoot,
      headers: {
        "Authorization": "Bearer Ria",
        "X-Last-Known-Revision": revision,
      },
    ),
  );

  Future<List<ApiTodo>> getTodos({Map<String, String>? queryParams}) async {
    final response =
        await dio.get("$siteRoot/list", queryParameters: queryParams);
    List<ApiTodo> todos = [];
    for (int i = 0; i < response.data["list"].length; i++) {
      todos.add(ApiTodo.fromApi(response.data["list"][i]));
    }

    dio.options.headers.addAll(
      {"X-Last-Known-Revision": response.data["revision"]},
    );
    revisionProvider.revision = await response.data["revision"];
    return todos;
  }

  Future<Map<String, dynamic>> delete({required String uuid}) async {
    final response = await dio.delete("$siteRoot/list/$uuid");
    revision = response.data["revision"];
    return response.data;
  }

  Future<Map<String, dynamic>> create({required Todo todo}) async {
    final response = await dio.post(
      "$siteRoot/list",
      data: TodoMapper.toApi(todo),
    );
    revisionProvider.revision = response.data["revision"];

    return response.data;
  }

  Future<Map<String, dynamic>> update(
      {required String uuid, required Todo todo}) async {
    final response = await dio.put(
      "$siteRoot/list/$uuid",
      data: TodoMapper.toApi(todo),
    );
    revisionProvider.revision = response.data["revision"];

    return response.data;
  }


  Future<List<Todo>> patch({required List<Todo> todos}) async {

    final response = await dio.patch("$siteRoot/list", data: TodoMapper.listToApi(todos));
    revisionProvider.revision = response.data["revision"];

    return response.data;
  }
}
