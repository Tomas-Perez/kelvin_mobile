import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double size;

  const Loading({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(2),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
