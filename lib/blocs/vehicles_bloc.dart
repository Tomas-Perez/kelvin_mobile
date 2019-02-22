import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
import 'package:meta/meta.dart';

class VehiclesBloc extends Bloc<VehiclesAction, VehiclesState> {
  final VehicleService _vehicleService;

  VehiclesBloc(this._vehicleService) {
    load();
  }

  void load() => dispatch(const LoadVehicles());

  @override
  VehiclesState get initialState => VehiclesState.initial();

  @override
  Stream<VehiclesState> mapEventToState(
    VehiclesState currentState,
    VehiclesAction event,
  ) async* {
    print('vehicles event');
    print(event);
    if (event is LoadVehicles) {
      yield currentState.setLoading();
      try {
        final vehicles = await _vehicleService.getAll();
        yield VehiclesState.from(vehicles);
      } catch (e) {
        final message = 'Error getting all vehicles';
        print(e);
        yield currentState.setError(message);
      }
    } else {
      yield currentState;
    }
  }

  @override
  void dispose() {
    print('disposing vehicles');
    super.dispose();
  }


}

@immutable
class VehiclesState {
  final List<Vehicle> vehicles;
  final bool loading;
  final bool hasError;
  final String errorMessage;

  static final _initialState = VehiclesState.from([]);

  VehiclesState._({
    this.vehicles,
    this.loading = false,
    this.hasError = false,
    this.errorMessage = '',
  });

  factory VehiclesState.initial() => _initialState;

  factory VehiclesState.from(List<Vehicle> vehicles) {
    return VehiclesState._(vehicles: vehicles);
  }

  VehiclesState setLoading() {
    return VehiclesState._(vehicles: vehicles, loading: true);
  }

  VehiclesState setError(String message) {
    return VehiclesState._(
      vehicles: vehicles,
      hasError: true,
      errorMessage: message,
    );
  }
}

abstract class VehiclesAction {
  const VehiclesAction();
}

class LoadVehicles extends VehiclesAction {
  const LoadVehicles();
}
