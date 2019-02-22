import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment_action.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment_state.dart';
import 'package:kelvin_mobile/blocs/auth_bloc.dart';
import 'package:kelvin_mobile/blocs/connection_bloc.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:meta/meta.dart';

class DeviceAssignmentBloc extends Bloc<AssignmentAction, AssignmentState> {
  final DevicesBloc devicesBloc;
  final VehiclesBloc vehiclesBloc;
  final AssignmentService assignmentService;
  final ApiConnectionBloc connectionBloc;
  final AuthBloc authBloc;
  final String deviceId;
  final List<StreamSubscription> _subscriptions = [];

  DeviceAssignmentBloc({
    @required this.devicesBloc,
    @required this.vehiclesBloc,
    @required this.assignmentService,
    @required this.connectionBloc,
    @required this.authBloc,
    @required this.deviceId,
  }) {
    // ignore: cancel_subscriptions
    final devicesSubs = devicesBloc.state.listen(_onDevicesUpdate);

    // ignore: cancel_subscriptions
    final vehiclesSubs = vehiclesBloc.state
        .where((_) => currentState.pair.vehicle != null)
        .listen(_onVehiclesUpdate);

    // ignore: cancel_subscriptions
    final vehiclesSubsWithNull = vehiclesBloc.state
        .where((_) => currentState.pair.vehicle == null)
        .listen(_onVehiclesUpdateWithNullId);

    _subscriptions.addAll([devicesSubs, vehiclesSubs, vehiclesSubsWithNull]);
  }

  Future<void> assignVehicle(Vehicle vehicle) async {
    try {
      await assignmentService.assign(
        vehicle,
        currentState.pair.device,
        url: connectionBloc.currentState.url,
        token: authBloc.currentState.token,
      );
      devicesBloc.load();
      vehiclesBloc.load();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> unassign() async {
    try {
      await _checkAuth();
      await assignmentService.unassign(
        currentState.pair,
        url: connectionBloc.currentState.url,
        token: authBloc.currentState.token,
      );
      devicesBloc.load();
      vehiclesBloc.load();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> _checkAuth() async {
    final connectionState =
        await connectionBloc.state.firstWhere((state) => !state.loading);
    if (!connectionState.connected) {
      throw NoConnectionException();
    }
    final authState =
        await authBloc.state.firstWhere((state) => !state.loading);
    if (!authState.authorized) {
      throw UnauthorizedException();
    }
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
      print(e);
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

    final vehicle = vehiclesState.vehicles.firstWhere(
      (v) => v.deviceId == deviceId,
      orElse: () => null,
    );
    dispatch(VehicleUpdate(vehicle));
  }

  void _onVehiclesUpdateWithNullId(VehiclesState vehiclesState) {
    if (vehiclesState.hasError || vehiclesState.loading) return;

    final vehicle = vehiclesState.vehicles
        .firstWhere((v) => v.deviceId == deviceId, orElse: () => null);
    if (vehicle != null) {
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
