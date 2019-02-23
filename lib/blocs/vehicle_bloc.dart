import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/errors.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:meta/meta.dart';

class VehicleBloc extends Bloc<VehicleAction, VehicleState> {
  final VehiclesBloc vehiclesBloc;
  final String vehicleId;
  StreamSubscription _subscription;

  VehicleBloc(this.vehiclesBloc, this.vehicleId) {
    _subscription = vehiclesBloc.state.listen(_onVehiclesUpdate);
  }

  void _onVehiclesUpdate(VehiclesState vehiclesState) {
    if (vehiclesState.hasError) {
      dispatch(VehicleError(vehiclesState.errorMessage));
      return;
    }
    if (vehiclesState.loading) {
      dispatch(const VehicleLoading());
      return;
    }

    try {
      final vehicle =
          vehiclesState.vehicles.firstWhere((v) => v.id == vehicleId);
      dispatch(VehicleUpdate(vehicle));
    } catch (e) {
      print(VehicleErrors.vehicleNotFound);
      dispatch(const VehicleError(VehicleErrors.vehicleNotFound));
    }
  }

  @override
  VehicleState get initialState => VehicleState.initial();

  @override
  Stream<VehicleState> mapEventToState(
    VehicleState currentState,
    VehicleAction event,
  ) async* {
    if (event is VehicleLoading) {
      yield currentState.setLoading();
    }
    if (event is VehicleError) {
      yield currentState.setError(event.errorMessage);
    }
    if (event is VehicleUpdate) {
      yield VehicleState.from(event.vehicle);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

@immutable
class VehicleState {
  final Vehicle vehicle;
  final bool loading;
  final bool hasError;
  final String errorMessage;

  static final _initialState = VehicleState.from(null);

  VehicleState._({
    this.vehicle,
    this.loading = false,
    this.hasError = false,
    this.errorMessage = '',
  });

  factory VehicleState.initial() => _initialState;

  factory VehicleState.from(Vehicle vehicle) {
    return VehicleState._(vehicle: vehicle);
  }

  VehicleState setLoading() {
    return VehicleState._(vehicle: vehicle, loading: true);
  }

  VehicleState setError(String message) {
    return VehicleState._(
      vehicle: vehicle,
      hasError: true,
      errorMessage: message,
    );
  }
}

abstract class VehicleAction {
  const VehicleAction();
}

class VehicleError extends VehicleAction {
  final String errorMessage;

  const VehicleError(this.errorMessage);
}

class VehicleLoading extends VehicleAction {
  const VehicleLoading();
}

class VehicleUpdate extends VehicleAction {
  final Vehicle vehicle;

  VehicleUpdate(this.vehicle);
}
