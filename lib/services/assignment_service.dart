import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/errors.dart';
import 'package:kelvin_mobile/services/vehicle_service.dart';
import 'package:meta/meta.dart';

abstract class AssignmentService {
  Future<void> assign(
    Vehicle vehicle,
    Device device, {
    @required String url,
    @required String token,
  });

  Future<void> unassign(
    AssignedPair pair, {
    @required String url,
    @required String token,
  });
}

class MockAssignmentService implements AssignmentService {
  final VehicleService vehicleService;
  final DeviceService deviceService;

  const MockAssignmentService({this.vehicleService, this.deviceService});

  @override
  Future<void> assign(Vehicle vehicle, Device device,
      {@required String url, @required String token}) async {
    final foundVehicle =
        vehicles.firstWhere((v) => v.id == vehicle.id, orElse: () => null);

    if (foundVehicle == null) {
      throw VehicleNotFoundException();
    }

    final foundDevice =
        devices.firstWhere((d) => d.id == device.id, orElse: () => null);

    if (foundDevice == null) {
      throw DeviceNotFoundException();
    }

    vehicles.remove(foundVehicle);
    vehicles.add(
      VehicleModel(
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
  Future<void> unassign(AssignedPair pair,
      {@required String url, @required String token}) async {
    VehicleModel foundVehicle;

    if (pair.vehicle != null) {
      foundVehicle = vehicles.firstWhere((v) => v.id == pair.vehicle.id,
          orElse: () => null);
    } else if (pair.device != null) {
      foundVehicle = vehicles.firstWhere((v) => v.deviceId == pair.device.id,
          orElse: () => null);
    }

    if (foundVehicle == null) {
      throw VehicleNotFoundException();
    }

    vehicles.remove(foundVehicle);
    vehicles.add(
      VehicleModel(
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

class HttpAssignmentService implements AssignmentService {
  @override
  Future<void> assign(
    Vehicle vehicle,
    Device device, {
    @required String url,
    @required String token,
  }) async {
    final res = await http.post('$url/assign/vehicle/${vehicle.id}', headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
    });

    switch (res.statusCode) {
      case HttpStatus.noContent:
        return;
      case HttpStatus.conflict:
        final errorMessage = json.decode(res.body)['message'] as String;
        if (errorMessage.contains('Device')) {
          throw DeviceAssignedException();
        } else if (errorMessage.contains('Vehicle')) {
          throw VehicleAssignedException();
        }
        break;
      case HttpStatus.badRequest:
        throw VehicleNotFoundException();
      case HttpStatus.notFound:
        throw DeviceNotFoundException();
    }
    throw UnknownResponseException();
  }

  @override
  Future<void> unassign(
    AssignedPair pair, {
    @required String url,
    @required String token,
  }) async {
    final res = await http.delete(
      '$url/assign/vehicle/${pair.vehicle.id}',
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (res.statusCode == HttpStatus.ok) {
      return;
    } else if (res.statusCode == HttpStatus.notFound) {
      throw VehicleNotFoundException();
    } else {
      throw UnknownResponseException(res);
    }
  }
}

class AssignmentErrors {
  AssignmentErrors._();

  static const deviceAssigned = 'DEVICE_ASSIGNED';
  static const vehicleAssigned = 'VEHICLE_ASSIGNED';
  static const vehicleNotFound = 'VEHICLE_NOT_FOUND';
  static const deviceNotFound = 'DEVICE_NOT_FOUND';
}

class AssignmentException implements Exception {
  final String message;

  const AssignmentException(this.message);
}

class VehicleNotFoundException implements AssignmentException {
  @override
  final String message = AssignmentErrors.vehicleNotFound;
}

class DeviceNotFoundException implements AssignmentException {
  @override
  final String message = AssignmentErrors.deviceNotFound;
}

class DeviceAssignedException implements AssignmentException {
  @override
  final String message = AssignmentErrors.deviceAssigned;
}

class VehicleAssignedException implements AssignmentException {
  @override
  final String message = AssignmentErrors.vehicleAssigned;
}
