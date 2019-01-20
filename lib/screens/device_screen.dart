import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/errors/errors.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/services/link_parser.dart';
import 'package:kelvin_mobile/widgets/providers/link_parser_provider.dart';
import 'package:kelvin_mobile/widgets/providers/scanner_service_provider.dart';
import 'package:kelvin_mobile/widgets/providers/vehicle_service_provider.dart';

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
      final barcode = await ScannerServiceProvider.of(context).scan();
      final info = LinkParserProvider.of(context).parse(barcode);
      if (info.type == LinkType.VEHICLE) {
        final vehicle =
            await VehicleServiceProvider.of(context).getById(info.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => VehicleScreen(vehicle: vehicle)),
        );
      } else {
        Errors.show(context, message: Errors.NOT_A_VEHICLE);
      }
    } on UnknownTypeException catch (e) {
      Errors.show(context, exc : e, message : Errors.NOT_A_VEHICLE);
    } on FormatException catch (e) {
      Errors.show(context, exc : e, message : Errors.INVALID_CODE);
    } catch (e) {
      Errors.show(context, exc: e);
    }
  }

  DeviceScreen({@required this.device});
}
