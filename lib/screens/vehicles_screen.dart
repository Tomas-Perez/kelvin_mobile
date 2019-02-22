import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/screens/errors.dart';
import 'package:kelvin_mobile/screens/vehicle_screen.dart';
import 'package:kelvin_mobile/utils/funcs.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/search_scaffold.dart';
import 'package:kelvin_mobile/widgets/text_section_list.dart';

class VehiclesScreen extends StatelessWidget {
  VehiclesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehiclesAction, VehiclesState>(
      bloc: BlocProvider.of<VehiclesBloc>(context),
      builder: (context, state) {
        if (state.loading && state.vehicles.isEmpty) {
          return _loadingScreen();
        }
        if (state.hasError) {
          return _errorScreen(Errors.generic);
        }
        if (state.vehicles.isEmpty) {
          return _errorScreen(Errors.noVehicles);
        }
        return _resultScreen(state.vehicles);
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

  Widget _errorScreen(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos'),
      ),
      body: Center(child: Text(message)),
    );
  }

  Widget _resultScreen(List<Vehicle> vehicles) {
    vehicles.sort((a, b) => a.domain.compareTo(b.domain));

    return SearchScaffold(
      bodyBuilder: (context, search) {
        return RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: TextSectionList<Vehicle>(
            sections: groupByInitials(
              vehicles.where((v) => searchFilter(v.domain, search)).toList(),
              toString: (v) => v.domain,
            ),
            valueToString: (v) => v.domain,
            onTap: (v) => _pushVehicleScreen(context, v),
          ),
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
        builder: (context) => VehicleScreen(vehicleId: vehicle.id),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = BlocProvider.of<VehiclesBloc>(context);
    bloc.load();
    var alreadyLoading = false;
    await bloc.state.firstWhere((s) {
      if (!alreadyLoading) {
        if (s.loading) {
          alreadyLoading = true;
        }
      } else if (!s.loading) {
        return true;
      }
      return false;
    });
  }
}
