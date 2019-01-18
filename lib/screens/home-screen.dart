import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/device-screen.dart';
import 'package:kelvin_mobile/screens/devices-screen.dart';
import 'package:kelvin_mobile/screens/vehicle-screen.dart';
import 'package:kelvin_mobile/screens/vehicles-screen.dart';
import 'package:kelvin_mobile/widgets/device-service-provider.dart';
import 'package:kelvin_mobile/widgets/vehicle-service-provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelvin'),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            _makeCard(
              image: 'assets/trucks.jpg',
              title: 'Vehículos',
              onTap: () => _pushVehiclesScreen(context),
              context: context,
            ),
            _makeCard(
              image: 'assets/electronics.jpg',
              title: 'Dispositivos',
              onTap: () => _pushDevicesScreen(context),
              context: context,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scan(context),
        child: Icon(CustomIcons.qrcode),
      ),
    );
  }

  Future scan(BuildContext context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      final params = barcode.split('/');
      final type = params[0];
      final id = params[1];
      if (type == 'vehicle') {
        final vehicle = await VehicleServiceProvider.of(context).getById(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => VehicleScreen(
                  vehicle: vehicle,
                ),
          ),
        );
      } else if (type == 'device') {
        final device = await DeviceServiceProvider.of(context).getById(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => DeviceScreen(
                  device: device,
                ),
          ),
        );
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

  Widget _makeCard({
    @required String image,
    @required String title,
    @required GestureTapCallback onTap,
    @required BuildContext context,
  }) {
    return Stack(
      children: <Widget>[
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(image),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Container(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _pushVehiclesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => VehiclesScreen(
              vehicles: vehicles,
            ),
      ),
    );
  }

  void _pushDevicesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => DevicesScreen(
              devices: devices,
            ),
      ),
    );
  }

  const HomeScreen();
}
