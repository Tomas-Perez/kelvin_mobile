import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment.dart';
import 'package:kelvin_mobile/blocs/assignment/device_assignment_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicle_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/utils/dialogs.dart';
import 'package:kelvin_mobile/widgets/device_info.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';
import 'package:kelvin_mobile/widgets/qr_link_icon.dart';

class DeviceScreen extends StatefulWidget {
  final String deviceId;

  DeviceScreen({Key key, @required this.deviceId}) : super(key: key);

  @override
  DeviceScreenState createState() => DeviceScreenState();
}

class DeviceScreenState extends State<DeviceScreen> {
  DeviceAssignmentBloc _assignmentBloc;

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
          if (pair.vehicle == null) {
            return FloatingActionButton(
              onPressed: () => _scan(c),
              child: QRLinkIcon(),
              tooltip: 'Asignar con QR',
            );
          } else {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).errorColor,
              onPressed: _unassignDialog,
              child: Icon(Icons.link_off),
              tooltip: 'Desasignar',
            );
          }
        },
      ),
    );
  }

  _unassignDialog() async {
    final unassign = await showConfirmationDialog(
      '¿Está seguro que desea desasignar el dispositivo?',
      context,
    );

    if (unassign) {
      try {
        _assignmentBloc.unassign();
      } catch (e) {
        Errors.show(context, exc: e);
      }
    } else {
      print('no');
    }
  }

  Future<bool> _assignDialog(String domain) async {
    return await showConfirmationDialog(
      '¿Está seguro que desea asignar el dispositivo al vehículo $domain?',
      context,
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
        _assignVehicle(info.id, context);
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

  _assignVehicle(String id, BuildContext context) async {
    final vehicleBloc = VehicleBloc(
      BlocProvider.of<VehiclesBloc>(context),
      id,
    );

    Future<Vehicle> searchVehicle = vehicleBloc.state
        .firstWhere((s) => !s.loading && (s.vehicle != null || s.hasError))
        .then((s) => s.vehicle);

    try {
      final vehicleDialogResult = await showLoadingDialog<Vehicle>(
        searchVehicle,
        context,
        text: 'Por favor espere',
      );

      if (!vehicleDialogResult.dismissed) {
        final vehicle = vehicleDialogResult.result;
        if (vehicle == null) {
          Errors.show(context, message: Errors.vehicleNotFound);
        } else {
          final assign = await _assignDialog(vehicle.domain);
          if (assign) {
            try {
              await _assignmentBloc.assignVehicle(vehicle);
            } catch (e) {
              Errors.show(context, exc: e);
            }
          } else {
            print('no');
          }
        }
      }
    } catch (e) {
      Errors.show(context, exc: e);
    } finally {
      vehicleBloc.dispose();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _assignmentBloc.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assignmentBloc = DeviceAssignmentBloc(
      devicesBloc: BlocProvider.of<DevicesBloc>(context),
      vehiclesBloc: BlocProvider.of<VehiclesBloc>(context),
      assignmentService: ServiceProvider.of<AssignmentService>(context),
      deviceId: widget.deviceId,
    );
  }
}
