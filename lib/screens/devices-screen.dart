import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/screens/device-screen.dart';
import 'package:kelvin_mobile/widgets/search-scaffold.dart';
import 'package:kelvin_mobile/widgets/text-section-list.dart';

class DevicesScreen extends StatelessWidget {
  final List<Device> devices;

  DevicesScreen({@required List<Device> devices})
      : devices = devices..sort((a, b) => a.alias.compareTo(b.alias));

  Map<String, List<Device>> _groupByInitials(List<Device> devices) {
    return groupBy(devices, (d) => d.alias.substring(0, 1).toUpperCase());
  }

  bool _filter(String alias, String search) {
    return alias
        .toLowerCase()
        .trim()
        .contains(RegExp(r'' + search.toLowerCase().trim() + ''));
  }

  @override
  Widget build(BuildContext context) {
    return SearchScaffold(
      bodyBuilder: (context, search) {
        return TextSectionList<Device>(
          sections: _groupByInitials(
              devices.where((d) => _filter(d.alias, search)).toList()),
          valueToString: (d) => d.alias,
          onTap: (d) => _pushDeviceScreen(context, d),
        );
      },
      title: 'Dispositivos',
      searchHint: 'Buscar dispositivos',
    );
  }

  void _pushDeviceScreen(BuildContext context, Device device) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return DeviceScreen(
            device: device,
          );
        },
      ),
    );
  }
}
