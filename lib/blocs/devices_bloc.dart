import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/auth_bloc.dart';
import 'package:kelvin_mobile/blocs/connection_bloc.dart';
import 'package:kelvin_mobile/blocs/errors.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:meta/meta.dart';

class DevicesBloc extends Bloc<DevicesAction, DevicesState> {
  final DeviceService _deviceService;
  final ApiConnectionBloc _connectionBloc;
  final AuthBloc _authBloc;
  final List<StreamSubscription> _subscriptions = [];

  DevicesBloc(this._deviceService, this._connectionBloc, this._authBloc) {
    // ignore: cancel_subscriptions
    final authSubs = _authBloc.state
        .where((state) => state.authorized)
        .listen((_) => load());

    // ignore: cancel_subscriptions
    final connectionSubs = _connectionBloc.state
        .where((state) => state.connected && _authBloc.currentState.authorized)
        .listen((_) => load());

    _subscriptions.addAll([authSubs, connectionSubs]);
  }

  @override
  DevicesState get initialState => DevicesState.initial();

  void load() => dispatch(const LoadDevices());

  void _load() async {
    try {
      await _checkAuth();
      final devices = await _deviceService.getAll(
        url: _connectionBloc.currentState.url,
        token: _authBloc.currentState.token,
      );
      dispatch(DevicesUpdate(devices));
    } on AuthException catch (e) {
      print(e);
      dispatch(DevicesError(e.message));
    } catch (e) {
      final message = DeviceErrors.cantGetDevices;
      print(e);
      dispatch(DevicesError(message));
    }
  }

  Future<void> _checkAuth() async {
    final connectionState =
        await _connectionBloc.state.firstWhere((state) => !state.loading);
    if (!connectionState.connected) {
      throw NoConnectionException();
    }
    final authState =
        await _authBloc.state.firstWhere((state) => !state.loading);
    if (!authState.authorized) {
      throw UnauthorizedException();
    }
  }

  @override
  Stream<DevicesState> mapEventToState(
    DevicesState currentState,
    DevicesAction event,
  ) async* {
    if (event is LoadDevices) {
      yield currentState.setLoading();
      _load();
    } else if (event is DevicesUpdate) {
      yield DevicesState.from(event.devices);
    } else if (event is DevicesError) {
      yield currentState.setError(event.message);
    } else {
      yield currentState;
    }
  }

  @override
  void dispose() {
    print('disposing devices bloc');
    _subscriptions.forEach((s) => s.cancel());
    super.dispose();
  }
}

@immutable
class DevicesState {
  final List<Device> devices;
  final bool loading;
  final bool hasError;
  final String errorMessage;

  static final _initialState = DevicesState.from([]);

  DevicesState._({
    this.devices,
    this.loading = false,
    this.hasError = false,
    this.errorMessage = '',
  });

  factory DevicesState.initial() => _initialState;

  factory DevicesState.from(List<Device> devices) {
    return DevicesState._(devices: devices);
  }

  DevicesState setLoading() {
    return DevicesState._(devices: devices, loading: true);
  }

  DevicesState setError(String message) {
    return DevicesState._(
      devices: devices,
      hasError: true,
      errorMessage: message,
    );
  }
}

abstract class DevicesAction {
  const DevicesAction();
}

class LoadDevices extends DevicesAction {
  const LoadDevices();
}

class DevicesUpdate extends DevicesAction {
  final List<Device> devices;

  DevicesUpdate(this.devices);
}

class DevicesError extends DevicesAction {
  final String message;

  DevicesError(this.message);
}
