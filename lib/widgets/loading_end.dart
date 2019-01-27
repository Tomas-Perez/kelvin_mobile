import 'package:flutter/material.dart';

class LoadingEnd extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final double size;
  final double strokeWidth;

  LoadingEnd({this.color, this.iconData, this.size, this.strokeWidth = 4});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? Theme.of(context).accentColor,
          width: strokeWidth,
        ),
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: Icon(
        iconData,
        color: color ?? Theme.of(context).accentColor,
      ),
    );
  }
}
