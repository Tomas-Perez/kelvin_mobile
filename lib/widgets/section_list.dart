import 'package:flutter/material.dart';

class SectionList<H, D> extends StatelessWidget {
  final Map<H, List<D>> sections;
  final Widget Function(BuildContext, H, int) headerBuilder;
  final List<Widget> Function(BuildContext context, List<D> data) bodyBuilder;

  @override
  Widget build(BuildContext context) {
    int sectionIndex = 0;
    return ListView(
      children: sections.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            headerBuilder(context, entry.key, sectionIndex++),
            Column(children: bodyBuilder(context, sections[entry.key])),
          ],
        );
      }).toList(),
    );
  }

  SectionList({this.sections, this.headerBuilder, this.bodyBuilder});
}
