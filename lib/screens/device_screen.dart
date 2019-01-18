import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/widgets/scanner_service_provider.dart';
import 'package:kelvin_mobile/widgets/vehicle_service_provider.dart';

class DeviceScreen extends StatelessWidget {
  final Device device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispositivo'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: <Widget>[
            ListTile(
              title: Text('ID'),
              subtitle: Text(device.id),
            ),
            ListTile(
              title: Text('Alias'),
              subtitle: Text(device.alias),
            ),
            ListTile(
              title: Text('Dirección MAC'),
              subtitle: Text(device.mac),
            ),
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
      if (type == 'vehicle') {
        final vehicle = await VehicleServiceProvider.of(context).getById(id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => VehicleScreen(vehicle: vehicle)),
        );
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Código inválido')));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  DeviceScreen({@required this.device});
}
