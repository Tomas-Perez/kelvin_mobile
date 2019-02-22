import 'package:kelvin_mobile/data.dart';
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
  Future<Vehicle> getById(String id, {@required String url, @required String token}) =>
      withDelay(vehicles.firstWhere((v) => v.id == id, orElse: () => null));

  @override
  Future<List<Vehicle>> getAll({@required String url, @required String token}) => withDelay(vehicles);
}
