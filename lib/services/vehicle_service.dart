import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/owners.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/services/delayed_service.dart';
import 'package:meta/meta.dart';

abstract class VehicleService {
  Future<Vehicle> getById(String id, {@required String url, @required String token});

  Future<List<Vehicle>> getAll({@required String url, @required String token});
}

class MockVehicleService extends DelayedService implements VehicleService {

  MockVehicleService({Duration delay}) : super(delay: delay);

  @override
  Future<Vehicle> getById(String id, {@required String url, @required String token}) async {
    final vehicleModel = await withDelay(vehicles.firstWhere((v) => v.id == id, orElse: () => null));
    if (vehicleModel == null) return null;
    final owner = owners.firstWhere((u) => u.id == vehicleModel.ownerId, orElse: () => null);
    if (owner == null) return null;
    return Vehicle.fromModel(model: vehicleModel, owner: owner);
  }


  @override
  Future<List<Vehicle>> getAll({@required String url, @required String token}) async {
    return vehicles.map((v) {
      final owner = owners.firstWhere((u) => u.id == v.ownerId, orElse: () => null);
      if (owner == null) return null;
      return Vehicle.fromModel(model: v, owner: owner);
    }).where((v) => v != null).toList();
  }
}
