import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/auth_bloc.dart';
import 'package:kelvin_mobile/blocs/connection_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
import 'package:meta/meta.dart';

class VehiclesBloc extends Bloc<VehiclesAction, VehiclesState> {
  final VehicleService _vehicleService;
  final ApiConnectionBloc _connectionBloc;
  final AuthBloc _authBloc;
  final List<StreamSubscription> _subscriptions = [];

  VehiclesBloc(this._vehicleService, this._connectionBloc, this._authBloc) {
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
  VehiclesState get initialState => VehiclesState.initial();

  void load() => dispatch(const LoadVehicles());

  void _load() async {
    try {
      await _checkAuth();
      final vehicles = await _vehicleService.getAll(
        url: _connectionBloc.currentState.url,
        token: _authBloc.currentState.token,
      );
      dispatch(VehiclesUpdate(vehicles));
    } on AuthException catch (e) {
      print(e);
      dispatch(VehiclesError(e.message));
    } catch (e) {
      final message = 'Error getting all vehicles';
      print(e);
      dispatch(VehiclesError(message));
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
  Stream<VehiclesState> mapEventToState(
    VehiclesState currentState,
    VehiclesAction event,
  ) async* {
    print('vehicles event');
    print(event);
    if (event is LoadVehicles) {
      yield currentState.setLoading();
      _load();
    } else if (event is VehiclesUpdate) {
      yield VehiclesState.from(event.vehicles);
    } else if (event is VehiclesError) {
      yield currentState.setError(event.message);
    } else {
      yield currentState;
    }
  }

  @override
  void dispose() {
    print('disposing vehicles bloc');
    _subscriptions.forEach((s) => s.cancel());
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

class VehiclesUpdate extends VehiclesAction {
  final List<Vehicle> vehicles;

  VehiclesUpdate(this.vehicles);
}

class VehiclesError extends VehiclesAction {
  final String message;

  VehiclesError(this.message);
}
