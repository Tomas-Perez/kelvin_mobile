import 'package:flutter/material.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/device-screen.dart';
import 'package:kelvin_mobile/home-screen.dart';
import 'package:kelvin_mobile/login-screen.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/vehicle-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelvin',
      home: DeviceScreen(device: devices[0]),
    );
  }
}
