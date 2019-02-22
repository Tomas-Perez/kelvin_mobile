import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/services/delayed_service.dart';
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
