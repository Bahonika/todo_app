import 'package:hive_flutter/hive_flutter.dart';

part 'importance.g.dart';

@HiveType(typeId: 1)
enum Importance {
  @HiveField(0)
  low,
  @HiveField(1)
  basic,
  @HiveField(2)
  important,
}
