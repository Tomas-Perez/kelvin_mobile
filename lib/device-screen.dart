import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';

class DeviceScreen extends StatelessWidget {
  final Device device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
    );
  }

  DeviceScreen({@required this.device});
}
