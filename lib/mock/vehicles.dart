import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';

final vehicles = [
  VehicleModel(
    id: '123918223',
    ownerId: '1231242',
    domain: 'AAA-233',
    wheels: 4,
    model: 'Corsa',
    brand: 'Chevrolet',
    deviceId: null,
  ),
  VehicleModel(
    id: '2131243294',
    ownerId: '1231242',
    domain: 'BBB-231',
    wheels: 2,
    model: '110',
    brand: 'Zanella',
    deviceId: devices[0].id,
  ),
  VehicleModel(
    id: '232096570',
    ownerId: '2381290',
    domain: 'AZ-232-RE',
    wheels: 10,
    model: 'Something',
    brand: 'Scania',
    deviceId: devices[1].id,
  ),
  VehicleModel(
    id: '2394023043',
    ownerId: '2381290',
    domain: 'DS-231-AZ',
    wheels: 12,
    model: 'Else',
    brand: 'Mercedes-Benz',
    deviceId: devices[2].id,
  ),
  VehicleModel(
    id: '12039059340',
    ownerId: '2381290',
    domain: 'BXZ-832',
    wheels: 8,
    model: 'Giff',
    brand: 'Volvo',
    deviceId: devices[3].id,
  ),
];
