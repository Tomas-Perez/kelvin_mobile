import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/services/delayed_service.dart';
import 'package:meta/meta.dart';

abstract class DeviceService {
  Future<Device> getById(String id, {@required String url, @required String token});

  Future<List<Device>> getAll({@required String url, @required String token});
}

class MockDeviceService extends DelayedService implements DeviceService {

  MockDeviceService({Duration delay}) : super(delay: delay);

  @override
  Future<Device> getById(String id, {@required String url, @required String token}) =>
      withDelay(devices.firstWhere((d) => d.id == id, orElse: () => null));

  @override
  Future<List<Device>> getAll({@required String url, @required String token}) => withDelay(devices);

}
