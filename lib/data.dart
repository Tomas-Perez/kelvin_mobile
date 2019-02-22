class User {
  final String id, username, name, lastName;
  final UserType userType;

  User({this.id, this.username, this.name, this.lastName, this.userType});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      lastName: json['lastName'],
      userType: json['type'] == 'ADMIN' ? UserType.admin : UserType.client,
    );
  }
}

enum UserType { admin, client }

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

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      mac: json['mac'],
      alias: json['alias'],
    );
  }
}

class Vehicle {
  final String id, ownerName, domain, model, brand, deviceId;
  final num wheels;

  Vehicle({
    this.id,
    this.ownerName,
    this.domain,
    this.wheels,
    this.model,
    this.brand,
    this.deviceId,
  });

  Vehicle.fromModel({VehicleModel model, User owner})
      : ownerName = owner.username,
        id = model.id,
        domain = model.domain,
        model = model.model,
        brand = model.brand,
        deviceId = model.deviceId,
        wheels = model.wheels;
}

class VehicleModel {
  final String id, ownerId, domain, model, brand, deviceId;
  final num wheels;

  VehicleModel(
      {this.id,
      this.ownerId,
      this.domain,
      this.wheels,
      this.model,
      this.brand,
      this.deviceId});

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      ownerId: json['ownerId'],
      domain: json['domain'],
      wheels: json['wheels'],
      model: json['model'],
      brand: json['brand'],
      deviceId: json['deviceId'],
    );
  }
}

class AssignedPair {
  final Vehicle vehicle;
  final Device device;

  AssignedPair({this.vehicle, this.device});
}
