import 'package:flutter/material.dart';
import 'package:kelvin_mobile/widgets/section_list.dart';

class TextSectionList<V> extends StatelessWidget {
  final Map<String, List<V>> sections;
  final String Function(V) valueToString;
  final void Function(V) onTap;

  TextSectionList({
    Key key,
    this.sections,
    this.valueToString,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionList<String, V>(
      sections: sections,
      headerBuilder: (context, name, i) => _sectionHeader(context, name),
      bodyBuilder: (context, data) => _sectionBody(context, data),
    );
  }

  List<Widget> _sectionBody(BuildContext context, List<V> values) {
    return ListTile.divideTiles(
      context: context,
      tiles: values.map((v) {
        return ListTile(
          title: Text(valueToString(v)),
          onTap: () => onTap(v),
        );
      }),
    ).toList();
  }

  Widget _sectionHeader(BuildContext context, String name) {
    return Container(
      child: Text(
        name,
        style: Theme.of(context).textTheme.subhead,
      ),
      color: Theme.of(context).dividerColor,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    );
  }
}
