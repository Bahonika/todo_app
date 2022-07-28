import 'package:todo_app/data/repositories/todo_data_repository.dart';
import 'package:todo_app/domain/repositories/todo_repository.dart';
import 'package:todo_app/internal/dependencies/api_module.dart';

class RepositoryModule {
  static TodoRepository? _todoRepository;

  static TodoRepository todoRepository() {
    _todoRepository ??= TodoDataRepository(
      ApiModule.apiUtil(),
    );
    return _todoRepository!;
  }
}
