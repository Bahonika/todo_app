import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/api/service_util.dart';
import 'package:todo_app/data/api/services/local.dart';
import 'package:todo_app/data/api/services/remote.dart';

class ServicesProviders{
  static final remoteServiceProvider = Provider<RemoteService>(
        (ref) {
      return RemoteService();
    },
  );

  static final localServiceProvider = Provider<LocalService>(
        (ref) {
      return LocalService();
    },
  );

  static final serviceUtilProvider = Provider<ServiceUtil>(
        (ref) {
      return ServiceUtil(
        ref.watch(remoteServiceProvider),
        ref.watch(localServiceProvider),
      );
    },
  );

}

