import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/services/delayed_service.dart';

abstract class VehicleService {
  Future<Vehicle> getById(String id);

  Future<List<Vehicle>> getAll();
}

class MockVehicleService extends DelayedService implements VehicleService {

  MockVehicleService({Duration delay}) : super(delay: delay);

  @override
  Future<Vehicle> getById(String id) =>
      withDelay(vehicles.firstWhere((v) => v.id == id, orElse: () => null));

  @override
  Future<List<Vehicle>> getAll() => withDelay(vehicles);
}
