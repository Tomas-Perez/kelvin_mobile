import 'package:flutter/material.dart';

class Errors {
  Errors._();

  static show(BuildContext context, {exc, String message = generic}) {
    if (exc != null) {
      print(exc);
      print(StackTrace.current);
    }

    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static const generic = 'Ocurrio un problema';
  static const invalidCode = 'Código inválido';
  static const notAVehicle = 'El código no pertenece a un vehículo';
  static const notADevice = 'El código no pertenece a un dispositivo';
  static const vehicleNotFound = 'El vehículo no existe';
  static const deviceNotFound = 'El dispositivo no existe';
}
