import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/providers/link_parser_provider.dart';
import 'package:kelvin_mobile/widgets/providers/scanner_service_provider.dart';
import 'package:kelvin_mobile/widgets/vehicle_info.dart';

class VehicleScreen extends StatelessWidget {
  final Future<AssignedPair> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AssignedPair>(
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
      String barcode = await ScannerServiceProvider.of(context).scan();
      final info = LinkParserProvider.of(context).parse(barcode);
      if (info.type == LinkType.DEVICE) {
        print('Assigning to device with id ${info.id}');
      } else {
        Errors.show(context, message: Errors.NOT_A_DEVICE);
      }
    } on UnknownTypeException catch (e) {
      Errors.show(context, exc: e, message: Errors.NOT_A_DEVICE);
    } on FormatException catch (e) {
      Errors.show(context, exc: e, message: Errors.INVALID_CODE);
    } catch (e) {
      Errors.show(context, exc: e);
    }
  }

  Future _pushDeviceScreen(AssignedPair pair, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => DeviceScreen(future: Future.value(pair)),
      ),
    );
  }

  VehicleScreen({@required this.future});
}
