import 'package:kelvin_mobile/data.dart';
import 'package:meta/meta.dart';

@immutable
class AssignmentState {
  final AssignedPair pair;
  final bool loading;
  final bool hasError;
  final String errorMessage;
  final bool initialized;

  static final _initialState =
      AssignmentState._(pair: AssignedPair(), initialized: false);

  AssignmentState._({
    this.pair,
    this.loading = false,
    this.hasError = false,
    this.errorMessage = '',
    this.initialized = true,
  });

  factory AssignmentState.initial() => _initialState;

  factory AssignmentState.from(AssignedPair pair) {
    return AssignmentState._(pair: pair);
  }

  AssignmentState setLoading() {
    return AssignmentState._(pair: pair, loading: true);
  }

  AssignmentState setVehicle(Vehicle vehicle) {
    return AssignmentState.from(
      AssignedPair(vehicle: vehicle, device: pair.device),
    );
  }

  AssignmentState setDevice(Device device) {
    return AssignmentState.from(
      AssignedPair(vehicle: pair.vehicle, device: device),
    );
  }

  AssignmentState setError(String message) {
    return AssignmentState._(
      pair: pair,
      hasError: true,
      errorMessage: message,
    );
  }
}
