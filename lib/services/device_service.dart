import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/mock/devices.dart';

abstract class DeviceService {
  Future<Device> getById(String id);

  Future<List<Device>> getAll();
}

class MockDeviceService implements DeviceService {
  final num delay;

  @override
  Future<Device> getById(String id) =>
      _withDelay(devices.firstWhere((d) => d.id == id, orElse: () => null));

  @override
  Future<List<Device>> getAll() => _withDelay(devices);

  Future<T> _withDelay<T>(T value) =>
      Future.delayed(Duration(milliseconds: delay), () => value);

  const MockDeviceService({this.delay = 0});
}
