import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:todo_app/data/unuseble/basic_repo.dart';
import 'package:todo_app/data/unuseble/postable.dart';

import 'api.dart';

abstract class PostUpdateRepository<T extends Postable>
    extends BasicRepository<T> {
  String get idAlias;

  Future<int> create(T entity) async {
    var uri = Uri.http(Api.siteRoot, apiPath());
    var response = await http.post(
      uri,
      body: jsonEncode(entity.toJson()),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "TOKEN"
      },
    );
    var status = response.statusCode;
    var body = jsonDecode(response.body);

    if (status == 200) {
      return body["id"];
    }
    throw HttpException("can't post to $uri Status: $status");
  }

  Future<void> put(T entity, String id) async {
    var response = await http.put(apiIdPath(id),
        headers: {
          HttpHeaders.authorizationHeader: "TOKEN",
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode(entity.toJson()));
    var status = response.statusCode;
    if (status != 200) {
      throw HttpException("can't update to Status: $status");
    }
  }

  Future<void> delete(String id) async {
    var response =
        await http.delete(apiIdPath(id), headers: {'Authorization': "TOKEN"});
    var status = response.statusCode;
    if (status != 201 && status != 200 && status != 202) {
      throw HttpException("can't delete, status: $status");
    }
  }
}
