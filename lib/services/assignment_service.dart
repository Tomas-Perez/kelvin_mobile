import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';

abstract class AssignmentService {
  Future<AssignedPair> getVehiclePair(Vehicle vehicle);

  Future<AssignedPair> getDevicePair(Device device);

  Future assign(Vehicle vehicle, Device device);
}

class MockAssignmentService implements AssignmentService {
  final VehicleService vehicleService;
  final DeviceService deviceService;

  const MockAssignmentService({this.vehicleService, this.deviceService});

  @override
  Future<AssignedPair> getVehiclePair(Vehicle vehicle) async {
    if (vehicle.deviceId == null)
      return AssignedPair(vehicle: vehicle, device: null);

    try {
      final device = await deviceService.getById(vehicle.deviceId);
      return AssignedPair(vehicle: vehicle, device: device);
    } catch (e) {
      print(e);
    }
    return AssignedPair(vehicle: vehicle, device: null);
  }

  @override
  Future<AssignedPair> getDevicePair(Device device) async {
    final vehicles = await vehicleService.getAll();
    final vehicle =
        vehicles.firstWhere((v) => v.deviceId == device.id, orElse: () => null);
    return AssignedPair(vehicle: vehicle, device: device);
  }

  @override
  Future assign(Vehicle vehicle, Device device) async {
    print('Assigning vehicle ${vehicle.id} to device ${device.id}');
  }
}
