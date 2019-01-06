import 'package:flutter/material.dart';

typedef SectionBuilder<H> = Widget Function(
  BuildContext context,
  H data,
  int index,
);

typedef BodyBuilder<D> = List<Widget> Function(
  BuildContext context,
  List<D> data,
);

class SectionList<H, D> extends StatelessWidget {
  final Map<H, List<D>> sections;
  final SectionBuilder<H> headerBuilder;
  final BodyBuilder<D> bodyBuilder;

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
