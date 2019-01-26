import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/assignment_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';
import 'package:kelvin_mobile/widgets/vehicle_info.dart';

class VehicleScreen extends StatefulWidget {
  final String vehicleId;

  VehicleScreen({Key key, @required this.vehicleId}) : super(key: key);

  @override
  VehicleScreenState createState() => VehicleScreenState();
}

class VehicleScreenState extends State<VehicleScreen> {
  AssignmentBloc _assignmentBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssignmentAction, AssignmentState>(
      bloc: _assignmentBloc,
      builder: (context, state) {
        if (!state.initialized) {
          return _emptyScreen();
        }
        if (state.loading) {
          return _loadingScreen();
        }
        if (state.hasError) {
          throw Exception(state.errorMessage);
        }
        return _resultScreen(
          pair: state.pair,
          context: context,
        );
      },
    );
  }

  Widget _loadingScreen() {
    return _scaffold(const Loading());
  }

  Widget _resultScreen({
    @required AssignedPair pair,
    @required BuildContext context,
  }) {
    return _scaffold(
      VehicleInfo(
        vehicle: pair.vehicle,
        device: pair.device,
        onDeviceTap: () => _pushDeviceScreen(pair, context),
      ),
      fab: Builder(
        builder: (c) {
          return FloatingActionButton(
            onPressed: () => _scan(c),
            child: Icon(CustomIcons.qrcode),
          );
        },
      ),
    );
  }

  Widget _scaffold(Widget body, {Widget fab}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículo'),
      ),
      body: body,
      floatingActionButton: fab,
    );
  }

  Future _scan(BuildContext context) async {
    try {
      String barcode = await ServiceProvider.of<ScannerService>(context).scan();
      final info = ServiceProvider.of<LinkParser>(context).parse(barcode);
      if (info.type == LinkType.device) {
        print('Assigning to device with id ${info.id}');
      } else {
        Errors.show(context, message: Errors.notADevice);
      }
    } on UnknownTypeException catch (e) {
      Errors.show(context, exc: e, message: Errors.notADevice);
    } on FormatException catch (e) {
      Errors.show(context, exc: e, message: Errors.invalidCode);
    } catch (e) {
      Errors.show(context, exc: e);
    }
  }

  Future _pushDeviceScreen(AssignedPair pair, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => DeviceScreen(deviceId: pair.device.id),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _assignmentBloc = AssignmentBloc.forVehicle(
      devicesBloc: BlocProvider.of<DevicesBloc>(context),
      vehiclesBloc: BlocProvider.of<VehiclesBloc>(context),
      vehicleId: widget.vehicleId,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _assignmentBloc.dispose();
  }

  Widget _emptyScreen() => Container();
}
