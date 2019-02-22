import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/auth_bloc.dart';
import 'package:kelvin_mobile/blocs/connection_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InputForm(),
            _logoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthAction, AuthState>(
      bloc: authBloc,
      builder: (context, state) {
        if (state.authorized) {
          return RaisedButton(
            child: const Text('Cerrar Sesión'),
            onPressed: () {
              authBloc.logout();
              Navigator.of(context).pop();
            },
            color: Theme.of(context).errorColor,
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  State createState() {
    return InputFormState();
  }
}

class InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  final _urlFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _urlField(),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _urlField() {
    final connectionBloc = BlocProvider.of<ApiConnectionBloc>(context);

    return BlocBuilder<ApiConnectionAction, ApiConnectionState>(
      bloc: connectionBloc,
      builder: (context, state) {
        return Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                initialValue: state.url,
                focusNode: _urlFocus,
                decoration: InputDecoration(
                    labelText: 'URL',
                    icon: Container(
                      width: 20,
                      height: 20,
                      child: _connectionIcon(state, context),
                    )),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'No puede ser vacío';
                  }
                },
                onFieldSubmitted: (term) {
                  _urlFocus.unfocus();
                },
                onSaved: (url) {
                  connectionBloc.updateUrl(url);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _connectionIcon(ApiConnectionState state, BuildContext context) {
    if (state.loading)
      return CircularProgressIndicator(strokeWidth: 2);
    else {
      if (state.connected)
        return Icon(
          Icons.check_circle_outline,
          color: Theme.of(context).accentColor,
        );
      else
        return Icon(
          Icons.error_outline,
          color: Theme.of(context).errorColor,
        );
    }
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        splashColor: Colors.blueGrey,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
          }
        },
        child: Text('Guardar'),
      ),
    );
  }
}
