import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/auth_guard.dart';
import 'package:kelvin_mobile/blocs/auth_bloc.dart';
import 'package:kelvin_mobile/blocs/connection_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
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
    final vehicleService = HttpVehicleService();
    final deviceService = HttpDeviceService();
    final connectionBloc = ApiConnectionBloc(
      initialUrl: 'http://192.168.1.45:8080',
      connectionService: HttpConnectionService(),
    );
    final authBloc = AuthBloc(
      HttpAuthService(),
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
            service: HttpAssignmentService(),
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
            service: QRScannerService(),
          );
        },
      ],
    );
  }
}
