class User {
  final String id, username, name, lastName;
  final UserType userType;

  User({this.id, this.username, this.name, this.lastName, this.userType});
}

enum UserType {
  admin, client
}

class LoginInfo {
  String username, password;

  LoginInfo({this.username, this.password});

  LoginInfo.empty();

  @override
  String toString() {
    return '$username, $password';
  }
}

class Device {
  final String id, mac, alias;

  Device({this.id, this.mac, this.alias});
}

class Vehicle {
  final String id, ownerId, domain, model, brand, deviceId;
  final num wheels;

  Vehicle({this.id, this.ownerId, this.domain, this.wheels, this.model,
      this.brand, this.deviceId});
}

class AssignedPair {
  final Vehicle vehicle;
  final Device device;

  AssignedPair({this.vehicle, this.device});
}
