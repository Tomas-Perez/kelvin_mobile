import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';

abstract class VehicleService{
  Future<Vehicle> getById(String id);

  Future<List<Vehicle>> getAll();
}

class MockVehicleService implements VehicleService {
  final num delay;

  @override
  Future<Vehicle> getById(String id) =>
      _withDelay(vehicles.firstWhere((v) => v.id == id, orElse: () => null));

  @override
  Future<List<Vehicle>> getAll() => _withDelay(vehicles);

  Future<T> _withDelay<T>(T value) =>
      Future.delayed(Duration(milliseconds: delay), () => value);

  const MockVehicleService({this.delay = 0});
}
