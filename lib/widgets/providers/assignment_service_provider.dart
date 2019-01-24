import 'package:flutter/material.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';

class AssignmentServiceProvider extends InheritedWidget {
  final Widget child;
  final AssignmentService assignmentService;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AssignmentService of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(AssignmentServiceProvider)
              as AssignmentServiceProvider)
          .assignmentService;

  const AssignmentServiceProvider({Key key, this.child, this.assignmentService})
      : super(key: key);
}
