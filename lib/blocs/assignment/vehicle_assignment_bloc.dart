import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment_action.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment_state.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:meta/meta.dart';

class VehicleAssignmentBloc extends Bloc<AssignmentAction, AssignmentState> {
  final DevicesBloc devicesBloc;
  final VehiclesBloc vehiclesBloc;
  final AssignmentService assignmentService;
  final String vehicleId;
  final List<StreamSubscription> _subscriptions = [];

  VehicleAssignmentBloc({
    @required this.devicesBloc,
    @required this.vehiclesBloc,
    @required this.assignmentService,
    this.vehicleId,
  }) {
    // ignore: cancel_subscriptions
    final vehiclesSubs = vehiclesBloc.state.listen(_onVehiclesUpdate);

    // ignore: cancel_subscriptions
    final devicesSubs = devicesBloc.state
        .where((_) =>
            currentState.pair.device != null &&
            currentState.pair.vehicle != null)
        .listen(_onDevicesUpdate);

    _subscriptions.addAll([vehiclesSubs, devicesSubs]);
  }

  Future assignDevice(Device device) async {
    try {
      await assignmentService.assign(currentState.pair.vehicle, device);
      devicesBloc.load();
      vehiclesBloc.load();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future unassign() async {
    try {
      await assignmentService.unassign(currentState.pair);
      devicesBloc.load();
      vehiclesBloc.load();
    } catch (e) {
      print(e);
      throw e;
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

    print('on vehicles update device id');
    print(currentState.pair.vehicle);
    final device = devicesState.devices.firstWhere(
      (d) => d.id == currentState.pair.vehicle.deviceId,
      orElse: () => null,
    );
    dispatch(DeviceUpdate(device));
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
      dispatch(VehicleUpdate(vehicle));
    } catch (e) {
      print(e);
      print('Vehicle not found');
      dispatch(const AssignmentError('Vehicle not found'));
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
    if (event is VehicleUpdate) {
      print(event);
      _onDevicesUpdate(devicesBloc.currentState);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscriptions.forEach((s) => s.cancel());
  }
}
