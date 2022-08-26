import 'dart:ui';

import 'package:flutter/material.dart';


class DebugRouteInformationProvider extends PlatformRouteInformationProvider {
  DebugRouteInformationProvider()
      : super(
            initialRouteInformation: RouteInformation(
                location: PlatformDispatcher.instance.defaultRouteName));

  @override
  Future<bool> didPushRoute(String route) {
    return super.didPushRoute(route);
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    return super.didPushRouteInformation(routeInformation);
  }
}
