import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment_action.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment_state.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:meta/meta.dart';

class AssignmentBloc extends Bloc<AssignmentAction, AssignmentState> {
  final DevicesBloc devicesBloc;
  final VehiclesBloc vehiclesBloc;
  String deviceId;
  String vehicleId;
  final List<StreamSubscription> _subscriptions = [];

  AssignmentBloc._({
    @required this.devicesBloc,
    @required this.vehiclesBloc,
    this.deviceId,
    this.vehicleId,
  }) {
    if (deviceId != null) {
      _onDevicesUpdate(devicesBloc.currentState);
    }

    if (vehicleId != null) {
      _onVehiclesUpdate(vehiclesBloc.currentState);
    } else {
      _onVehiclesUpdateWithNullId(vehiclesBloc.currentState);
    }

    // ignore: cancel_subscriptions
    final devicesSubs = devicesBloc.state
        .where((_) => deviceId != null)
        .listen(_onDevicesUpdate);

    // ignore: cancel_subscriptions
    final vehiclesSubs = vehiclesBloc.state
        .where((_) => vehicleId != null)
        .listen(_onVehiclesUpdate);

    // ignore: cancel_subscriptions
    final vehiclesSubsWithNull = vehiclesBloc.state
        .where((_) => vehicleId == null)
        .listen(_onVehiclesUpdateWithNullId);

    _subscriptions.addAll([devicesSubs, vehiclesSubs, vehiclesSubsWithNull]);
  }

  factory AssignmentBloc.forDevice({
    @required DevicesBloc devicesBloc,
    @required VehiclesBloc vehiclesBloc,
    @required String deviceId,
  }) {
    return AssignmentBloc._(
      devicesBloc: devicesBloc,
      vehiclesBloc: vehiclesBloc,
      deviceId: deviceId,
    );
  }

  factory AssignmentBloc.forVehicle({
    @required DevicesBloc devicesBloc,
    @required VehiclesBloc vehiclesBloc,
    @required String vehicleId,
  }) {
    return AssignmentBloc._(
      devicesBloc: devicesBloc,
      vehiclesBloc: vehiclesBloc,
      vehicleId: vehicleId,
    );
  }

  void _onDevicesUpdate(DevicesState devicesState) {
    if (devicesState.hasError) {
      dispatch(AssignmentError(devicesState.errorMessage));
      return;
    }
    if (devicesState.loading) {
      dispatch(const AssignmentLoading());
      return;
    }

    try {
      final device = devicesState.devices.firstWhere((d) => d.id == deviceId);
      dispatch(DeviceUpdate(device));
    } catch (e) {
      print('Device not found');
      dispatch(const AssignmentError('Device not found'));
    }
  }

  void _onVehiclesUpdate(VehiclesState vehiclesState) {
    if (vehiclesState.hasError) {
      dispatch(AssignmentError(vehiclesState.errorMessage));
      return;
    }
    if (vehiclesState.loading) {
      dispatch(const AssignmentLoading());
      return;
    }

    try {
      final vehicle =
          vehiclesState.vehicles.firstWhere((v) => v.id == vehicleId);
      if (deviceId != vehicle.deviceId) {
        deviceId = vehicle.deviceId;
        _onDevicesUpdate(devicesBloc.currentState);
      }
      dispatch(VehicleUpdate(vehicle));
    } catch (e) {
      print('Vehicle not found');
      dispatch(const AssignmentError('Vehicle not found'));
    }
  }

  void _onVehiclesUpdateWithNullId(VehiclesState vehiclesState) {
    if (vehiclesState.hasError || vehiclesState.loading) return;

    final vehicle = vehiclesState.vehicles
        .firstWhere((v) => v.deviceId == deviceId, orElse: () => null);
    if (vehicle != null) {
      vehicleId = vehicle.id;
      dispatch(VehicleUpdate(vehicle));
    }
  }

  @override
  AssignmentState get initialState => AssignmentState.initial();

  @override
  Stream<AssignmentState> mapEventToState(
    AssignmentState currentState,
    AssignmentAction event,
  ) async* {
    yield event.perform(currentState);
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.forEach((s) => s.cancel());
  }
}
