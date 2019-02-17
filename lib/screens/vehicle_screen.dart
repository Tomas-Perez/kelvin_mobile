import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment.dart';
import 'package:kelvin_mobile/blocs/assignment/vehicle_assignment_bloc.dart';
import 'package:kelvin_mobile/blocs/device_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/utils/dialogs.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';
import 'package:kelvin_mobile/widgets/qr_link_icon.dart';
import 'package:kelvin_mobile/widgets/vehicle_info.dart';

class VehicleScreen extends StatefulWidget {
  final String vehicleId;

  VehicleScreen({Key key, @required this.vehicleId}) : super(key: key);

  @override
  VehicleScreenState createState() => VehicleScreenState();
}

class VehicleScreenState extends State<VehicleScreen> {
  VehicleAssignmentBloc _assignmentBloc;

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
          if (pair.device == null) {
            return FloatingActionButton(
              onPressed: () => _scan(c),
              child: QRLinkIcon(),
            );
          } else {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).errorColor,
              onPressed: _unassignDialog,
              child: Icon(Icons.link_off),
            );
          }
        },
      ),
    );
  }

  _unassignDialog() async {
    final unassign = await showConfirmationDialog(
      '¿Está seguro que desea desasignar el vehículo?',
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

  _linkDialog(String id) async {
    final a = await showConfirmationDialog(
      '¿Está seguro que desea asignar el vehículo al dispositivo $id?',
      context,
    );

    if (a) {
      print('yes');
    } else {
      print('no');
    }
  }

  Future<bool> _assignDialog(String alias) async {
    return await showConfirmationDialog(
      '¿Está seguro que desea asignar el vehículo al dispositivo $alias?',
      context,
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
        _assignDevice(info.id, context);
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

  _assignDevice(String id, BuildContext context) async {
    final deviceBloc = DeviceBloc(
      BlocProvider.of<DevicesBloc>(context),
      id,
    );

    Future<Device> searchDevice = deviceBloc.state
        .firstWhere((s) => !s.loading && (s.device != null || s.hasError))
        .then((s) => s.device);

    try {
      final deviceDialogResult = await showLoadingDialog<Device>(
        searchDevice,
        context,
        text: 'Por favor espere',
      );

      if (!deviceDialogResult.dismissed) {
        final device = deviceDialogResult.result;
        if (device == null) {
          Errors.show(context, message: Errors.deviceNotFound);
        } else {
          final assign = await _assignDialog(device.alias);
          if (assign) {
            try {
              await _assignmentBloc.assignDevice(device);
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
      deviceBloc.dispose();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assignmentBloc = VehicleAssignmentBloc(
      devicesBloc: BlocProvider.of<DevicesBloc>(context),
      vehiclesBloc: BlocProvider.of<VehiclesBloc>(context),
      assignmentService: ServiceProvider.of<AssignmentService>(context),
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
