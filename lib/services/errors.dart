import 'package:http/http.dart' as http;

class HttpErrors {
  const HttpErrors._();

  static const unknownResponse = 'UNKNOWN_RESPONSE';
}

class HttpException {
  final String message;

  const HttpException(this.message);
}

class UnknownResponseException {
  final String message = HttpErrors.unknownResponse;

  UnknownResponseException([http.Response res]) {
    if (res != null) {
      print(res.statusCode);
      print(res.body);
    }
  }
}

class AuthErrors {
  AuthErrors._();

  static const invalidCredentials = 'INVALID_CREDENTIALS';
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class InvalidCredentialsException implements AuthException {
  final String message = AuthErrors.invalidCredentials;
}

class ConnectionErrors {
  ConnectionErrors._();

  static const noConnection = 'NO_CONNECTION';
  static const timeout = 'TIMEOUT';
}

class ConnectionException implements Exception {
  final String message;

  const ConnectionException(this.message);
}

class NoConnectionException implements ConnectionException {
  final String message = ConnectionErrors.noConnection;
}

class TimeoutException implements ConnectionException {
  final String message = ConnectionErrors.timeout;
}