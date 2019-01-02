import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kelvin_mobile/data.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
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
            InputForm(),
          ],
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
  LoginInfo loginInfo = LoginInfo.empty();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'username',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
            onSaved: (username) {
              loginInfo.username = username;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'password'),
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
            },
            onSaved: (password) {
              loginInfo.password = password;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              splashColor: Colors.blueGrey,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${loginInfo.username} / ${loginInfo.password}')));
                }
              },
              child: Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
