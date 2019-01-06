import 'package:flutter/material.dart';
import 'package:kelvin_mobile/mock/vehicles.dart';
import 'package:kelvin_mobile/screens/vehicles-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelvin',
      home: VehiclesScreen(
        vehicles: vehicles,
      ),
    );
  }
}
