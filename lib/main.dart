import 'package:flutter/material.dart';
import 'package:kelvin_mobile/mock/devices.dart';
import 'package:kelvin_mobile/screens/devices-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelvin',
      home: DevicesScreen(
        devices: devices,
      ),
    );
  }
}
