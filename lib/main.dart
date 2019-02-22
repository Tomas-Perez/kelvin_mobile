import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/auth_guard.dart';
import 'package:kelvin_mobile/blocs/auth_bloc.dart';
import 'package:kelvin_mobile/blocs/connection_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/screens/home_screen.dart';
import 'package:kelvin_mobile/screens/login_screen.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:kelvin_mobile/services/auth_service.dart';
import 'package:kelvin_mobile/services/connection_service.dart';
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
        home: AuthGuard(
          homeScreen: const HomeScreen(),
          login: const LoginScreen(),
        ),
      ),
    );
  }

  Widget _provideServices({Widget app}) {
    final vehicleService = MockVehicleService();
    final deviceService = MockDeviceService();
    final connectionBloc = ApiConnectionBloc(
      initialUrl: '192.168.1.45:8080',
      connectionService: MockConnectionService(delay: Duration(seconds: 5)),
    );
    final authBloc = AuthBloc(
      MockAuthService(delay: Duration(seconds: 2)),
      connectionBloc,
    );

    return provideAll(
      child: app,
      builders: [
        (c) {
          return BlocProvider<ApiConnectionBloc>(
            bloc: connectionBloc,
            child: c,
          );
        },
        (c) {
          return BlocProvider<AuthBloc>(
            bloc: authBloc,
            child: c,
          );
        },
        (c) {
          return BlocProvider<VehiclesBloc>(
            bloc: VehiclesBloc(vehicleService, connectionBloc, authBloc),
            child: c,
          );
        },
        (c) {
          return BlocProvider<DevicesBloc>(
            bloc: DevicesBloc(deviceService, connectionBloc, authBloc),
            child: c,
          );
        },
        (c) {
          return ServiceProvider<AssignmentService>(
            child: c,
            service: MockAssignmentService(
              deviceService: deviceService,
              vehicleService: vehicleService,
            ),
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
    );
  }
}
