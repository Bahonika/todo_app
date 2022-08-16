import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';

class ApiModule {
  static ServiceUtil? _apiUtil;

  static ServiceUtil apiUtil() {
    _apiUtil ??= ServiceUtil(RemoteService(), LocalService.localService());
    return _apiUtil!;
  }
}
