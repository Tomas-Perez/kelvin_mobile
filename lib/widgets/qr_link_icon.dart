import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kelvin_mobile/presentation/custom_icons_icons.dart';

class QRLinkIcon extends StatelessWidget {

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
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Icon(Icons.link),
            ),
          ),
        ),
      ],
    );
  }
}