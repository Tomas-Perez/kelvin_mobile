import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(String message, BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sí'),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}

/*
* FutureBuilder(
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return LoadingEnd(
                    iconData: Icons.clear,
                    size: 50,
                    color: Theme.of(context).errorColor,
                  );
                }
                return LoadingEnd(
                  iconData: Icons.check,
                  size: 50,
                );
              case ConnectionState.waiting:
                return Loading(size: 50);

              default:
                return Text('No idea whats happening');
            }
          },
        )
* */
