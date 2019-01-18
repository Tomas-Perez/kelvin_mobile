import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';

abstract class DeviceService {
  Future<Device> getById(String id);

  Future<List<Device>> getAll();
}

class MockDeviceService implements DeviceService {
  @override
  Future<Device> getById(String id) =>
      Future.value(devices.firstWhere((d) => d.id == id));

  @override
  Future<List<Device>> getAll() => Future.value(devices);

  const MockDeviceService();
}
