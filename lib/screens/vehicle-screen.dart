import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/device-screen.dart';
import 'package:kelvin_mobile/widgets/device-service-provider.dart';

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
            ListTile(
              title: Text('Dispositivo asignado'),
              subtitle: Text(vehicle.deviceId ?? 'No asignado'),
            ),
          ],
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scan(context),
        child: Icon(CustomIcons.qrcode),
      ),
    );
  }

  Future scan(BuildContext context) async {
    try {
      String barcode = 'device/${devices[0].id}';//await BarcodeScanner.scan();
      final params = barcode.split('/');
      final type = params[0];
      final id = params[1];
      if (type == 'device') {
        final device = await DeviceServiceProvider.of(context).getById(id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => DeviceScreen(device: device)),
        );
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Código inválido')));
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('The user did not grant camera permissions');
      } else {
        print('Unknown error: $e');
      }
    } on FormatException {
      print('User returned using the "back"-button)');
    } catch (e) {
      print('Unknown error: $e');
    }
  }

  VehicleScreen({@required this.vehicle});
}
