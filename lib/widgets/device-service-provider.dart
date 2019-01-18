import 'package:flutter/material.dart';
import 'package:kelvin_mobile/services/device-service.dart';

class DeviceServiceProvider extends InheritedWidget {
  final Widget child;
  final DeviceService deviceService;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DeviceService of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(DeviceServiceProvider)
              as DeviceServiceProvider)
          .deviceService;

  DeviceServiceProvider({Key key, this.child, this.deviceService})
      : super(key: key);
}
