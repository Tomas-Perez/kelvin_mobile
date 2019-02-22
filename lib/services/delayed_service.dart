import 'package:meta/meta.dart';

class DelayedService {
  final Duration delay;

  DelayedService({Duration delay}): this.delay = delay ?? Duration();

  @protected
  Future<T> withDelay<T>(T value) => Future.delayed(delay, () => value);
}
