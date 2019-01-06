import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/screens/vehicle-screen.dart';
import 'package:kelvin_mobile/widgets/text-section-list.dart';
import 'package:material_search/material_search.dart';

class VehiclesScreen extends StatelessWidget {
  final List<Vehicle> vehicles;
  final Map<String, List<Vehicle>> sectionedVehicles;

  VehiclesScreen({@required List<Vehicle> vehicles})
      : vehicles = vehicles..sort((a, b) => a.domain.compareTo(b.domain)),
        sectionedVehicles =
            groupBy(vehicles, (v) => v.domain.substring(0, 1).toUpperCase());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículos'),
        actions: <Widget>[
          new IconButton(
            onPressed: () => _pushMaterialSearch(context),
            tooltip: 'Search',
            icon: new Icon(Icons.search),
          )
        ],
      ),
      body: TextSectionList<Vehicle>(
        sections: sectionedVehicles,
        valueToString: (v) => v.domain,
        onTap: (v) => _pushVehicleScreen(context, v),
      ),
    );
  }

  void _pushVehicleScreen(BuildContext context, Vehicle vehicle) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return VehicleScreen(
            vehicle: vehicle,
          );
        },
      ),
    );
  }

  void _pushMaterialSearch(BuildContext context) {
    Navigator.of(context).push(_searchPage()).then((v) {
      if (v != null) _pushVehicleScreen(context, v);
    });
  }

  MaterialPageRoute<Vehicle> _searchPage() {
    return MaterialPageRoute<Vehicle>(
      builder: (BuildContext context) {
        return Material(
          child: MaterialSearch<Vehicle>(
            placeholder: 'Search',
            limit: 20,
            results: vehicles
                .map((v) => MaterialSearchResult<Vehicle>(
                      value: v,
                      text: v.domain,
                    ))
                .toList(),
            sort: (dynamic a, dynamic b, String _) =>
                a.domain.compareTo(b.domain),
            onSelect: (dynamic value) => Navigator.of(context).pop(value),
          ),
        );
      },
    );
  }
}
