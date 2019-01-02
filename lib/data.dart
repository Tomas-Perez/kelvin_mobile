class User {
  String id, username, name, lastName;

  User(this.id, this.username, this.name, this.lastName);
}

class LoginInfo {
  String username, password;

  LoginInfo(this.username, this.password);

  LoginInfo.empty();
}

class Device {
  String id, mac, alias;

  Device(this.id, this.mac, this.alias);
}

class Vehicle {
  String id, ownerId, domain, wheels, model, brand, deviceId;

  Vehicle(this.id, this.ownerId, this.domain, this.wheels, this.model,
      this.brand, this.deviceId);
}
