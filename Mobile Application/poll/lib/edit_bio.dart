import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'bio.dart';

class EditBioForm extends StatefulWidget {
  final Bio bio;
  EditBioFormState createState() {
    return EditBioFormState(bio: bio);
  }

  EditBioForm({this.bio});
}

class EditBioFormState extends State<EditBioForm> {
  final Bio bio;
  final _editBioState = GlobalKey<FormState>();
  var _data = {};

  EditBioFormState({this.bio});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _editBioState,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: TextFormField(
                initialValue: this.bio.name,
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
                initialValue: this.bio.dateOfBirth,
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
                initialValue: this.bio.sex,
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
                initialValue: this.bio.maritalStatus,
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
                initialValue: this.bio.residence,
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
                  if (_editBioState.currentState.validate()) {
                    _editBioState.currentState.save();

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('token');

                    var client = http.Client();
                    try {
                      var response = await client.put(
                        'https://census-ug.herokuapp.com/api/bios/${this.bio.id}',
                        headers: {
                          'Accept': 'application/json',
                          'Authorization': 'Bearer $token'
                        },
                        body: _data
                      );
                      if (response.statusCode == 200) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Bio Updated'),)
                        );
                      } else{
                        Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Could not update bio'),)
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

class EditBioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Bio _bio = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bio'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child:  EditBioForm(bio: _bio,),
        ),
      )
    );
  }
}