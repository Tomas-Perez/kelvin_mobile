import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/vehicle-screen.dart';
import 'package:kelvin_mobile/widgets/vehicle-service-provider.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => scan(context),
        child: Icon(CustomIcons.qrcode),
      ),
    );
  }

  Future scan(BuildContext context) async {
    try {
      String barcode = 'vehicle/${vehicles[0].id}';//await BarcodeScanner.scan();
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

  DeviceScreen({@required this.device});
}
