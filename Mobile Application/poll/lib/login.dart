import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _loginState = GlobalKey<FormState>();
  var _data = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginState,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Enter your Email',
                      labelText: 'Email',
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _data.addAll({'email': value});
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Enter your password',
                      labelText: 'Password',
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _data.addAll({'password': value});
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.blue,
                  child: Text(
                    'Submit',
                    style: const TextStyle(color: Colors.white, fontSize: 16) ,
                  ),
                  onPressed: () async {
                    if(_loginState.currentState.validate()) {

                      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
                      if(Platform.isAndroid) {
                        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
                        _data.addAll({'device_name': androidInfo.model});
                      } else if (Platform.isIOS) {
                        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
                        _data.addAll({'device_name': iosDeviceInfo.utsname.machine});
                      }

                      _loginState.currentState.save();

                      var client = http.Client();
                      try {
                        var response = await client.post(
                            'https://census-ug.herokuapp.com/api/token',
                            headers: {
                              'Accept': 'application/json'
                            },
                            body: _data
                        );
                        if (response.statusCode == 200) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Logged In'),)
                          );
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var result = json.decode(response.body);
                          prefs.setString('token', result['token']);
                          Navigator.pushReplacementNamed(context, '/bio');
                        } else{
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Could not loggin user'),)
                          );
                        }
                        print(response.body);
                        print(response.statusCode);
                      } finally {
                        client.close();
                      }

                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('No account? Register...'),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}