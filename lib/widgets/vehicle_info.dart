import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';

class VehicleInfo extends StatelessWidget {
  final Vehicle vehicle;
  final Device device;
  final Function() onDeviceTap;

  VehicleInfo({
    Key key,
    @required this.vehicle,
    @required this.device,
    @required this.onDeviceTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: <Widget>[
          ListTile(
            title: const Text('ID'),
            subtitle: Text(vehicle.id),
          ),
          ListTile(
            title: const Text('Dueño'),
            subtitle: Text(vehicle.ownerName),
          ),
          ListTile(
            title: const Text('Patente'),
            subtitle: Text(vehicle.domain),
          ),
          ListTile(
            title: const Text('Marca'),
            subtitle: Text(vehicle.brand),
          ),
          ListTile(
            title: const Text('Modelo'),
            subtitle: Text(vehicle.model),
          ),
          ListTile(
            title: const Text('Número de ruedas'),
            subtitle: Text(vehicle.wheels.toString()),
          ),
          _deviceTile(),
        ],
      ).toList(),
    );
  }

  Widget _deviceTile() {
    return device == null
        ? const ListTile(
            title: Text('Dispositivo asignado'),
            subtitle: Text('No asignado'),
          )
        : ListTile(
            title: Text('Dispositivo asignado'),
            subtitle: Text(device.alias),
            onTap: onDeviceTap,
          );
  }
}
