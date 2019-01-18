import 'package:flutter/material.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';

class VehicleServiceProvider extends InheritedWidget {
  final Widget child;
  final VehicleService vehicleService;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static VehicleService of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(VehicleServiceProvider)
              as VehicleServiceProvider)
          .vehicleService;

  VehicleServiceProvider({Key key, this.child, this.vehicleService})
      : super(key: key);
}
