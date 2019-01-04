import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kelvin_mobile/data.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            _logoHeader(),
            InputForm(),
          ],
        ),
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
      decoration: InputDecoration(labelText: 'Contraseña'),
      obscureText: true,
      focusNode: _passwordFocus,
      validator: (value) {
        if (value.isEmpty) {
          return 'No puedee ser vacío';
        }
      },
      onFieldSubmitted: (term) {
        _passwordFocus.unfocus();
      },
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
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Scaffold.of(context).showSnackBar(SnackBar(
                content:
                    Text('${loginInfo.username} / ${loginInfo.password}')));
          }
        },
        child: Text('Iniciar sesión'),
      ),
    );
  }
}
