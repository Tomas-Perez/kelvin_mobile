import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/services/delayed_service.dart';
import 'package:kelvin_mobile/services/errors.dart';
import 'package:meta/meta.dart';

abstract class DeviceService {
  Future<List<Device>> getAll({@required String url, @required String token});
}

class MockDeviceService extends DelayedService implements DeviceService {
  MockDeviceService({Duration delay}) : super(delay: delay);

  @override
  Future<List<Device>> getAll({@required String url, @required String token}) =>
      withDelay(devices);
}

class HttpDeviceService implements DeviceService {
  @override
  Future<List<Device>> getAll({
    @required String url,
    @required String token,
  }) async {
    final res = await http.get(
      '$url/device',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (res.statusCode == HttpStatus.ok) {
      return (json.decode(res.body) as List)
          .map((dJson) => Device.fromJson(dJson))
          .toList();
    } else {
      throw UnknownResponseException(res);
    }
  }
}
