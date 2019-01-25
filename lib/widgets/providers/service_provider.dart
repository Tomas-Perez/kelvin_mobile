import 'package:flutter/widgets.dart';

class ServiceProvider<T> extends InheritedWidget {
  ServiceProvider({
    Key key,
    @required this.child,
    @required this.service,
  }): super(key: key);

  final T service;
  final Widget child;

  static T of<T>(BuildContext context){
    final type = _typeOf<ServiceProvider<T>>();
    ServiceProvider<T> provider = context.inheritFromWidgetOfExactType(type);
    return provider.service;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static Type _typeOf<T>() => T;
}