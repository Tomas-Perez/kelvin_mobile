import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/providers/service_provider.dart';
import 'package:kelvin_mobile/widgets/search_scaffold.dart';
import 'package:kelvin_mobile/widgets/text_section_list.dart';

class VehiclesScreen extends StatelessWidget {
  final Future<List<Vehicle>> future;

  VehiclesScreen({Key key, @required this.future}) : super(key: key);

  Map<String, List<Vehicle>> _groupByInitials(List<Vehicle> vehicles) {
    return groupBy(vehicles, (v) => v.domain.substring(0, 1).toUpperCase());
  }

  bool _filter(String domain, String search) {
    return domain
        .toLowerCase()
        .trim()
        .contains(RegExp(r'' + search.toLowerCase().trim() + ''));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vehicle>>(
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
        title: const Text('Vehículos'),
      ),
      body: Loading(),
    );
  }

  Widget _resultScreen(List<Vehicle> vehicles) {
    vehicles.sort((a, b) => a.domain.compareTo(b.domain));

    return SearchScaffold(
      bodyBuilder: (context, search) {
        return TextSectionList<Vehicle>(
          sections: _groupByInitials(
              vehicles.where((v) => _filter(v.domain, search)).toList()),
          valueToString: (v) => v.domain,
          onTap: (v) => _pushVehicleScreen(context, v),
        );
      },
      title: 'Vehículos',
      searchHint: 'Buscar vehículo',
    );
  }

  void _pushVehicleScreen(BuildContext context, Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleScreen(
              future:
              ServiceProvider.of<AssignmentService>(context).getVehiclePair(vehicle),
            ),
      ),
    );
  }
}
