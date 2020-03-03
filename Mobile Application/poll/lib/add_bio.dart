import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddBioForm extends StatefulWidget {
  AddBioFormState createState() {
    return AddBioFormState();
  }
}

class AddBioFormState extends State<AddBioForm> {
  final _addBioState = GlobalKey<FormState>();
  var _data = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _addBioState,
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
                  hintText: 'Enter date of birth',
                  labelText: 'Date of birth',
                  border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Date of birth is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _data.addAll({'date_of_birth': value});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter sex',
                    labelText: 'Sex',
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Sex is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _data.addAll({'sex': value});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter marital status',
                    labelText: 'Marital status',
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Marital status is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _data.addAll({'marital_status': value});
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: 'Enter residence',
                    labelText: 'Residence',
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Residence is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _data.addAll({'residence': value});
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
                  if (_addBioState.currentState.validate()) {
                    _addBioState.currentState.save();

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token');

                    var client = http.Client();
                    try {
                      var response = await client.post(
                        'https://census-ug.herokuapp.com/api/bios',
                        headers: {
                          'Accept': 'application/json',
                          'Authorization': 'Bearer $token'
                        },
                        body: _data
                      );
                      if (response.statusCode == 201) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Bio Added'),)
                        );
                      } else{
                        Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Could not add bio'),)
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

class AddBioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bio'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: AddBioForm(),
        ),
      ),
    );
  }
}