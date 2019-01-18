import 'package:flutter/material.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/screens/home_screen.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
import 'package:kelvin_mobile/widgets/device_service_provider.dart';
import 'package:kelvin_mobile/widgets/scanner_service_provider.dart';
import 'package:kelvin_mobile/widgets/vehicle_service_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScannerServiceProvider(
      scannerService:
          MockScannerService(onScan: () => 'device/${devices[0].id}'),
      child: DeviceServiceProvider(
        deviceService: MockDeviceService(),
        child: VehicleServiceProvider(
          vehicleService: MockVehicleService(),
          child: MaterialApp(
            title: 'Kelvin',
            home: const HomeScreen(),
          ),
        ),
      ),
    );
  }
}
