import 'package:flutter/material.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/screens/home_screen.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
import 'package:kelvin_mobile/widgets/providers/mass_provider.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return _provideServices(
      app: const MaterialApp(
        title: 'Kelvin',
        home: const HomeScreen(),
      ),
    );
  }

  Widget _provideServices({Widget app}) {
    final deviceService = const MockDeviceService();
    final vehicleService = const MockVehicleService();
    final mockAssignmentService = MockAssignmentService(
      deviceService: deviceService,
      vehicleService: vehicleService,
    );

    return provideAll(
      builders: [
        (c) {
          return ServiceProvider<LinkParser>(
            child: c,
            service: const LinkParser(),
          );
        },
        (c) {
          return ServiceProvider<ScannerService>(
            child: c,
            service:
                MockScannerService(onScan: () => 'device/${devices[0].id}'),
          );
        },
        (c) {
          return ServiceProvider<AssignmentService>(
            child: c,
            service: mockAssignmentService,
          );
        },
        (c) {
          return ServiceProvider<DeviceService>(
            child: c,
            service: deviceService,
          );
        },
        (c) {
          return ServiceProvider<VehicleService>(
            child: c,
            service: vehicleService,
          );
        },
      ],
      child: app,
    );
  }
}
