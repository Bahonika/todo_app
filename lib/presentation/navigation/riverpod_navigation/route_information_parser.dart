import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/navigation/riverpod_navigation/segments.dart';

class TypedSegmentRouteInformationParser implements RouteInformationParser<TypedPath> {
  @override
  Future<TypedPath> parseRouteInformation(RouteInformation routeInformation) =>
      Future.value(path2TypedPath(routeInformation.location));

  @override
  RouteInformation restoreRouteInformation(TypedPath configuration) =>
      RouteInformation(location: typedPath2Path(configuration));

  static String typedPath2Path(TypedPath typedPath) => typedPath
      .map((s) => Uri.encodeComponent(jsonEncode(s.toJson())))
      .join('/');

  static TypedPath path2TypedPath(String? path) {
    if (path == null || path.isEmpty) return [];
    AppMetrica.reportEvent("open_$path");
    return [
      for (final s in path.split('/'))
        if (s.isNotEmpty) TypedSegment.fromJson(jsonDecode(Uri.decodeFull(s)))
    ];
  }
}
