import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/widgets/providers/device_service_provider.dart';
import 'package:kelvin_mobile/widgets/providers/link_parser_provider.dart';
import 'package:kelvin_mobile/widgets/providers/scanner_service_provider.dart';

class VehicleScreen extends StatelessWidget {
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículo'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: <Widget>[
            ListTile(
              title: Text('ID'),
              subtitle: Text(vehicle.id),
            ),
            ListTile(
              title: Text('Patente'),
              subtitle: Text(vehicle.domain),
            ),
            ListTile(
              title: Text('Marca'),
              subtitle: Text(vehicle.brand),
            ),
            ListTile(
              title: Text('Modelo'),
              subtitle: Text(vehicle.model),
            ),
            ListTile(
              title: Text('Número de ruedas'),
              subtitle: Text(vehicle.wheels.toString()),
            ),
            _deviceTile(vehicle.deviceId, context),
          ],
        ).toList(),
      ),
      floatingActionButton: Builder(
        builder: (c) {
          return FloatingActionButton(
            onPressed: () => _scan(c),
            child: Icon(CustomIcons.qrcode),
          );
        },
      ),
    );
  }

  Future _scan(BuildContext context) async {
    try {
      String barcode = await ScannerServiceProvider.of(context).scan();
      final info = LinkParserProvider.of(context).parse(barcode);
      if (info.type == LinkType.DEVICE) {
        _pushDeviceScreen(info.id, context);
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

  Widget _deviceTile(String id, BuildContext context) {
    return vehicle.deviceId == null
        ? const ListTile(
            title: Text('Dispositivo asignado'),
            subtitle: Text('No asignado'),
          )
        : ListTile(
            title: Text('Dispositivo asignado'),
            subtitle: Text(vehicle.deviceId),
            onTap: () => _pushDeviceScreen(vehicle.deviceId, context),
          );
  }

  Future _pushDeviceScreen(String id, BuildContext context) async {
    final device = await DeviceServiceProvider.of(context).getById(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (c) => DeviceScreen(device: device)),
    );
  }

  VehicleScreen({@required this.vehicle});
}
