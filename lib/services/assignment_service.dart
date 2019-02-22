import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
import 'package:meta/meta.dart';

abstract class AssignmentService {
  Future<AssignedPair> getVehiclePair(Vehicle vehicle, {@required String url, @required String token});

  Future<AssignedPair> getDevicePair(Device device, {@required String url, @required String token});

  Future<void> assign(Vehicle vehicle, Device device, {@required String url, @required String token});

  Future<void> unassign(AssignedPair pair, {@required String url, @required String token});
}

class MockAssignmentService implements AssignmentService {
  final VehicleService vehicleService;
  final DeviceService deviceService;

  const MockAssignmentService({this.vehicleService, this.deviceService});

  @override
  Future<AssignedPair> getVehiclePair(Vehicle vehicle, {@required String url, @required String token}) async {
    if (vehicle.deviceId == null)
      return AssignedPair(vehicle: vehicle, device: null);

    try {
      final device = await deviceService.getById(vehicle.deviceId, url: url, token: token);
      return AssignedPair(vehicle: vehicle, device: device);
    } catch (e) {
      print(e);
    }
    return AssignedPair(vehicle: vehicle, device: null);
  }

  @override
  Future<AssignedPair> getDevicePair(Device device, {@required String url, @required String token}) async {
    final vehicles = await vehicleService.getAll(url: url, token: token);
    final vehicle =
        vehicles.firstWhere((v) => v.deviceId == device.id, orElse: () => null);
    return AssignedPair(vehicle: vehicle, device: device);
  }

  @override
  Future<void> assign(Vehicle vehicle, Device device, {@required String url, @required String token}) async {
    final foundVehicle =
        vehicles.firstWhere((v) => v.id == vehicle.id, orElse: () => null);

    if (foundVehicle == null) {
      throw NotFoundException('No vehicle');
    }

    final foundDevice =
        devices.firstWhere((d) => d.id == device.id, orElse: () => null);

    if (foundDevice == null) {
      throw NotFoundException('No device');
    }

    vehicles.remove(foundVehicle);
    vehicles.add(
      Vehicle(
        id: foundVehicle.id,
        ownerId: foundVehicle.ownerId,
        deviceId: foundDevice.id,
        domain: foundVehicle.domain,
        model: foundVehicle.model,
        wheels: foundVehicle.wheels,
        brand: foundVehicle.brand,
      ),
    );
  }

  @override
  Future<void> unassign(AssignedPair pair, {@required String url, @required String token}) async {
    Vehicle foundVehicle;

    if (pair.vehicle != null) {
      foundVehicle =
          vehicles.firstWhere((v) => v.id == pair.vehicle.id, orElse: () => null);
    } else if (pair.device != null) {
      foundVehicle = vehicles.firstWhere((v) => v.deviceId == pair.device.id,
          orElse: () => null);
    }

    if (foundVehicle == null) {
      throw NotFoundException('No vehicle');
    }

    vehicles.remove(foundVehicle);
    vehicles.add(
      Vehicle(
        id: foundVehicle.id,
        ownerId: foundVehicle.ownerId,
        deviceId: null,
        domain: foundVehicle.domain,
        model: foundVehicle.model,
        wheels: foundVehicle.wheels,
        brand: foundVehicle.brand,
      ),
    );
  }
}

class NotFoundException implements Exception {
  final String message;

  const NotFoundException(this.message);
}
