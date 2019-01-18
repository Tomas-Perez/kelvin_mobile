import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/screens/vehicle-screen.dart';
import 'package:kelvin_mobile/widgets/search-scaffold.dart';
import 'package:kelvin_mobile/widgets/text-section-list.dart';

class VehiclesScreen extends StatelessWidget {
  final List<Vehicle> vehicles;

  VehiclesScreen({@required List<Vehicle> vehicles})
      : vehicles = vehicles..sort((a, b) => a.domain.compareTo(b.domain));

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
              vehicle: vehicle,
            ),
      ),
    );
  }
}
