import 'package:kelvin_mobile/blocs/assignment/assignment_state.dart';
import 'package:kelvin_mobile/data.dart';

abstract class AssignmentAction {
  const AssignmentAction();

  AssignmentState perform(AssignmentState state) => state;
}

class AssignmentError extends AssignmentAction {
  final String errorMessage;

  const AssignmentError(this.errorMessage);

  @override
  AssignmentState perform(AssignmentState state) {
    return state.setError(errorMessage);
  }
}

class AssignmentLoading extends AssignmentAction {
  const AssignmentLoading();

  @override
  AssignmentState perform(AssignmentState state) {
    return state.setLoading();
  }
}

class VehicleUpdate extends AssignmentAction {
  final Vehicle vehicle;

  VehicleUpdate(this.vehicle);

  @override
  AssignmentState perform(AssignmentState state) {
    return state.setVehicle(vehicle);
  }
}

class DeviceUpdate extends AssignmentAction {
  final Device device;

  DeviceUpdate(this.device);

  @override
  AssignmentState perform(AssignmentState state) {
    return state.setDevice(device);
  }
}

class Unassign extends AssignmentAction {
  const Unassign();
}

class UnassignPending extends AssignmentAction {
  const UnassignPending();
}

class UnassignSuccess extends AssignmentAction {
  const UnassignSuccess();
}

class UnassignError extends AssignmentAction {
  final String errorMessage;

  const UnassignError(this.errorMessage);
}
