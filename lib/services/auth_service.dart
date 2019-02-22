import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/delayed_service.dart';
import 'package:kelvin_mobile/services/errors.dart';
import 'package:meta/meta.dart';

abstract class AuthService {
  Future<String> login(LoginInfo loginInfo, {@required String url});

  Future<User> getUserData(String token, {@required String url});
}

class MockAuthService extends DelayedService implements AuthService {
  MockAuthService({Duration delay}) : super(delay: delay);

  @override
  Future<String> login(LoginInfo loginInfo, {@required String url}) async {
    print(loginInfo);
    return withDelay('token');
  }

  @override
  Future<User> getUserData(String token, {@required String url}) async {
    print(token);
    return withDelay(User(
      id: 'dasdsad',
      username: 'admin',
      name: 'mr',
      lastName: 'admin',
      userType: UserType.admin,
    ));
  }
}

class HttpAuthService implements AuthService {
  const HttpAuthService();

  @override
  Future<String> login(LoginInfo loginInfo, {@required String url}) async {
    final res = await http.post(
      '$url/auth',
      body: json.encode(
          {"username": loginInfo.username, "password": loginInfo.password}),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (res.statusCode == HttpStatus.ok) {
      return json.decode(res.body)['token'];
    } else if (res.statusCode == HttpStatus.unauthorized) {
      throw InvalidCredentialsException();
    } else {
      throw UnknownResponseException(res);
    }
  }

  @override
  Future<User> getUserData(String token, {@required String url}) async {
    final res = await http.get(
      url + '/user/me',
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (res.statusCode == HttpStatus.ok) {
      return User.fromJson(json.decode(res.body));
    } else if (res.statusCode == HttpStatus.unauthorized) {
      throw InvalidCredentialsException();
    } else {
      throw UnknownResponseException(res);
    }
  }
}
