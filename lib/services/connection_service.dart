
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kelvin_mobile/services/delayed_service.dart';
import 'package:kelvin_mobile/services/errors.dart';

abstract class ApiConnectionService {
  Future<void> checkConnection(String url);
}

class MockConnectionService extends DelayedService
    implements ApiConnectionService {
  MockConnectionService({Duration delay}) : super(delay: delay);

  @override
  Future<void> checkConnection(String url) async {
    return withDelay(null);
  }
}

class HttpConnectionService implements ApiConnectionService {
  @override
  Future<void> checkConnection(String url) async {
    try {
      final res = await http.get('$url/auth/ping').timeout(
          Duration(seconds: 5));

      if (res.statusCode == HttpStatus.ok) {
        return;
      } else if (res.statusCode == HttpStatus.unauthorized) {
        throw NoConnectionException();
      } else {
        throw UnknownResponseException(res);
      }
    } on TimeoutException {
      throw NoConnectionException();
    }
  }
}
