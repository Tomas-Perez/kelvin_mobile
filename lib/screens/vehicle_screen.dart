import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/widgets/device_service_provider.dart';
import 'package:kelvin_mobile/widgets/scanner_service_provider.dart';

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
      final params = barcode.split('/');
      final type = params[0];
      final id = params[1];
      if (type == 'device') {
        _pushDeviceScreen(id, context);
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Código inválido')));
      }
    } catch (e) {
      print('Error: $e');
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
