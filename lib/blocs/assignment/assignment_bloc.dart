import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment_action.dart';
import 'package:kelvin_mobile/blocs/assignment/assignment_state.dart';
import 'package:kelvin_mobile/blocs/devices_bloc.dart';
import 'package:kelvin_mobile/blocs/vehicles_bloc.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/assignment_service.dart';
import 'package:meta/meta.dart';

abstract class AssignmentBloc extends Bloc<AssignmentAction, AssignmentState> {
  final DevicesBloc devicesBloc;
  final VehiclesBloc vehiclesBloc;
  final AssignmentService assignmentService;

  AssignmentBloc({
    @required this.devicesBloc,
    @required this.vehiclesBloc,
    @required this.assignmentService,
  });

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

  Future assignVehicle(Vehicle vehicle) async {
    try {
      await assignmentService.assign(vehicle, currentState.pair.device);
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

  @override
  AssignmentState get initialState => AssignmentState.initial();

  @override
  Stream<AssignmentState> mapEventToState(
    AssignmentState currentState,
    AssignmentAction event,
  ) async* {
    yield event.perform(currentState);
  }
}
