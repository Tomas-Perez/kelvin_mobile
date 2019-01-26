import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/assignment_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/widgets/device_info.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';

class DeviceScreen extends StatefulWidget {
  final String deviceId;

  DeviceScreen({Key key, @required this.deviceId}) : super(key: key);

  @override
  DeviceScreenState createState() => DeviceScreenState();
}

class DeviceScreenState extends State<DeviceScreen> {
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

  Widget _emptyScreen() {
    return _scaffold(Container());
  }

  Widget _resultScreen({
    @required AssignedPair pair,
    @required BuildContext context,
  }) {
    return _scaffold(
      DeviceInfo(
        device: pair.device,
        vehicle: pair.vehicle,
        onVehicleTap: () => _pushVehicleScreen(pair, context),
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
        title: Text('Dispositivo'),
      ),
      body: body,
      floatingActionButton: fab,
    );
  }

  Future _pushVehicleScreen(AssignedPair pair, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => VehicleScreen(vehicleId: pair.vehicle.id),
      ),
    );
  }

  Future _scan(BuildContext context) async {
    try {
      final barcode = await ServiceProvider.of<ScannerService>(context).scan();
      final info = ServiceProvider.of<LinkParser>(context).parse(barcode);
      if (info.type == LinkType.vehicle) {
        print('Assigning to vehicle with id ${info.id}');
      } else {
        Errors.show(context, message: Errors.notAVehicle);
      }
    } on UnknownTypeException catch (e) {
      Errors.show(context, exc: e, message: Errors.notAVehicle);
    } on FormatException catch (e) {
      Errors.show(context, exc: e, message: Errors.invalidCode);
    } catch (e) {
      Errors.show(context, exc: e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _assignmentBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    _assignmentBloc = AssignmentBloc.forDevice(
      devicesBloc: BlocProvider.of<DevicesBloc>(context),
      vehiclesBloc:  BlocProvider.of<VehiclesBloc>(context),
      deviceId: widget.deviceId,
    );
  }
}
