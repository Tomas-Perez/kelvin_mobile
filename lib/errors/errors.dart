import 'package:flutter/material.dart';

class Errors {
  Errors._();

  static show(BuildContext context, {Exception exc, String message = GENERIC}) {
    if (exc != null) {
      print(StackTrace.current);
    }

    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static const GENERIC = 'Ocurrio un problema';
  static const INVALID_CODE = 'Código inválido';
  static const NOT_A_VEHICLE = 'El código no pertenece a un vehículo';
  static const NOT_A_DEVICE = 'El código no pertenece a un dispositivo';
}
