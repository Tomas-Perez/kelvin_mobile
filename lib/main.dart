import 'package:flutter/material.dart';
import 'package:kelvin_mobile/screens/home-screen.dart';
import 'package:kelvin_mobile/services/device-service.dart';
import 'package:kelvin_mobile/services/vehicle-service.dart';
import 'package:kelvin_mobile/widgets/device-service-provider.dart';
import 'package:kelvin_mobile/widgets/vehicle-service-provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DeviceServiceProvider(
      deviceService: MockDeviceService(),
      child: VehicleServiceProvider(
        vehicleService: MockVehicleService(),
        child: MaterialApp(
          title: 'Kelvin',
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
