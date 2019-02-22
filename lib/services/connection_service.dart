import 'package:kelvin_mobile/services/delayed_service.dart';

abstract class ApiConnectionService {
  Future<void> checkConnection(String url);
}

class MockConnectionService extends DelayedService implements ApiConnectionService {

  MockConnectionService({Duration delay}) : super (delay: delay);

  @override
  Future<void> checkConnection(String url) async {
    return withDelay(null);
  }

}