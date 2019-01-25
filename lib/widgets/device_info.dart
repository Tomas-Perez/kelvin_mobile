import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';

class DeviceInfo extends StatelessWidget {
  final Device device;
  final Vehicle vehicle;
  final Function() onVehicleTap;

  DeviceInfo({
    Key key,
    @required this.device,
    @required this.vehicle,
    @required this.onVehicleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: <Widget>[
          ListTile(
            title: const Text('ID'),
            subtitle: Text(device.id),
          ),
          ListTile(
            title: const Text('Alias'),
            subtitle: Text(device.alias),
          ),
          ListTile(
            title: const Text('Dirección MAC'),
            subtitle: Text(device.mac),
          ),
          _vehicleTile()
        ],
      ).toList(),
    );
  }

  Widget _vehicleTile() {
    return vehicle == null
        ? const ListTile(
            title: const Text('Vehículo asignado'),
            subtitle: const Text('No asignado'),
          )
        : ListTile(
            title: const Text('Vehículo asignado'),
            subtitle: Text(vehicle.domain),
            onTap: onVehicleTap,
          );
  }
}
