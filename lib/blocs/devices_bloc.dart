import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:meta/meta.dart';

class DevicesBloc extends Bloc<DevicesAction, DevicesState> {
  final DeviceService _deviceService;

  DevicesBloc(this._deviceService);

  void load() => dispatch(const LoadDevices());

  @override
  DevicesState get initialState => DevicesState.initial();

  @override
  Stream<DevicesState> mapEventToState(
    DevicesState currentState,
    DevicesAction event,
  ) async* {
    if (event is LoadDevices) {
      yield currentState.setLoading();
      try {
        final devices = await _deviceService.getAll();
        yield DevicesState.from(devices);
      } catch (e) {
        final message = 'Error getting all devices';
        print(message);
        yield currentState.setError(message);
      }
    } else {
      yield currentState;
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('disposing devices bloc');
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
