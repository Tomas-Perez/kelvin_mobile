import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

abstract class ScannerService {
  Future<String> scan();
}

class ScannerException implements Exception {
  final String message;

  const ScannerException(this.message);
}

class AccessDeniedException implements ScannerException {
  final String message = 'The user did not grant camera permissions';

  const AccessDeniedException();
}

class BackButtonException implements ScannerException {
  final String message = 'User returned using the back button';

  const BackButtonException();
}

class QRScannerService implements ScannerService {
  @override
  Future<String> scan() async {
    try {
      return await BarcodeScanner.scan();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        throw const AccessDeniedException();
      } else {
        throw ScannerException(e.toString());
      }
    } on FormatException {
      throw const BackButtonException();
    } catch (e) {
      throw ScannerException(e.toString());
    }
  }
}

class MockScannerService implements ScannerService {
  final String Function() onScan;

  MockScannerService({this.onScan});

  @override
  Future<String> scan() => Future.value(onScan());
}
