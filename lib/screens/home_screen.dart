import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/screens/devices_screen.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/screens/vehicles_screen.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
import 'package:kelvin_mobile/widgets/home_card.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

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
            child: Icon(CustomIcons.qrcode),
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
        case LinkType.DEVICE:
          _onScannedDevice(info.id, context);
          break;
        case LinkType.VEHICLE:
          _onScannedVehicle(info.id, context);
          break;
      }
    } on UnknownTypeException catch (e) {
      Errors.show(context, exc: e, message: Errors.INVALID_CODE);
    } on FormatException catch (e) {
      Errors.show(context, exc: e, message: Errors.INVALID_CODE);
    } catch (e) {
      print('Error: $e');
    }
  }

  _onScannedDevice(String id, BuildContext context) {
    final deviceFuture = ServiceProvider.of<DeviceService>(context).getById(id);
    final pairFuture = deviceFuture.then(
        (d) => ServiceProvider.of<AssignmentService>(context).getDevicePair(d));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => DeviceScreen(
              future: pairFuture,
            ),
      ),
    );
  }

  _onScannedVehicle(String id, BuildContext context) {
    final vehicleFuture =
        ServiceProvider.of<VehicleService>(context).getById(id);
    final pairFuture = vehicleFuture.then((v) =>
        ServiceProvider.of<AssignmentService>(context).getVehiclePair(v));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => VehicleScreen(future: pairFuture),
      ),
    );
  }

  void _pushVehiclesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) {
          return VehiclesScreen(
            future: ServiceProvider.of<VehicleService>(context).getAll(),
          );
        },
      ),
    );
  }

  void _pushDevicesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) {
          return DevicesScreen(
            future: ServiceProvider.of<DeviceService>(context).getAll(),
          );
        },
      ),
    );
  }
}
