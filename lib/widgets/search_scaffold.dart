import 'package:flutter/material.dart';

class SearchScaffold extends StatefulWidget {
  final Widget Function(BuildContext, String) bodyBuilder;
  final String title;
  final String searchHint;

  /// See [Scaffold]
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final List<Widget> persistentFooterButtons;
  final Widget drawer;
  final Widget endDrawer;
  final Color backgroundColor;
  final Widget bottomNavigationBar;
  final Widget bottomSheet;
  final bool resizeToAvoidBottomPadding;
  final bool primary;

  @override
  State createState() => _SearchScaffoldState();

  SearchScaffold({
    Key key,
    @required this.bodyBuilder,
    @required this.title,
    @required this.searchHint,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomPadding = true,
    this.primary = true,
  });
}

class _SearchScaffoldState extends State<SearchScaffold> {
  bool _searching = false;
  String _search = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _search = _controller.value.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.key,
      appBar: _appBar(),
      body: widget.bodyBuilder(context, _search),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      persistentFooterButtons: widget.persistentFooterButtons,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomPadding: widget.resizeToAvoidBottomPadding,
      primary: widget.primary,
    );
  }

  void _handleSearch() {
    this.setState(() {
      _searching = true;
    });
  }

  void _handleCancel() {
    this.setState(() {
      _controller.clear();
      _searching = false;
    });
  }

  AppBar _appBar() {
    return _searching ? _searchBar() : _titleBar();
  }

  AppBar _titleBar() {
    return AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          onPressed: _handleSearch,
          tooltip: 'Buscar',
          icon: Icon(Icons.search),
        )
      ],
    );
  }

  AppBar _searchBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).textTheme.title.color),
      title: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration.collapsed(hintText: widget.searchHint),
        style: Theme.of(context).textTheme.title,
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      actions: <Widget>[
        IconButton(
          onPressed: _handleCancel,
          tooltip: 'Cancelar',
          icon: Icon(Icons.clear),
        )
      ],
    );
  }
}
