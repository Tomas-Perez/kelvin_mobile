class DeviceErrors {
  const DeviceErrors._();

  static const deviceNotFound = 'DEVICE_NOT_FOUND';
}

class VehicleErrors {
  const VehicleErrors._();

  static const vehicleNotFound = 'VEHICLE_NOT_FOUND';
}

class AuthErrors {
  AuthErrors._();

  static const noConnection = 'NO_CONNECTION';
  static const notAdmin = 'NOT_ADMIN';
  static const unauthorized = 'UNATHORIZED';
  static const invalidCredentials = 'INVALID_CREDENTIALS';
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class NoConnectionException implements AuthException {
  final String message = AuthErrors.noConnection;

  const NoConnectionException();
}

class NotAdminException implements AuthException {
  final String message = AuthErrors.notAdmin;

  const NotAdminException();
}

class UnauthorizedException implements AuthException {
  final String message = AuthErrors.unauthorized;

  const UnauthorizedException();
}

class InvalidCredentialsException implements AuthException {
  final String message = AuthErrors.invalidCredentials;

  const InvalidCredentialsException();
}
