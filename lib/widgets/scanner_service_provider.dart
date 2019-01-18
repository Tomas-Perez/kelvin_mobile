import 'package:flutter/widgets.dart';
import 'package:kelvin_mobile/services/scanner_service.dart';

class ScannerServiceProvider extends InheritedWidget {
  final Widget child;
  final ScannerService scannerService;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ScannerService of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(ScannerServiceProvider)
      as ScannerServiceProvider)
          .scannerService;

  ScannerServiceProvider({Key key, this.child, this.scannerService})
      : super(key: key);
}