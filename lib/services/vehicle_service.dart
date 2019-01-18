import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';

abstract class VehicleService{
  Future<Vehicle> getById(String id);

  Future<List<Vehicle>> getAll();
}

class MockVehicleService implements VehicleService {
  @override
  Future<Vehicle> getById(String id) =>
      Future.value(vehicles.firstWhere((v) => v.id == id));

  @override
  Future<List<Vehicle>> getAll() => Future.value(vehicles);

  const MockVehicleService();
}
