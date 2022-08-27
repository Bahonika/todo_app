import 'package:flutter/widgets.dart';


class BookshelfTransitionDelegate extends TransitionDelegate {
  @override
  Iterable<RouteTransitionRecord> resolve(
      {required List<RouteTransitionRecord> newPageRouteHistory,
      required Map<RouteTransitionRecord?, RouteTransitionRecord>
          locationToExitingPageRoute,
      required Map<RouteTransitionRecord?, List<RouteTransitionRecord>>
          pageRouteToPagelessRoutes}) {
    for (var element in newPageRouteHistory) {
      if (element.isWaitingForEnteringDecision) {
        element.markForPush();
      }
      if (element.isWaitingForExitingDecision) {
        element.markForPop();
      }
    }
    return newPageRouteHistory;
  }
}
