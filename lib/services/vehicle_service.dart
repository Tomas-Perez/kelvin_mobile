import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/owners.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/services/delayed_service.dart';
import 'package:kelvin_mobile/services/errors.dart';
import 'package:meta/meta.dart';

abstract class VehicleService {
  Future<List<Vehicle>> getAll({@required String url, @required String token});
}

class MockVehicleService extends DelayedService implements VehicleService {
  MockVehicleService({Duration delay}) : super(delay: delay);

  @override
  Future<List<Vehicle>> getAll({
    @required String url,
    @required String token,
  }) async {
    return _assignOwnersToVehicles(vehicles, owners);
  }
}

class HttpVehicleService implements VehicleService {
  @override
  Future<List<Vehicle>> getAll({String url, String token}) async {
    final usersKey = 'USERS';
    final vehiclesKey = 'VEHICLES';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $token'};

    final responses = await Future.wait([
      http
          .get(
            '$url/vehicle',
            headers: headers,
          )
          .then((res) => MapEntry(vehiclesKey, res)),
      http
          .get(
            '$url/user',
            headers: headers,
          )
          .then((res) => MapEntry(usersKey, res)),
    ]);

    final responseMap = Map.fromEntries(responses);
    final usersRes = responseMap[usersKey];
    final vehiclesRes = responseMap[vehiclesKey];

    if (usersRes.statusCode == HttpStatus.ok &&
        vehiclesRes.statusCode == HttpStatus.ok) {
      final vehicleModels = (json.decode(vehiclesRes.body) as List)
          .map((vJson) => VehicleModel.fromJson(vJson));
      final owners = (json.decode(usersRes.body) as List)
          .map((uJson) => User.fromJson(uJson));
      return _assignOwnersToVehicles(vehicleModels, owners);
    } else {
      _printResponses(usersRes, vehiclesRes);
      throw UnknownResponseException();
    }
  }

  _printResponses(http.Response usersRes, http.Response vehiclesRes) {
    print('USERS_RESPONSE:');
    print(usersRes.statusCode);
    print(usersRes.body);
    print('-------------------------');
    print('VEHICLES_RESPONSE:');
    print(vehiclesRes.statusCode);
    print(vehiclesRes.body);
  }
}

List<Vehicle> _assignOwnersToVehicles(
  Iterable<VehicleModel> vehicleModels,
  Iterable<User> owners,
) {
  return vehicleModels
      .map((v) {
        final owner =
            owners.firstWhere((u) => u.id == v.ownerId, orElse: () => null);
        if (owner == null) return null;
        return Vehicle.fromModel(model: v, owner: owner);
      })
      .where((v) => v != null)
      .toList();
}
