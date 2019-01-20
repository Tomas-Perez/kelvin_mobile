import 'package:flutter/material.dart';
import 'package:kelvin_mobile/services/device_service.dart';
import 'package:kelvin_mobile/services/link_parser.dart';

class LinkParserProvider extends InheritedWidget {
  final Widget child;
  final LinkParser linkParser;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LinkParser of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LinkParserProvider)
              as LinkParserProvider)
          .linkParser;

  const LinkParserProvider({Key key, this.child, this.linkParser})
      : super(key: key);
}
