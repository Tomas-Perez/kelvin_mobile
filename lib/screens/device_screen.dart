import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/widgets/device_info.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';

class DeviceScreen extends StatelessWidget {
  final Future<AssignedPair> future;

  DeviceScreen({Key key, @required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _resultScreen(
              pair: snapshot.data,
              context: context,
            );
          case ConnectionState.waiting:
            return _loadingScreen();
          default:
            throw Exception('wtf');
        }
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
        builder: (c) => VehicleScreen(future: Future.value(pair)),
      ),
    );
  }

  Future _scan(BuildContext context) async {
    try {
      final barcode = await ServiceProvider.of<ScannerService>(context).scan();
      final info = ServiceProvider.of<LinkParser>(context).parse(barcode);
      if (info.type == LinkType.VEHICLE) {
        print('Assigning to vehicle with id ${info.id}');
      } else {
        Errors.show(context, message: Errors.NOT_A_VEHICLE);
      }
    } on UnknownTypeException catch (e) {
      Errors.show(context, exc: e, message: Errors.NOT_A_VEHICLE);
    } on FormatException catch (e) {
      Errors.show(context, exc: e, message: Errors.INVALID_CODE);
    } catch (e) {
      Errors.show(context, exc: e);
    }
  }
}
