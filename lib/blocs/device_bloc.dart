import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:meta/meta.dart';

class DeviceBloc extends Bloc<DeviceAction, DeviceState> {
  final DevicesBloc devicesBloc;
  final String deviceId;
  StreamSubscription _subscription;

  DeviceBloc(this.devicesBloc, this.deviceId) {
    _subscription = devicesBloc.state.listen(_onDevicesUpdate);
  }

  void _onDevicesUpdate(DevicesState devicesState) {
    if (devicesState.hasError) {
      dispatch(DeviceError(devicesState.errorMessage));
      return;
    }
    if (devicesState.loading) {
      dispatch(const DeviceLoading());
      return;
    }

    try {
      final device = devicesState.devices.firstWhere((d) => d.id == deviceId);
      dispatch(DeviceUpdate(device));
    } catch (e) {
      print('not found');
      dispatch(const DeviceError('Not found'));
    }
  }

  @override
  DeviceState get initialState => DeviceState.initial();

  @override
  Stream<DeviceState> mapEventToState(
    DeviceState currentState,
    DeviceAction event,
  ) async* {
    if (event is DeviceLoading) {
      yield currentState.setLoading();
    }
    if (event is DeviceError) {
      yield currentState.setError(event.errorMessage);
    }
    if (event is DeviceUpdate) {
      yield DeviceState.from(event.device);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
}

@immutable
class DeviceState {
  final Device device;
  final bool loading;
  final bool hasError;
  final String errorMessage;

  static final _initialState = DeviceState.from(null);

  DeviceState._({
    this.device,
    this.loading = false,
    this.hasError = false,
    this.errorMessage = '',
  });

  factory DeviceState.initial() => _initialState;

  factory DeviceState.from(Device device) {
    return DeviceState._(device: device);
  }

  DeviceState setLoading() {
    return DeviceState._(device: device, loading: true);
  }

  DeviceState setError(String message) {
    return DeviceState._(
      device: device,
      hasError: true,
      errorMessage: message,
    );
  }
}

abstract class DeviceAction {
  const DeviceAction();
}

class DeviceError extends DeviceAction {
  final String errorMessage;

  const DeviceError(this.errorMessage);
}

class DeviceLoading extends DeviceAction {
  const DeviceLoading();
}

class DeviceUpdate extends DeviceAction {
  final Device device;

  DeviceUpdate(this.device);
}
