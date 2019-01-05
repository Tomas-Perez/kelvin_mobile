import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:collection/collection.dart';
import 'package:kelvin_mobile/vehicle-screen.dart';
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
      body: _makeList(context),
    );
  }

  void _pushVehicleScreen(Vehicle vehicle, BuildContext context) {
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

  _makeList(BuildContext context) {
    return ListView(
      children: sectionedVehicles.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _sectionHeader(entry.key, context),
            _sectionBody(sectionedVehicles[entry.key], context)
          ],
        );
      }).toList(),
    );
  }

  Widget _sectionBody(List<Vehicle> vehicles, BuildContext context) {
    return Column(
      children: ListTile.divideTiles(
        context: context,
        tiles: vehicles.map(
          (v) => ListTile(
                title: Text(v.domain),
                onTap: () => _pushVehicleScreen(v, context),
              ),
        ),
      ).toList(),
    );
  }

  Widget _sectionHeader(String name, BuildContext context) {
    return Container(
      child: Text(
        name,
        style: Theme.of(context).textTheme.subhead,
      ),
      color: Theme.of(context).dividerColor,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    );
  }

  _pushMaterialSearch(BuildContext context) {
    Navigator.of(context).push(_searchPage()).then((v) {
      if (v != null) _pushVehicleScreen(v, context);
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
