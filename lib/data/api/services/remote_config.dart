// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:logger/logger.dart';
// import 'package:todo_app/presentation/logger/logging.dart';
//
// class RemoteConfigService {
//   final RemoteConfig _remoteConfig;
//
//   static RemoteConfigService? _instance;
//
//   static String isRedKey = "is_importance_red";
//
//   final defaults = <String, dynamic>{isRedKey: true};
//
//   Logger log = Logging.logger();
//
//   static Future<RemoteConfigService> getInstance() async {
//     _instance ??=
//         RemoteConfigService(remoteConfig:  );
//
//     return _instance!;
//   }
//
//   RemoteConfigService({required RemoteConfig remoteConfig})
//       : _remoteConfig = remoteConfig;
//
//   bool get isImportanceRed => _remoteConfig.getBool(isRedKey);
//
//   Future initialise() async {
//     try {
//       await _remoteConfig.setDefaults(defaults);
//       _fetchAndActivate;
//     } catch (e){
//       log.e("Can't fetch now", e);
//     }
//   }
//
//   Future _fetchAndActivate() async {
//     await _remoteConfig.fetch();
//     await _remoteConfig.activate();
//   }
// }
