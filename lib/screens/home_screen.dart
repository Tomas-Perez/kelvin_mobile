import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/screens/devices_screen.dart';
import 'package:kelvin_mobile/screens/settings_screen.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/screens/vehicles_screen.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/widgets/home_card.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';
import 'package:kelvin_mobile/widgets/qr_search_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelvin'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _pushSettingsScreen(context),
            tooltip: 'Ajustes',
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(8.0),
          children: <Widget>[
            HomeCard(
              image: 'assets/trucks.jpg',
              title: 'Vehículos',
              onTap: () => _pushVehiclesScreen(context),
            ),
            HomeCard(
              image: 'assets/electronics.jpg',
              title: 'Dispositivos',
              onTap: () => _pushDevicesScreen(context),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (c) {
          return FloatingActionButton(
            onPressed: () => _scan(c),
            child: QRSearchIcon(),
            tooltip: 'Búsqueda QR',
          );
        },
      ),
    );
  }

  Future _scan(BuildContext context) async {
    try {
      final barcode = await ServiceProvider.of<ScannerService>(context).scan();
      final info = ServiceProvider.of<LinkParser>(context).parse(barcode);
      switch (info.type) {
        case LinkType.device:
          _onScannedDevice(info.id, context);
          break;
        case LinkType.vehicle:
          _onScannedVehicle(info.id, context);
          break;
      }
    } on UnknownTypeException catch (e) {
      Errors.show(context, exc: e, message: Errors.invalidCode);
    } on FormatException catch (e) {
      Errors.show(context, exc: e, message: Errors.invalidCode);
    } catch (e) {
      print('Error: $e');
    }
  }

  _onScannedDevice(String id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => DeviceScreen(deviceId: id),
      ),
    );
  }

  _onScannedVehicle(String id, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => VehicleScreen(vehicleId: id),
      ),
    );
  }

  void _pushSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => SettingsScreen(),
      ),
    );
  }

  void _pushVehiclesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => VehiclesScreen(),
      ),
    );
  }

  void _pushDevicesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) {
          return DevicesScreen();
        },
      ),
    );
  }
}
