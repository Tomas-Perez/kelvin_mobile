import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/screens/device_screen.dart';
import 'package:kelvin_mobile/utils/funcs.dart';
import 'package:kelvin_mobile/widgets/loading.dart';
import 'package:kelvin_mobile/widgets/search_scaffold.dart';
import 'package:kelvin_mobile/widgets/text_section_list.dart';

class DevicesScreen extends StatelessWidget {

  DevicesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesAction, DevicesState>(
      bloc: BlocProvider.of<DevicesBloc>(context),
      builder: (context, state) {
        if (state.loading && state.devices.isEmpty) {
          return _loadingScreen();
        }
        if (state.hasError) {
          throw Exception(state.errorMessage);
        }
        return _resultScreen(state.devices);
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
        return RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: TextSectionList<Device>(
            sections: groupByInitials(
              devices.where((d) => searchFilter(d.alias, search)).toList(),
              toString: (d) => d.alias,
            ),
            valueToString: (d) => d.alias,
            onTap: (d) => _pushDeviceScreen(context, d),
          ),
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
        builder: (c) => DeviceScreen(deviceId: device.id),
      ),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = BlocProvider.of<DevicesBloc>(context);
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
