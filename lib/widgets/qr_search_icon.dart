import 'package:flutter/material.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';

class QRSearchIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned.fill(
          top: -3.0,
          left: 5.0,
          child: Icon(CustomIcons.qrcode),
        ),
        Positioned(
          left: 8.0,
          bottom: 7.0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).accentColor,
            ),
            child: Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}