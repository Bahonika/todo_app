// import 'dart:io';

import 'package:dio/dio.dart';
import 'package:todo_app/data/api/model/api_todo.dart';
import 'package:todo_app/data/mappers/todo_mapper.dart';
import 'package:todo_app/domain/models/todo.dart';

class RemoteService {
  final _siteRoot = "https://beta.mrdekk.ru/todobackend";
  int _revision = 0;
  final String _revisionKey = "revision";
  late final Dio dio;

  static const _headerRevisionKey = "X-Last-Known-Revision";

  RemoteService() {
    dio = Dio(
      BaseOptions(
        baseUrl: _siteRoot,
        headers: {
          // HttpHeaders.authorizationHeader: "Bearer Ria",
          _headerRevisionKey: _revision,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, ResponseInterceptorHandler handler) {
          if (response.data[_revisionKey] != null) {
            final revision = response.data[_revisionKey];
            _revision = revision;
            dio.options.headers[_headerRevisionKey] = revision;
          }
          handler.resolve(response);
        },
      ),
    );
  }

  Future<List<Todo>> getTodos({Map<String, String>? queryParams}) async {
    final response =
        await dio.get("$_siteRoot/list", queryParameters: queryParams);
    List<Todo> todos = [];
    for (int i = 0; i < response.data["list"].length; i++) {
      todos.add(TodoMapper.fromApi(response.data["list"][i]));
    }
    return todos;
  }

  Future<Map<String, dynamic>> delete({required String uuid}) async {
    final response = await dio.delete("$_siteRoot/list/$uuid");
    return response.data;
  }

  Future<Map<String, dynamic>> create({required Todo todo}) async {
    final response = await dio.post(
      "$_siteRoot/list",
      data: TodoMapper.toApiWithPrefixElement(todo),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> update(
      {required String uuid, required Todo todo}) async {
    final response = await dio.put(
      "$_siteRoot/list/$uuid",
      data: TodoMapper.toApiWithPrefixElement(todo),
    );
    return response.data;
  }

  Future<List<Todo>> patch({required List<Todo> todos}) async {
    final response =
        await dio.patch("$_siteRoot/list", data: TodoMapper.listToApi(todos));

    var data = <Todo>[];
    for (dynamic el in response.data["list"]) {
      data.add(TodoMapper.fromApi(el));
    }
    return data;
  }

  int getRevision() {
    return _revision;
  }
}
