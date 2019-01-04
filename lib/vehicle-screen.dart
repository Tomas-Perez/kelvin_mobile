import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';

class VehicleScreen extends StatelessWidget {
  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
    );
  }

  VehicleScreen({@required this.vehicle});
}
