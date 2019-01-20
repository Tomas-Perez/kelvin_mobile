import 'package:flutter/material.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/screens/home_screen.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
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
    return provideAll(
      builders: [
        (c) => LinkParserProvider(
              child: c,
              linkParser: const LinkParser(),
            ),
        (c) => ScannerServiceProvider(
              child: c,
              scannerService:
                  MockScannerService(onScan: () => 'device${devices[0].id}'),
            ),
        (c) => DeviceServiceProvider(
              child: c,
              deviceService: const MockDeviceService(),
            ),
        (c) => VehicleServiceProvider(
              child: c,
              vehicleService: const MockVehicleService(),
            )
      ],
      child: const MaterialApp(
        title: 'Kelvin',
        home: const HomeScreen(),
      ),
    );
  }
}
