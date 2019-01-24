import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/screens/devices_screen.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/screens/vehicles_screen.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/widgets/providers/assignment_service_provider.dart';
import 'package:kelvin_mobile/widgets/providers/device_service_provider.dart';
import 'package:kelvin_mobile/widgets/providers/link_parser_provider.dart';
import 'package:kelvin_mobile/widgets/providers/scanner_service_provider.dart';
import 'package:kelvin_mobile/widgets/providers/vehicle_service_provider.dart';

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
      final barcode = await ScannerServiceProvider.of(context).scan();
      final info = LinkParserProvider.of(context).parse(barcode);
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
    final deviceFuture = DeviceServiceProvider.of(context).getById(id);
    final pairFuture = deviceFuture
        .then((d) => AssignmentServiceProvider.of(context).getDevicePair(d));
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
    final vehicleFuture = VehicleServiceProvider.of(context).getById(id);
    final pairFuture = vehicleFuture
        .then((v) => AssignmentServiceProvider.of(context).getVehiclePair(v));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => VehicleScreen(future: pairFuture),
      ),
    );
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
        builder: (c) => VehiclesScreen(vehicles: vehicles),
      ),
    );
  }

  void _pushDevicesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => DevicesScreen(devices: devices),
      ),
    );
  }

  const HomeScreen();
}
