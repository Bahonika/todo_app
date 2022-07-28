import 'package:todo_app/data/api/api_util.dart';
import 'package:todo_app/data/api/services/remote.dart';

class ApiModule {
  static ApiUtil? _apiUtil;

  static ApiUtil apiUtil() {
    _apiUtil ??= ApiUtil(RemoteService());
    return _apiUtil!;
  }
}