import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/services/delayed_service.dart';

abstract class DeviceService {
  Future<Device> getById(String id);

  Future<List<Device>> getAll();
}

class MockDeviceService extends DelayedService implements DeviceService {

  MockDeviceService({Duration delay}) : super(delay: delay);

  @override
  Future<Device> getById(String id) =>
      withDelay(devices.firstWhere((d) => d.id == id, orElse: () => null));

  @override
  Future<List<Device>> getAll() => withDelay(devices);

}
