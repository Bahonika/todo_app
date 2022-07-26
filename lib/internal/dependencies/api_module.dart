import 'package:todo_app/data/api/api_util.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';

class ApiModule {
  static ApiUtil? _apiUtil;

  static ApiUtil apiUtil() {
    _apiUtil ??= ApiUtil(RemoteService(), LocalService.localService());
    return _apiUtil!;
  }
}