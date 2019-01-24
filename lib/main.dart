import 'package:flutter/material.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/screens/home_screen.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
import 'package:kelvin_mobile/widgets/providers/assignment_service_provider.dart';
import 'package:kelvin_mobile/widgets/providers/device_service_provider.dart';
import 'package:kelvin_mobile/widgets/providers/link_parser_provider.dart';
import 'package:kelvin_mobile/widgets/providers/mass_provider.dart';
import 'package:kelvin_mobile/widgets/providers/scanner_service_provider.dart';
import 'package:kelvin_mobile/widgets/providers/vehicle_service_provider.dart';

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
    final deviceService = const MockDeviceService(delay: 10000);
    final vehicleService = const MockVehicleService(delay: 10000);
    final mockAssignmentService = MockAssignmentService(
      deviceService: deviceService,
      vehicleService: vehicleService,
    );

    return provideAll(
      builders: [
        (c) {
          return LinkParserProvider(
            child: c,
            linkParser: const LinkParser(),
          );
        },
        (c) {
          return ScannerServiceProvider(
            child: c,
            scannerService:
                MockScannerService(onScan: () => 'device/${devices[0].id}'),
          );
        },
        (c) {
          return AssignmentServiceProvider(
            child: c,
            assignmentService: mockAssignmentService,
          );
        },
        (c) {
          return DeviceServiceProvider(
            child: c,
            deviceService: deviceService,
          );
        },
        (c) {
          return VehicleServiceProvider(
            child: c,
            vehicleService: vehicleService,
          );
        },
      ],
      child: app,
    );
  }
}
