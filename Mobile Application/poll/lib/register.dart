import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterForm extends StatefulWidget {
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _registerState = GlobalKey<FormState>();
  var _data = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerState,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  labelText: 'Full name',
                  border: OutlineInputBorder()
                ),
                validator: (value) {
                  if(value.isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _data.addAll({'name': value});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter email',
                  labelText: 'Email',
                  border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value.isEmpty) {
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
                    hintText: 'Enter password',
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
                  style: const TextStyle(color: Colors.white, fontSize: 16) ,),
                onPressed: () async {
                  if (_registerState.currentState.validate()) {
                    _registerState.currentState.save();

                    var client = http.Client();
                    try {
                      var response = await client.post(
                        'https://census-ug.herokuapp.com/api/users',
                        headers: {
                          'Accept': 'application/json'
                        },
                        body: _data
                      );
                      if (response.statusCode == 201) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Registered'),)
                        );
                      } else{
                        Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Could not register user'),)
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
            )
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: RegisterForm(),
        ),
      ),
    );
  }
}