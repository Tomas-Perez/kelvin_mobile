class User {
  String id, username, name, lastName;

  User({this.id, this.username, this.name, this.lastName});
}

class LoginInfo {
  String username, password;

  LoginInfo({this.username, this.password});

  LoginInfo.empty();
}

class Device {
  String id, mac, alias;

  Device({this.id, this.mac, this.alias});
}

class Vehicle {
  String id, ownerId, domain, model, brand, deviceId;
  num wheels;

  Vehicle({this.id, this.ownerId, this.domain, this.wheels, this.model,
      this.brand, this.deviceId});

  @override
  String toString() {
    return 'Vehicle{domain: $domain}';
  }
}
