import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kelvin_mobile/blocs/auth_bloc.dart';
import 'package:kelvin_mobile/blocs/errors.dart';
import 'package:kelvin_mobile/data.dart';
import 'package:kelvin_mobile/screens/errors.dart';
import 'package:kelvin_mobile/screens/settings_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
        actions: <Widget>[
          IconButton(
            onPressed: () => _pushSettingsScreen(context),
            tooltip: 'Ajustes',
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _logoHeader(),
            InputForm(),
            _feedback(context),
          ],
        ),
      ),
    );
  }

  Center _feedback(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 80.0),
        child: BlocBuilder<AuthAction, AuthState>(
          bloc: BlocProvider.of<AuthBloc>(context),
          builder: (context, state) {
            if (state.loading) {
              return CircularProgressIndicator();
            } else if (state.hasError) {
              switch (state.errorMessage) {
                case AuthErrors.notAdmin:
                  return Text(Errors.appNotAvailable);
                case AuthErrors.noConnection:
                  return Text(Errors.noConnection);
                case AuthErrors.invalidCredentials:
                  return Text(Errors.invalidCredentials);
                default:
                  return Text(Errors.generic);
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  void _pushSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => SettingsScreen(),
      ),
    );
  }

  Widget _logoHeader() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(75.0),
          color: Colors.white,
        ),
        height: 150,
        width: 150,
        child: Center(
          child: Image(
            image: AssetImage('assets/kelvin-logo.png'),
            height: 80,
          ),
        ),
      ),
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
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final loginInfo = LoginInfo.empty();
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _usernameField(),
          _passwordField(),
          _submitButton(),
        ],
      ),
    );
  }

  TextFormField _usernameField() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      focusNode: _usernameFocus,
      decoration: InputDecoration(
        labelText: 'Usuario',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'No puede ser vacío';
        }
      },
      onFieldSubmitted: (term) {
        _usernameFocus.unfocus();
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
      onSaved: (username) {
        loginInfo.username = username;
      },
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
      focusNode: _passwordFocus,
      validator: (value) {
        if (value.isEmpty) {
          return 'No puede ser vacío';
        }
      },
      onFieldSubmitted: (_) => _submit(),
      onSaved: (password) {
        loginInfo.password = password;
      },
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        splashColor: Colors.blueGrey,
        onPressed: _submit,
        child: Text('Iniciar sesión'),
      ),
    );
  }

  void _submit() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    if (_formKey.currentState.validate()) {
      _passwordFocus.unfocus();
      _usernameFocus.unfocus();
      _formKey.currentState.save();
      authBloc.login(loginInfo);
    }
  }

  @override
  void initState() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
    _subscription = authBloc.state
        .where((state) => state.authorized)
        .listen((_) => _formKey.currentState.reset());
  }

  @override
  void dispose() {
    print('disposing login');
    super.dispose();
    _subscription.cancel();
  }
}
