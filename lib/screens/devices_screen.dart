import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/providers/assignment_service_provider.dart';
import 'package:kelvin_mobile/widgets/search_scaffold.dart';
import 'package:kelvin_mobile/widgets/text_section_list.dart';

class DevicesScreen extends StatelessWidget {
  final Future<List<Device>> future;

  DevicesScreen({@required this.future});

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
    return FutureBuilder<List<Device>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _resultScreen(snapshot.data);
          case ConnectionState.waiting:
            return _loadingScreen();
          default:
            throw Exception('wtf');
        }
      },
    );
  }

  Widget _loadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
      ),
      body: Loading(),
    );
  }

  Widget _resultScreen(List<Device> devices) {
    devices.sort((a, b) => a.alias.compareTo(b.alias));

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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => DeviceScreen(
              future:
                  AssignmentServiceProvider.of(context).getDevicePair(device),
            ),
      ),
    );
  }
}
