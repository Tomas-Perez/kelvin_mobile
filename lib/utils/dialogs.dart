import 'package:flutter/material.dart';
import 'package:kelvin_mobile/widgets/loading.dart';

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

Future<DialogResult<T>> showLoadingDialog<T>(Future<T> run, BuildContext context,
    {String text}) {
  var shown = true;
  return showDialog<DialogResult<T>>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      run.then((value) {
        if (shown) Navigator.pop(context, DialogResult.from(value));
      });
      return AlertDialog(
        title: Column(
          children: <Widget>[
            Text(text),
            SizedBox(height: 30.0),
            Loading(),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              shown = false;
              Navigator.pop(context, DialogResult<T>.dismissed());
            },
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

class DialogResult<R>{
  final R result;
  final bool dismissed;

  DialogResult.from(this.result) : dismissed = false;
  DialogResult.dismissed() : result = null, dismissed = true;
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
