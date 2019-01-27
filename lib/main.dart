import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/screens/home_screen.dart';
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
      app: MaterialApp(
        theme: ThemeData.light(),
        title: 'Kelvin',
        home: const HomeScreen(),
      ),
    );
  }

  Widget _provideServices({Widget app}) {
    return provideAll(
      builders: [
        (c) {
          return BlocProvider<VehiclesBloc>(
            bloc: VehiclesBloc(MockVehicleService())..load(),
            child: c,
          );
        },
        (c) {
          return BlocProvider<DevicesBloc>(
            bloc: DevicesBloc(MockDeviceService())..load(),
            child: c,
          );
        },
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
      ],
      child: app,
    );
  }
}
