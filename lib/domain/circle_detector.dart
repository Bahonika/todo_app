import 'dart:math';
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/logger/logging.dart';

class CircleDetector {
  final logger = Logging.logger();

  bool check(List<Offset> list) {

    List<double> listY = list.map((e) => e.dy).toList()..sort();
    List<double> listX = list.map((e) => e.dx).toList()..sort();

    // calculation of the extreme points of the figure
    Offset maxX = list.firstWhere((element) => element.dx == listX.last);
    Offset minX = list.firstWhere((element) => element.dx == listX.first);
    Offset maxY = list.firstWhere((element) => element.dy == listY.last);
    Offset minY = list.firstWhere((element) => element.dy == listY.first);

    // center offset by its extreme points. Approximately.
    final centerX = (minX.dx + minY.dx + maxX.dx + maxY.dx) / 4;
    final centerY = (minX.dy + minY.dy + maxX.dy + maxY.dy) / 4;

    final centerOffset = Offset(centerX, centerY);

    // calculation of the maximum and minimum distances to the center
    double minDistance = double.infinity;
    double maxDistance = 0;
    for (Offset offset in list) {
      final distance = sqrt(pow(offset.dx - centerOffset.dx, 2) +
          pow(offset.dy - centerOffset.dy, 2));
      if (distance < minDistance) {
        minDistance = distance;
      }
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }


    // does the figure look like a circle
    // if the difference between the radii is small, then the circle
    final isCircle = maxDistance / minDistance < 1.7;

    logger.i("maxX is $maxX, maxY is $maxY, minX is $minX, minY is $minY\n"
        "center of figure is $centerOffset\n"
        "min radius is $minDistance\n"
        "max radius is $maxDistance\n"
        "circle? - $isCircle\n");

    return isCircle;
  }
}
