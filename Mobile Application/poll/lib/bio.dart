import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Bio>> fetchBios() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  var client = http.Client();
  final response = await client.get('https://census-ug.herokuapp.com/api/bios',
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }
  );
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((bio) => new Bio.fromJson(bio)).toList();
  } else {
    throw Exception('Failed to load API');
  }
}

class Bio {
  final int id;
  final String name;
  final String dateOfBirth;
  final String sex;
  final String maritalStatus;
  final String residence;

  Bio({this.id, this.name, this.dateOfBirth, this.sex, this.maritalStatus,
    this.residence});

  factory Bio.fromJson(Map<String, dynamic> bio) {
    return Bio(
      id: bio['id'],
      name: bio['name'],
      dateOfBirth: bio['date_of_birth'],
      sex: bio['sex'],
      maritalStatus: bio['marital_status'],
      residence: bio['residence']
    );
  }
}

class BioList extends StatefulWidget {
  BioListState createState() {
    return BioListState();
  }
}

class BioListState extends State<BioList> {
  Future<List<Bio>> futureBios;

  @override
  void initState() {
    super.initState();
    futureBios = fetchBios();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bio>>(
      future: futureBios,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Bio> _bios = snapshot.data;
          return ListView.builder(
            itemCount: _bios.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ListTile(
                title: Text(_bios[index].name),
                leading: Icon(Icons.person),
                subtitle: Text(_bios[index].residence),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/edit_bio',
                                arguments: _bios[index]);
                          },
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Text('Deletion'),
                                  content: Text('Are you sure you want to delete ${_bios[index].name} ?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        final token = prefs.getString('token');
                                        var client = http.Client();
                                        final response = await client.delete('https://census-ug.herokuapp.com/api/bios/${_bios[index].id}',
                                            headers: {
                                              'Accept': 'application/json',
                                              'Authorization': 'Bearer $token'
                                            }
                                        );
                                        Navigator.pop(context);
                                        if (response.statusCode == 204) {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(content: Text('${_bios[index].name} deleted'),)
                                          );
                                        } else{
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(content: Text('Could not delete ${_bios[index].name}'),)
                                          );
                                        }
                                      },
                                    )
                                  ],
                                );
                              }
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              );
            }
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class BioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bio'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/bio');
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_power),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              Navigator.pushReplacementNamed(context, '/');
            },
          )
        ],
      ),
      body: Center(
        child: BioList()
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new Bio',
        child: Icon(
          Icons.person_add
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/add_bio');
        },
      ),
    );
  }
}