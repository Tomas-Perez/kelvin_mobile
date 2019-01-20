import 'package:flutter/material.dart';

Widget provideAll({List<Widget Function(Widget)> builders, Widget child}) {
  var result = child;
  for (final builder in builders) {
    result = builder(result);
  }
  return result;
}